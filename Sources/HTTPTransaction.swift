//
// Copyright 2018 - Present Hyperwallet
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software
// and associated documentation files (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge, publish, distribute,
// sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
// BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Foundation
import os.log

/// Builds and performs the HTTP request
final class HTTPTransaction {
    private let provider: HyperwalletAuthenticationTokenProvider
    private let httpClient: HTTPClientProtocol
    private(set) var configuration: Configuration?

    init(provider: HyperwalletAuthenticationTokenProvider,
         httpClient: HTTPClientProtocol = HTTPClient(configuration: HTTPTransaction.urlSessionConfiguration)) {
        self.provider = provider
        self.httpClient = httpClient
    }

    func invalidate() {
        self.httpClient.invalidateSession()
    }

    /// Performs the HTTP `GraphQL` request .
    ///
    /// - Parameters:
    ///   - payload: The payload will contain GraphQl query.
    ///   - completionHandler: The completionHandler should be performed at the end of request
    ///  with the data or `HyperwalletError`.
    func performGraphQl<Request, Response>(_ payload: Request,
                                           completionHandler handler: @escaping (_ response: Response?,
        _ error: HyperwalletErrorType?) -> Void)
        where Request: GraphQlQuery, Response: Codable {
            perform(transactionType: .graphQl,
                    httpMethod: .post,
                    payload: payload,
                    completionHandler: HTTPTransaction.graphQlHandler(handler))
    }

    /// Performs the HTTP `Rest` request .
    ///
    ///
    /// - Parameters: httpMethod - The HTTP verb should be performed the request.
    /// - Parameters: urlPath - The URL path.
    /// - Parameters: payload - The payload will contain GraphQl query.
    /// - Parameters: queryParam - The criteria to build the URL query.
    /// - Parameters: completionHandler - The completionHandler should be performed at the end of request
    ///  with the data or `HyperwalletError`.
    func performRest<Request, Response>(httpMethod: HTTPMethod,
                                        urlPath: String,
                                        payload: Request,
                                        queryParam: QueryParam? = nil,
                                        completionHandler handler: @escaping (_ response: Response?,
                                                                              _ error: HyperwalletErrorType?) -> Void)
        where Request: Encodable, Response: Decodable {
            perform(transactionType: .rest,
                    httpMethod: httpMethod,
                    urlPath: urlPath,
                    payload: payload,
                    urlQuery: queryParam?.toQuery(),
                    completionHandler: handler)
    }

    /// Performs the HTTP `transactionType` request.
    ///
    /// - Parameters:
    ///   - transactionType: The HTTP `transactionType` request.
    ///   - httpMethod: The HTTP verb.
    ///   - urlPath: The URL path.
    ///   - payload: The request payload.
    ///   - urlQuery: The URL query.
    ///   - handler: The completion handler should be performed at the end of request with the data or `ErrorType`.
    private func perform<Request, Response>(transactionType: TransactionType,
                                            httpMethod: HTTPMethod,
                                            urlPath: String = "",
                                            payload: Request?,
                                            urlQuery: [String: String]? = nil,
                                            completionHandler handler: @escaping ((_ response: Response?,
        _ error: HyperwalletErrorType?) -> Void))
        where Request: Encodable, Response: Decodable {
            if let configuration = configuration, !configuration.isTokenStale() {
                performRequest(transactionType, httpMethod, urlPath, urlQuery, payload, handler)
            } else {
                provider.retrieveAuthenticationToken(completionHandler:
                    authenticationTokenHandler(
                        transactionType,
                        httpMethod,
                        urlPath,
                        urlQuery,
                        payload,
                        handler))
            }
    }

    /// Performs the HTTP request
    ///
    /// - Parameters:
    ///   - transactionType: The transaction type defines the base url
    ///   - httpMethod: The HTTP verb should be performed the request
    ///   - urlPath: The URL path
    ///   - urlQuery: The URL query
    ///   - payload: The payload be sent in the request
    ///   - completionHandler: The completionHandler should be performed at the end of request
    private func performRequest<Request, Response>(_ transactionType: TransactionType,
                                                   _ httpMethod: HTTPMethod,
                                                   _ urlPath: String,
                                                   _ urlQuery: [String: String]? = nil,
                                                   _ payload: Request?,
                                                   _ completionHandler: @escaping (_ response: Response?,
                                                                                _ error: HyperwalletErrorType?) -> Void)
        where Request: Encodable, Response: Decodable {
            if let configuration = configuration {
                do {
                    let request = try transactionType.createRequest(configuration,
                                                                    method: httpMethod,
                                                                    urlPath: urlPath,
                                                                    urlQuery: urlQuery,
                                                                    httpBody: payload)
                    httpClient.perform(with: request,
                                       completionHandler: HTTPTransaction.requestHandler(completionHandler))
                } catch {
                    completionHandler(nil, ErrorTypeHelper.invalidRequest(for: error))
                }
            } else {
                completionHandler(nil, ErrorTypeHelper.unexpectedError())
            }
    }

    private static func graphQlHandler<Response>(_ completionHandler:
        @escaping (_ response: Response?,
        _ error: HyperwalletErrorType?) -> Void)
        -> (GraphQlResult<Response>?, HyperwalletErrorType?) -> Void
        where Response: Decodable {
            return { (result, error) in
                if let error = error {
                    completionHandler(nil, error)
                }
                if let result = result {
                    if let graphQlErrors = result.errors, !graphQlErrors.isEmpty {
                        _ = ErrorTypeHelper.graphQlErrors(errors: graphQlErrors)
                    }
                    completionHandler(result.data, nil)
                }
            }
    }

    /// Handles the callback has been performed by HTTPClient
    static func requestHandler<Response>( _ completionHandler: @escaping (_ response: Response?,
                                                                          _ error: HyperwalletErrorType?) -> Void)
        -> HTTPClientProtocol.ResultHandler where Response: Decodable {
            return { (data, response, error) in
                // Check the transport error has occurred;
                guard error == nil, let httpResponse = response as? HTTPURLResponse else {
                    completionHandler(nil, ErrorTypeHelper.connectionError(for: error))
                    return
                }
                // HTTP 204 - No Content
                if httpResponse.statusCode == 204 {
                    completionHandler(nil, nil)
                    return
                }
                // Check the data
                guard let data = data,
                    let mimeType = httpResponse.mimeType else {
                        completionHandler(nil, ErrorTypeHelper.unexpectedError())
                        return
                }
                // Check the MIME type is an expected value
                if mimeType.range(of: contentType) == nil {
                    completionHandler(nil, ErrorTypeHelper.unexpectedError(message:
                        "Invalid Content-Type specified in Response Header"))
                    return
                }

                parseResponse(httpResponse.statusCode, data, completionHandler)
            }
    }
    /// Parse the response HTTP Code 2xx to `Response.self` object or `HyperwalletErrors.self`.
    static func parseResponse<Response>(_ statusCode: Int,
                                        _ data: Data,
                                        _ completionHandler: @escaping (_ response: Response?,
                                                                        _ error: HyperwalletErrorType?) -> Void)
        where Response: Decodable {
            do {
                if (200 ..< 300).contains(statusCode) {
                    var responseObject: Response
                    responseObject = try JSONDecoder().decode(Response.self, from: data)
                    completionHandler(responseObject, nil)
                } else { // Handle error response
                    let hyperwalletErrors = try JSONDecoder().decode(HyperwalletErrors.self, from: data)
                    completionHandler(nil, HyperwalletErrorType.http(hyperwalletErrors, statusCode))
                }
            } catch {
                 completionHandler(nil, ErrorTypeHelper.parseError())
            }
    }

    func authenticationTokenHandler<Request, Response>(_ transaction: TransactionType,
                                                       _ method: HTTPMethod,
                                                       _ urlPath: String,
                                                       _ urlQuery: [String: String]? = nil,
                                                       _ payload: Request?,
                                                       _ completionHandler: @escaping ((_ response: Response?,
                                                                                _ error: HyperwalletErrorType?) -> Void)
        ) -> HyperwalletAuthenticationTokenProvider.CompletionHandler where Request: Encodable, Response: Decodable {
        return { [weak self] (authenticationToken, error) in
            guard let strongSelf = self else {
                completionHandler(nil, ErrorTypeHelper.transactionAborted())
                return
            }

            guard error == nil else {
                completionHandler(nil, ErrorTypeHelper.authenticationError(
                    message: "Error occured while retrieving authentication token",
                    for: error!)
                )
                return
            }

            do {
                strongSelf.configuration = try AuthenticationTokenDecoder.decode(from: authenticationToken)
                if let configuration = strongSelf.configuration, !configuration.isTokenExpired() {
                    strongSelf.performRequest(transaction, method, urlPath, urlQuery, payload, completionHandler)
                } else {
                    completionHandler(nil, ErrorTypeHelper.notInitialized())
                }
            } catch let error as HyperwalletErrorType {
                completionHandler(nil, error)
            } catch {
                completionHandler(nil, ErrorTypeHelper.unexpectedError(for: error))
            }
        }
    }

    /// Returns the `User-Agent` header.
    /// Returns the Hyperwallet SDK `User-Agent` header.
    ///
    /// Example: HyperwalletSDK/iOS/1.0.1; App: HyperwalletApp ; iOS: 11.3
    private static var userAgent: String = {
        guard let info = Bundle(for: Hyperwallet.self).infoDictionary
            else { return "Hyperwallet/iOS/UnknownVersion" }

        let version = ProcessInfo.processInfo.operatingSystemVersion
        let osVersion = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
        let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
        let sdkVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
        let sdkBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
        let sdkBuildVersion = "\(sdkVersion).\(sdkBuild)"
        return "HyperwalletSDK/iOS/\(sdkBuildVersion); App: \(executable); iOS: \(osVersion)"
    }()

    /// Returns the accept content type.
    private static let contentType: String = {
        "application/json"
    }()

    /// Returns the default timeout - 5 seconds
    private static let defaultTimeout: Double = {
        10.0
    }()

    /// Returns `Accept-Language` header, generated by querying `Locale` for the user's `preferredLanguages`.
    private static let acceptLanguage: String = {
        Locale.preferredLanguages.prefix(6).first ?? "en-US"
    }()

    /// Builds the HTTP header configuration
    static let urlSessionConfiguration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForResource = HTTPTransaction.defaultTimeout
        configuration.timeoutIntervalForRequest = HTTPTransaction.defaultTimeout
        configuration.httpAdditionalHeaders = [
            "User-Agent": userAgent,
            "Accept-Language": acceptLanguage,
            "Accept": contentType,
            "Content-Type": contentType
        ]
        return configuration
    }()
}
