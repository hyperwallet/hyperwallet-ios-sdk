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

/// Transaction type definitions.
///
/// - rest: Represents a REST transaction.
/// - graphQl: Represents a GraphQL transaction.
internal enum TransactionType {
    case rest
    case graphQl

    /// Creates URLRequest depending on transaction type
    ///
    /// - Parameters:
    ///   - configuration: Configuration
    ///   - method: HTTPMethod
    ///   - path: urlPath
    ///   - query: urlQuery
    ///   - httpBody: <Body>
    /// - Returns: URLRequest
    func createRequest<Body>(_ configuration: Configuration,
                             method: HTTPMethod,
                             urlPath path: String,
                             urlQuery query: [String: String]? = nil,
                             httpBody: Body?) throws -> URLRequest where Body: Encodable {
        switch self {
        case .graphQl:
            return try createGraphQlRequest(configuration,
                                            method: method,
                                            urlPath: path,
                                            httpBody: httpBody)

        case .rest:
            return try createRestRequest(configuration,
                                         method: method,
                                         urlPath: path,
                                         urlQuery: query,
                                         httpBody: httpBody)
        }
    }

    private func createRestRequest<Body>(_ configuration: Configuration,
                                         method: HTTPMethod,
                                         urlPath path: String,
                                         urlQuery query: [String: String]? = nil,
                                         httpBody: Body?) throws -> URLRequest where Body: Encodable {
        let formattedPath = String(format: path, configuration.userToken)
        let baseURL = URL(string: configuration.restUrl + formattedPath)
        //let baseURL = url(configuration, path)
        guard let url = addQueryIfRequired(baseURL, query) else {
            throw ErrorTypeHelper.invalidUrl()
        }
        var request = URLRequest(url: url)
        request.addValue("Bearer " + configuration.authorization, forHTTPHeaderField: "Authorization")
        request.httpMethod = method.rawValue
        if httpBody != nil, (method == .post || method == .put) {
            let encoder = JSONEncoder()
            let data = try? encoder.encode(httpBody)
            request.httpBody = data
        }
        return request
    }

    private func createGraphQlRequest<Body>(_ configuration: Configuration,
                                            method: HTTPMethod,
                                            urlPath path: String,
                                            httpBody: Body?) throws -> URLRequest where Body: Encodable {
        guard let baseURL = URL(string: configuration.graphQlUrl) else {
            throw ErrorTypeHelper.invalidUrl()
        }
        var request = URLRequest(url: baseURL)
        request.addValue("Bearer " + configuration.authorization, forHTTPHeaderField: "Authorization")
        request.httpMethod = method.rawValue
        if let httpBody = httpBody, let graphQl = httpBody as? GraphQlQuery {
            let graphQlQuery = graphQl.toGraphQl(userToken: configuration.userToken)
            request.httpBody = graphQlQuery.data(using: .utf8)
        }

        return request
    }

    private func addQueryIfRequired(_ baseUrl: URL?, _ query: [String: String]?) -> URL? {
        guard let baseUrl = baseUrl else {
            return nil
        }

        if let urlQuery = query {
            var urlComponent = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)
            urlComponent?.queryItems = urlQuery.map { URLQueryItem(name: $0, value: $1) }
            return urlComponent?.url
        }
        return baseUrl
    }
}
