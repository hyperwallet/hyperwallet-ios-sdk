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

/// Representation of the Hyperwallet error list
public struct HyperwalletErrors: Decodable {
    /// The error list
    public private(set) var errorList: [HyperwalletError]?

    /// The original error
    public private(set) var originalError: Error?
    /// The CodingKeys for Hyperwallet errors
    public enum CodingKeys: String, CodingKey {
        /// - errorList: The list of errors
        case errorList = "errors"
    }

    /// Creates an instance of HyperwalletErrors
    ///
    /// - Parameter errorList: The `HyperwalletError` list.
    public init(errorList: [HyperwalletError]) {
        self.errorList = errorList
    }

    /// Creates an instance of HyperwalletErrors
    ///
    /// - Parameters:
    ///   - errorList: The `HyperwalletError` list.
    ///   - originalError: The original error.
    public init(errorList: [HyperwalletError], originalError: Error?) {
        self.errorList = errorList
        self.originalError = originalError
    }
}

/// Representation of the Hyperwallet error entity.
public struct HyperwalletError: Decodable {
    /// The error message
    public private(set) var message: String

    /// The error code
    public private(set) var code: String

    /// The field name
    public private(set) var fieldName: String?

    /// The list of related resources
    public private(set) var relatedResources: [String]?

    /// Creates an instance of HyperwalletError
    ///
    /// - Parameters:
    ///   - message: The error message
    ///   - code: The error code
    ///   - fieldName: The field name. By the default is nil
    ///   - relatedResources: The list of related resources. By the default is nil
    public init(message: String, code: String, fieldName: String? = nil, relatedResources: [String]? = nil) {
        self.message = message
        self.code = code
        self.fieldName = fieldName
        self.relatedResources = relatedResources
    }
}

/// The `HyperwalletErrorType` is the error type returned By Hyperwallet SDK.
public enum HyperwalletErrorType: Error, LocalizedError {
    /// - http: Returned when an HTTP code is not in the range 2xx.
    case http(_ hyperwalletErrors: HyperwalletErrors, _ httpCode: Int)
    /// - parseError:  Returned when a response parser process throws error.
    case parseError(_ hyperwalletErrors: HyperwalletErrors)
    /// - notInitialized: Returned when the SDK was not initialized properly.
    case notInitialized(_ hyperwalletErrors: HyperwalletErrors)
    /// - invalidUrl: Returned when a provided URL is not valid
    case invalidUrl(_ hyperwalletErrors: HyperwalletErrors)
    /// - transactionAborted: Returned when a transaction is explicitly aborted.
    case transactionAborted(_ hyperwalletErrors: HyperwalletErrors)
    /// - authenticationError:  Returned on authentication failure
    case authenticationError(_ authenticationError: HyperwalletAuthenticationErrorType)
    /// - unexpected: Returned when an unexpected behavior happened.
    case unexpected(_ hyperwalletErrors: HyperwalletErrors)
    /// - graphQlErrors: Returned when a GraphQL parser process throws error.
    case graphQlErrors(_ hyperwalletErrors: HyperwalletErrors)
    /// - invalidRequest: Returned when some step-in builds  the request throws error.
    case invalidRequest(_ hyperwalletErrors: HyperwalletErrors)
    /// - connectionError:  Returned when during the connection process throws error.
    case connectionError(_ hyperwalletErrors: HyperwalletErrors)

    /// The error type group
    public var group: HyperwalletErrorGroup {
        switch self {
        case .http(_, let httpCode):
            return httpCode == 400
                ? HyperwalletErrorGroup.business
                : HyperwalletErrorGroup.unexpected
        case .authenticationError,
             .parseError,
             .notInitialized,
             .invalidUrl,
             .transactionAborted,
             .unexpected,
             .graphQlErrors,
             .invalidRequest:
            return HyperwalletErrorGroup.unexpected

        case .connectionError:
            return HyperwalletErrorGroup.connection
        }
    }

    /// Gets the `HyperwalletErrors` based on the ErrorType
    ///
    /// - Returns: An instance of HyperwalletErrors or nil
    public func getHyperwalletErrors() -> HyperwalletErrors? {
        switch self {
        case .http(let hyperwalletErrors, _),
             .parseError(let hyperwalletErrors),
             .notInitialized(let hyperwalletErrors),
             .invalidUrl(let hyperwalletErrors),
             .transactionAborted(let hyperwalletErrors),
             .unexpected(let hyperwalletErrors),
             .graphQlErrors(let hyperwalletErrors),
             .invalidRequest(let hyperwalletErrors),
             .connectionError(let hyperwalletErrors):
            return hyperwalletErrors

        case .authenticationError:
            return nil
        }
    }

    /// Gets the `AuthenticationErrorType` on the ErrorType
    ///
    /// - Returns: An instance of AuthenticationErrorType or nil
    public func getAuthenticationError() -> HyperwalletAuthenticationErrorType? {
        switch self {
        case .authenticationError(let authenticationError):
            return authenticationError

        default:
            return nil
        }
    }

    /// Gets the HTTP Code based on the ErrorType.http
    ///
    /// - Returns: The HTTP Code or return nil
    public func getHttpCode() -> Int? {
        switch self {
        case .http(_, let httpCode):
            return httpCode

        default:
            return nil
        }
    }
}

/// The `HyperwalletAuthenticationErrorType` is the authentication error type returned By Hyperwallet SDK.
public enum HyperwalletAuthenticationErrorType: LocalizedError {
    /// - expired: Returned when the authenticated session is expired
    case expired(_ message: String)
    /// - unexpected: Returned when an unexpected behavior happened.
    case unexpected(_ message: String)

    /// Gets the AuthenticationErrorType error message
    ///
    /// - Returns: An error message detail
    public func message() -> String {
        switch self {
        case .expired(let message):
            return message

        case .unexpected(let message):
            return message
        }
    }
}

/// Representation of the error type group
public enum HyperwalletErrorGroup: String {
    /// - business:   Returned when a business error is thrown
    case business = "BUSINESS_ERROR"
    /// - unexpected: Returned when an unexpected error is thrown
    case unexpected = "UNEXPECTED_ERROR"
    /// - connection: Returned when a connection error is thrown
    case connection = "CONNECTION_ERROR"
}

internal struct ErrorTypeHelper {
    private static func buildHyperwalletErrors(code: String,
                                               message: String,
                                               fieldName: String? = nil,
                                               error: Error? = nil) -> HyperwalletErrors {
        let hyperwalletError = HyperwalletError(message: message, code: code, fieldName: fieldName)
        let hyperwalletErrors = [hyperwalletError]
        return HyperwalletErrors(errorList: hyperwalletErrors, originalError: error)
    }

    static func parseError(message: String = "Cannot be parsed", fieldName: String? = nil) -> HyperwalletErrorType {
        os_log("Error occured while parsing the data", log: OSLog.data, type: .error)
        return HyperwalletErrorType.parseError(buildHyperwalletErrors(code: "PARSE_ERROR",
                                                                      message: message,
                                                                      fieldName: fieldName))
    }

    static func notInitialized(message: String = "Cannot be initialized") -> HyperwalletErrorType {
        os_log("%s%s%s",
               log: OSLog.initialization,
               type: .error,
               "Hyperwallet SDK is not initialized. ",
               "Call Hyperwallet.setup(provider: HyperwalletAuthenticationTokenProvider) ",
               "before accessing Hyperwallet.sharedInstance")
        return HyperwalletErrorType.notInitialized(buildHyperwalletErrors(code: "NOT_INITIALIZED", message: message))
    }

    static func invalidUrl(message: String = "Invalid Url") -> HyperwalletErrorType {
        os_log("Url is not valid", log: OSLog.httpRequest, type: .error)
        return HyperwalletErrorType.invalidUrl(buildHyperwalletErrors(code: "INVALID_URL", message: message))
    }

    static func transactionAborted(message: String = "Transaction aborted") -> HyperwalletErrorType {
        os_log("Transaction aborted while making Http Request", log: OSLog.httpRequest, type: .error)
        return HyperwalletErrorType.transactionAborted(buildHyperwalletErrors(code: "TRANSACTION_ABORTED",
                                                                              message: message))
    }

    static func unexpectedError(message: String = "Unexpected Error",
                                for error: Error? = nil) -> HyperwalletErrorType {
        os_log("Unexpected error: %s", log: OSLog.default, type: .error, message)
        return HyperwalletErrorType.unexpected(buildHyperwalletErrors(code: "UNEXPECTED_ERROR",
                                                                      message: message,
                                                                      error: error))
    }

    static func connectionError(message: String = "Please check network connection",
                                for error: Error? = nil) -> HyperwalletErrorType {
        return HyperwalletErrorType.connectionError(buildHyperwalletErrors(code: "CONNECTION_ERROR",
                                                                           message: message,
                                                                           error: error))
    }

    static func graphQlErrors(errors: [GraphQlError]) -> HyperwalletErrorType {
        var hyperwalletErrors = [HyperwalletError]()
        for graphQlError in errors {
            let hyperwalletError = HyperwalletError(message: graphQlError.message ?? "Unexpected Error",
                                                    code: graphQlError.extensions?.code ?? "UNEXPECTED_ERROR",
                                                    fieldName: nil,
                                                    relatedResources: nil)
            hyperwalletErrors.append(hyperwalletError)
            os_log("GraphQl response contains error: %s",
                   log: OSLog.graphQl,
                   type: .info,
                   graphQlError.message ?? "Unexpected Error")
        }
        return HyperwalletErrorType.graphQlErrors(HyperwalletErrors(errorList: hyperwalletErrors))
    }

    static func invalidRequest(message: String = "invalid request", for error: Error? = nil) -> HyperwalletErrorType {
        os_log("Http request is invalid", log: OSLog.httpRequest, type: .error)
        return HyperwalletErrorType.invalidRequest(buildHyperwalletErrors(code: "INVALID_REQUEST",
                                                                          message: message,
                                                                          error: error))
    }

    static func authenticationError(message: String = "Authentication Error",
                                    for error: HyperwalletAuthenticationErrorType) -> HyperwalletErrorType {
        os_log("Error occured while retrieving authentication token: %s",
               log: OSLog.authentication,
               type: .error,
               error.localizedDescription)
        return HyperwalletErrorType.authenticationError(error)
    }
}
