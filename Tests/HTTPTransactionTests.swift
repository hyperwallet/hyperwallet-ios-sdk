@testable import HyperwalletSDK
import XCTest

class HTTPTransactionTests: XCTestCase {
    var httpClientMock: HTTPClientMock!
    var providerMock: AuthenticationProviderMock!
    var transaction: HTTPTransaction!

    override func setUp() {
        httpClientMock = HTTPClientMock()
        providerMock = AuthenticationProviderMock(authorizationData: HyperwalletTestHelper.authenticationToken)
        transaction = HTTPTransaction(provider: providerMock, httpClient: httpClientMock)
    }

    func testUrlSessionConfiguration_httpHeader() {
        let configuration = HTTPTransaction.urlSessionConfiguration
        let header = configuration.httpAdditionalHeaders

        XCTAssertEqual(configuration.timeoutIntervalForRequest, 10.0)
        XCTAssertEqual(header?["Content-Type"] as? String, "application/json")
        XCTAssertTrue((header?["Accept-Language"] as? String ?? "").contains("en"))
        let userAgent = header?["User-Agent"] as? String
        XCTAssertTrue(userAgent?.contains("HyperwalletSDK/iOS/") ?? false )
        XCTAssertTrue(userAgent?.contains("App:") ?? false)
        XCTAssertTrue(userAgent?.contains("iOS:") ?? false)
    }

    func testPerformRest_newConfiguration() {
        // Given 
        var hasRequestTransactionPerformed = false
        // When - an API call request is made
        let completionHandler = {(data: [String: String]?, error: HyperwalletErrorType?) -> Void in
            hasRequestTransactionPerformed = true
        }
        transaction.performRest(httpMethod: .get,
                                urlPath: "/users/%@/bank-accounts",
                                payload: "",
                                completionHandler: completionHandler)

        // Then - make sure the SDK will execute client's provider implementation to request a client token
        guard let configuration = transaction.configuration else {
            XCTFail("The HyperwalletConfiguration has not been initialized")
            return
        }

        XCTAssertTrue(httpClientMock.hasPerformed, "The HTTPClient has not been performed")
        XCTAssertTrue(hasRequestTransactionPerformed, "The SDK has not been propagated the result (data or error)")
        XCTAssertTrue(providerMock.hasRequestedClientToken, "The AuthenticationTokenProvider has not been performed")

        XCTAssertNotNil(configuration.clientToken, "The clientToken has not been initialized")
        XCTAssertNotNil(configuration.createOn, "The createOn has not been initialized")
        XCTAssertNotNil(configuration.expiresOn, "The expiresOn has not been initialized")
        XCTAssertNotNil(configuration.graphQlUrl, "The graphQlUrl has not been initialized")
        XCTAssertNotNil(configuration.restUrl, "The restUrl has not been initialized")
        XCTAssertNotNil(configuration.issuer, "The issuer has not been initialized")
        XCTAssertNotNil(configuration.authorization, "The authorization has not been initialized")
        XCTAssertNotNil(configuration.authorization, "The authorization has not been initialized")
    }

    // swiftlint:disable function_body_length
    func testPerformRest_successURLRequest() {
        // Given
        let queryParam = HyperwalletBankAccountQueryParam()
        queryParam.limit = 80
        queryParam.status = .activated
        queryParam.type = .bankAccount
        var queryParamsDictionary: [String: String]?
        var urlValueComponents: URLComponents?
        // When
        let completionHandler = { (data: [String: String]?, error: HyperwalletErrorType?) -> Void in }
        transaction.performRest(httpMethod: .get,
                                urlPath: "users/%@/bank-accounts",
                                payload: "",
                                queryParam: queryParam,
                                completionHandler: completionHandler)
        // Then
        XCTAssertNotNil(httpClientMock.request, "The request should not be nil")
        urlValueComponents = URLComponents(url: httpClientMock.request!.url!, resolvingAgainstBaseURL: false)
        queryParamsDictionary = queryParam.toQuery()

        XCTAssertEqual(urlValueComponents?.scheme, "https")
        XCTAssertEqual(urlValueComponents?.host, "localhost")
        XCTAssertEqual(urlValueComponents?.path, "/rest/v3/users/YourUserToken/bank-accounts")

        let limit = urlValueComponents?.queryItems?.first { $0.name == "limit" }
        XCTAssertNotNil(limit, "The limit should be part of the URL")
        XCTAssertEqual(limit?.value, "80", "The limit should be 80")
        let limitKey = QueryParam.QueryParam.limit.rawValue
        XCTAssertNotNil(queryParamsDictionary?[limitKey], "The limit should be part of the URL")
        XCTAssertEqual(queryParamsDictionary?[limitKey], "80", "The limit should be 80")

        let offset = urlValueComponents?.queryItems?.first { $0.name == "offset" }
        XCTAssertNotNil(offset, "The offset should be part of the URL")
        XCTAssertEqual(offset?.value, "0", "The offset should be 0")
        let offsetKey = QueryParam.QueryParam.offset.rawValue
        XCTAssertNotNil(queryParamsDictionary?[offsetKey], "The offset should be part of the URL")
        XCTAssertEqual(queryParamsDictionary?[offsetKey], "0", "The offset should be 0")

        let status = urlValueComponents?.queryItems?.first { $0.name == "status" }
        XCTAssertNotNil(status, "The status should be part of the URL")
        XCTAssertEqual(status?.value, "ACTIVATED", "The status should be ACTIVATED")
        let statusKey = HyperwalletTransferMethodQueryParam.QueryParam.status.rawValue
        XCTAssertNotNil(queryParamsDictionary?[statusKey], "The status should be part of the URL")
        XCTAssertEqual(queryParamsDictionary?[statusKey], "ACTIVATED", "The status should be ACTIVATED")

        let type = urlValueComponents?.queryItems?.first { $0.name == "type" }
        XCTAssertNotNil(type, "The type should be part of the URL")
        XCTAssertEqual(type?.value, "BANK_ACCOUNT", "The type should be BANK_ACCOUNT")
        let typeKey = HyperwalletBankAccountQueryParam.QueryParam.type.rawValue
        XCTAssertNotNil(queryParamsDictionary?[typeKey], "The type should be part of the URL")
        XCTAssertEqual(queryParamsDictionary?[typeKey], "BANK_ACCOUNT", "The type should be BANK_ACCOUNT")
    }

    func testPerformGraphQl_validToken() {
        // Given - SDK is initialized
        let request = HyperwalletTransferMethodConfigurationFieldQuery(country: "AR",
                                                                       currency: "ARS",
                                                                       transferMethodType: "BANK_ACCOUNT",
                                                                       profile: "INDIVIDUAL")
        // When - an API call request is made
        let completionHandler = { (data: [String: String]?, error: HyperwalletErrorType?) -> Void in }

        transaction.performGraphQl(request, completionHandler: completionHandler)

        // Then
        XCTAssertTrue(providerMock.hasRequestedClientToken, "The AuthenticationTokenProvider has not been performed")

        guard let configuration = transaction.configuration else {
            XCTFail("The HyperwalletConfiguration has not been initialized")
            return
        }
        XCTAssertFalse(configuration.isTokenStale())
        XCTAssertFalse(configuration.isTokenExpired())

        providerMock.reset()
        httpClientMock.reset()

        transaction.performGraphQl(request, completionHandler: completionHandler)

        XCTAssertFalse(providerMock.hasRequestedClientToken, "The AuthenticationTokenProvider has been performed")
        XCTAssertEqual(configuration.authorization, transaction.configuration!.authorization)
    }

    func testPerformGraphQl_responseWithErrorsAndData_returnOnlyData() {
        // Given - SDK is initialized
        var response: Connection<TransferMethodConfiguration>?
        var hyperwalletError: HyperwalletErrorType?

        httpClientMock.data = HyperwalletTestHelper.getDataFromJson("TransferMethodConfigurationGraphQlResponse")
        httpClientMock.urlResponse = HTTPURLResponse(url: URL(string: "http://localhost")!,
                                                     statusCode: 200,
                                                     httpVersion: "post",
                                                     headerFields: ["Content-type": "application/json"])

        let request = HyperwalletTransferMethodConfigurationFieldQuery(country: "AR",
                                                                       currency: "ARS",
                                                                       transferMethodType: "BANK_ACCOUNT",
                                                                       profile: "INDIVIDUAL")
        // When - an API call request is made
        let completionHandler = {
            (data: Connection<TransferMethodConfiguration>?, error: HyperwalletErrorType?) -> Void in
            response = data
            hyperwalletError = error
        }

        transaction.performGraphQl(request, completionHandler: completionHandler)

        // Then
        XCTAssertNotNil(response)
        XCTAssertNil(hyperwalletError)
    }

    func testPerformGraphQl_emptyResponseData_returnNilDataAndGraphQlErrors() {
        // Given - SDK is initialized

        let graphQlResponse = """
            {}
        """.data(using: .utf8)
        var response: Connection<TransferMethodConfiguration>?
        var hyperwalletError: HyperwalletErrorType?

        httpClientMock.data = graphQlResponse
        httpClientMock.urlResponse = HTTPURLResponse(url: URL(string: "http://localhost")!,
                                                     statusCode: 200,
                                                     httpVersion: "post",
                                                     headerFields: ["Content-type": "application/json"])

        let request = HyperwalletTransferMethodConfigurationFieldQuery(country: "AR",
                                                                       currency: "ARS",
                                                                       transferMethodType: "BANK_ACCOUNT",
                                                                       profile: "INDIVIDUAL")
        // When - an API call request is made
        let completionHandler = {
            (data: Connection<TransferMethodConfiguration>?, error: HyperwalletErrorType?) -> Void in
            response = data
            hyperwalletError = error
        }

        transaction.performGraphQl(request, completionHandler: completionHandler)

        // Then

        XCTAssertNil(response)
        XCTAssertNil(hyperwalletError)
    }

    func testPerformRest_HTTP204_returnEmptyResponseAndError() {
        // Given - SDK is initialized

        var response: [String: String]?
        var hyperwalletError: HyperwalletErrorType?

        httpClientMock.data = nil
        httpClientMock.urlResponse = HTTPURLResponse(url: URL(string: "http://localhost")!,
                                                     statusCode: 204,
                                                     httpVersion: "post",
                                                     headerFields: ["": ""])

        // When - an API call request is made
        let completionHandler = { (data: [String: String]?, error: HyperwalletErrorType?) -> Void in
            response = data
            hyperwalletError = error
        }

        transaction.performRest(httpMethod: .post, urlPath: "", payload: "", completionHandler: completionHandler)

        // Then
        XCTAssertNil(response)
        XCTAssertNil(hyperwalletError)
    }

    func testPerformRest_invalidRestUrl_invalidRequest() {
        // Given
        let authorizationTokenMock = AuthenticationTokenGeneratorMock(restUrl: "Invalid url", graphQlUrl: "Invalid url")
        buildInvalidTransaction(authorizationTokenMock.token)
        var response: [String: String]?
        var hyperwalletError: HyperwalletErrorType?
        let expectation = XCTestExpectation(description: "Wait for async operation completion")

        // When
        let completionHandler = {(data: [String: String]?, error: HyperwalletErrorType?) -> Void in
            response = data
            hyperwalletError = error
            expectation.fulfill()
        }

        // Create a new HyperwalletConfiguration
        transaction.performRest(httpMethod: .get,
                                urlPath: "",
                                payload: "",
                                completionHandler: completionHandler)
        // Then
        wait(for: [expectation], timeout: 5.0)

        XCTAssertNotNil(transaction.configuration)
        guard let configuration = transaction.configuration else {
            XCTFail("configuration should be initialized")
            return
        }

        XCTAssertEqual(configuration.graphQlUrl, "Invalid url")
        XCTAssertNil(response)
        XCTAssertNotNil(hyperwalletError)
        XCTAssertNotNil(hyperwalletError?.getHyperwalletErrors())
        XCTAssertEqual(hyperwalletError?.getHyperwalletErrors()?.errorList?.first?.code, "INVALID_REQUEST")
        XCTAssertEqual(hyperwalletError?.getHyperwalletErrors()?.errorList?.first?.message, "invalid request")
    }

    func testPerformRest_authenticationFailed_authenticationError() {
        // Given
        let expectedErrorMessage = "runtime error"
        buildInvalidTransaction(nil, error: HyperwalletAuthenticationErrorType.unexpected(expectedErrorMessage))
        var response: [String: String]?
        var errorType: HyperwalletErrorType?

        // When
        let completionHandler = {(data: [String: String]?, error: HyperwalletErrorType?) -> Void in
            response = data
            errorType = error
        }

        transaction.performRest(httpMethod: .get,
                                urlPath: "/users/%@/bank-accounts",
                                payload: "",
                                completionHandler: completionHandler)

        // Then
        XCTAssertNil(response)
        XCTAssertNotNil(errorType)
        XCTAssertNotNil(errorType?.getAuthenticationError())
        XCTAssertEqual(errorType?.getAuthenticationError()?.message(), expectedErrorMessage)
    }

    func testPerformGraphQl_tokenStale_notInitializedError() {
        // Given
        buildInvalidTransaction(AuthenticationTokenGeneratorMock(minuteExpireIn: -1).token)
        var response: [String: String]?
        var hyperwalletError: HyperwalletErrorType?

        // When
        let completionHandler = {(data: [String: String]?, error: HyperwalletErrorType?) -> Void in
            response = data
            hyperwalletError = error
        }

        let request = HyperwalletTransferMethodConfigurationFieldQuery(country: "AR",
                                                                       currency: "ARS",
                                                                       transferMethodType: "BANK_ACCOUNT",
                                                                       profile: "INDIVIDUAL")

        // Create a new HyperwalletConfiguration with expired jwt token
        transaction.performGraphQl(request, completionHandler: completionHandler)

        XCTAssertNotNil(transaction.configuration)
        guard let configuration = transaction.configuration else {
            XCTFail("configuration should be initialized")
            return
        }

        XCTAssertTrue(configuration.isTokenStale())
        providerMock.reset()

        // HyperwalletConfiguration is expired
        transaction.performGraphQl(request, completionHandler: completionHandler)

        // Then
        XCTAssertNil(response)
        XCTAssertNotNil(hyperwalletError)
        XCTAssertNotNil(hyperwalletError?.getHyperwalletErrors())
        XCTAssertEqual(hyperwalletError?.getHyperwalletErrors()?.errorList?.first?.message, "Cannot be initialized")
    }

    func testRequestHandler_unexpectedError() {
        // Given
        var response: [String: String]?
        var errorType: HyperwalletErrorType?

        // When
        let completionHandler = {(data: [String: String]?, error: HyperwalletErrorType?) -> Void in
            response = data
            errorType = error
        }

        let requestHandler = HTTPTransaction.requestHandler(completionHandler)

        requestHandler(nil, nil, NSError(domain: "Network fail", code: -1000))

        // Then
        XCTAssertNil(response)
        XCTAssertNotNil(errorType)
        XCTAssertNotNil(errorType?.getHyperwalletErrors())
        XCTAssertEqual(errorType?.getHyperwalletErrors()?.errorList?.first?.message,
                       "Please check network connection")
    }

    func testRequestHandler_invalidContentType_unexpectedError() {
        // Given
        let expectedMessage = "Invalid Content-Type specified in Response Header"
        var response: [String: String]?
        var errorType: HyperwalletErrorType?
        let urlResponse = HTTPURLResponse(url: URL(string: "http://localhost")!,
                                          mimeType: "text/html",
                                          expectedContentLength: 10,
                                          textEncodingName: "")

        // When
        let completionHandler = {(data: [String: String]?, error: HyperwalletErrorType?) -> Void in
            response = data
            errorType = error
        }

        let requestHandler = HTTPTransaction.requestHandler(completionHandler)

        requestHandler(Data(), urlResponse, nil)

        // Then
        XCTAssertNil(response)
        XCTAssertNotNil(errorType)
        XCTAssertEqual(errorType?.getHyperwalletErrors()?.errorList?.first?.code, "UNEXPECTED_ERROR")
        XCTAssertEqual(errorType?.getHyperwalletErrors()?.errorList?.first?.message, expectedMessage)
    }

    func testRequestHandler_httpCodeSuccessWithInvalidPayload_parseError() {
        // Given
        var response: [String: String]?
        var errorType: HyperwalletErrorType?
        let invalidPayload = "\"key\": \"value\"}"
        let data = invalidPayload.data(using: .utf8)
        let urlResponse = HTTPURLResponse(url: URL(string: "http://localhost")!,
                                          statusCode: 200,
                                          httpVersion: "post",
                                          headerFields: ["Content-type": "application/json"])

        // When
        let completionHandler = {(data: [String: String]?, error: HyperwalletErrorType?) -> Void in
            response = data
            errorType = error
        }

        let requestHandler = HTTPTransaction.requestHandler(completionHandler)

        requestHandler(data, urlResponse, nil)

        // Then
        XCTAssertNil(response, "The response should be null")
        XCTAssertNotNil(errorType, "The hyperwalletError should be null")
        XCTAssertEqual(errorType?.getHyperwalletErrors()?.errorList?.first?.code, "PARSE_ERROR")
    }

    func testRequestHandler_dataAndErrorAreNil_unexpectedError() {
        // Given
        var response: [String: String]?
        var errorType: HyperwalletErrorType?
        let urlResponse = HTTPURLResponse(url: URL(string: "http://localhost")!,
                                          statusCode: 200,
                                          httpVersion: "post",
                                          headerFields: ["Content-type": "text/html"])

        // When
        let completionHandler = {(data: [String: String]?, error: HyperwalletErrorType?) -> Void in
            response = data
            errorType = error
        }

        let requestHandler = HTTPTransaction.requestHandler(completionHandler)

        requestHandler(nil, urlResponse, nil)

        // Then
        XCTAssertNil(response, "The response should be null")
        XCTAssertNotNil(errorType, "The hyperwalletError should be null")
        XCTAssertEqual(errorType?.getHyperwalletErrors()?.errorList?.first?.code, "UNEXPECTED_ERROR")
    }

    func testRequestHandler_httpCodeBadRequest_hyperwalletError() {
        // Given
        var response: [String: String]?
        var errorType: HyperwalletErrorType?
        let urlResponse = HTTPURLResponse(url: URL(string: "http://localhost")!,
                                          statusCode: 400,
                                          httpVersion: "post",
                                          headerFields: ["Content-type": "application/json"])

        let data = HyperwalletTestHelper.getDataFromJson("BankCardErrorResponseWithInvalidCardNumber")

        // When
        let completionHandler = {(data: [String: String]?, error: HyperwalletErrorType?) -> Void in
            response = data
            errorType = error
        }

        let requestHandler = HTTPTransaction.requestHandler(completionHandler)

        requestHandler(data, urlResponse, nil)

        // Then
        XCTAssertNil(response, "The response should be null")
        XCTAssertNotNil(errorType, "The hyperwalletError should not be null")
        XCTAssertEqual(errorType?.getHttpCode(), 400)
        XCTAssertEqual(errorType?.getHyperwalletErrors()?.errorList?.first?.code, "INVALID_FIELD_LENGTH")
        XCTAssertEqual(errorType?.getHyperwalletErrors()?.errorList?.first?.message,
                       "Invalid field length for cardNumber")
    }

    func testRequestHandler_httpCodeSuccessWithJSONFormatPayload_parseData() {
        var response: [String: String]?
        var errorType: HyperwalletErrorType?
        let completionHandler = {(data: [String: String]?, error: HyperwalletErrorType?) -> Void in
            response = data
            errorType = error
        }

        performRequestSucceeded(payload: "{\"key\": \"value\"}",
                                completionHandler)

        // Then
        XCTAssertNotNil(response, "The response should not be null")
        XCTAssertNil(errorType, "The hyperwalletError should be null")
    }

    func testRequestHandler_httpCodeSuccessWithArrayPayload_parseData() {
        var response: [String]?
        var errorType: HyperwalletErrorType?

        let completionHandler = {(data: [String]?, error: HyperwalletErrorType?) -> Void in
            response = data
            errorType = error
        }

        performRequestSucceeded(payload: "[\"value\"]", completionHandler)

        // Then
        XCTAssertNotNil(response, "The response should not be null")
        XCTAssertNil(errorType, "The hyperwalletError should be null")
    }

    func testAuthenticationTokenHandler_emptyResponseData_parseError() {
        // Given
        var response: [String: String]?
        var errorType: HyperwalletErrorType?

        // When
        let completionHandler = {(data: [String: String]?, error: HyperwalletErrorType?) -> Void in
            response = data
            errorType = error
        }

        let transaction = HTTPTransaction(provider: providerMock, httpClient: httpClientMock)

        let authenticationTokenHandler = transaction.authenticationTokenHandler(.rest,
                                                                                .get,
                                                                                "users/%@/bank-account",
                                                                                nil,
                                                                                "",
                                                                                completionHandler)

        authenticationTokenHandler("", nil)

        // Then
        XCTAssertNil(response, "The response should be null")
        XCTAssertNotNil(errorType, "The hyperwalletError should be null")
        XCTAssertEqual(errorType?.getHyperwalletErrors()?.errorList?.first?.code, "PARSE_ERROR")
    }

    private func buildInvalidTransaction(_ invalidAuthenticationToken: String?,
                                         error: HyperwalletAuthenticationErrorType? = nil) {
        let provider = AuthenticationProviderMock(authorizationData: invalidAuthenticationToken, error: error)
        transaction = HTTPTransaction(provider: provider)
    }

    private func performRequestSucceeded<T: Codable>(payload: String,
                                                     _ completionHandler: @escaping (T?,
                                                                                     HyperwalletErrorType?) -> Void) {
        // Given

        let urlResponse = HTTPURLResponse(url: URL(string: "http://localhost")!,
                                          statusCode: 200,
                                          httpVersion: "post",
                                          headerFields: ["Content-type": "application/json"])
        let data = payload.data(using: .utf8)

        // When

        let requestHandler = HTTPTransaction.requestHandler(completionHandler)

        requestHandler(data, urlResponse, nil)
    }
}
