@testable import HyperwalletSDK
import XCTest

class HyperwalletErrorTests: XCTestCase {
    func testHyperwalletErrors_initializeHyperwalletErrors() {
        // Given
        let testHyperwalletError = HyperwalletError(message: "Error message", code: "500")
        let testError = NSError(domain: "test_domain", code: 500, userInfo: ["test_message": "Error message"])

        // When
        let testHyperWalletErrors = HyperwalletErrors(errorList: [testHyperwalletError], originalError: testError)

        // Then
        XCTAssertNotNil(testHyperWalletErrors)
        let testHyperWalletErrorsList = testHyperWalletErrors.errorList
        XCTAssertNotNil(testHyperWalletErrorsList)
        XCTAssertEqual(testHyperWalletErrorsList?.count, 1, "Count should be 1")
        XCTAssertEqual(testHyperWalletErrorsList?.first?.code, "500", "Error code should be 500")
        XCTAssertEqual(testHyperWalletErrorsList?.first?.message,
                       "Error message",
                       "Error message should be 'Error message'")
    }

    func testHyperwalletError_initializeHyperwalletError() {
        // When
        let testHyperwalletError = HyperwalletError(message: "Error message", code: "500")

        // Then
        XCTAssertNotNil(testHyperwalletError)
        XCTAssertEqual(testHyperwalletError.code, "500", "Error code should be 500")
        XCTAssertEqual(testHyperwalletError.message, "Error message", "Error message should be 'Error message'")
    }

    func testHyperwalletError_initializeHyperwalletParseError() {
        // Given
        let testErrorTypeParseError = ErrorTypeHelper.parseError(message: "Error message", fieldName: "Field name")

        // Then
        let testErrorTypeParseErrorList = testErrorTypeParseError.getHyperwalletErrors()

        // Then
        XCTAssertNotNil(testErrorTypeParseError)
        XCTAssertNotNil(testErrorTypeParseErrorList)
        XCTAssertEqual(testErrorTypeParseError.group, HyperwalletErrorGroup.unexpected)
        XCTAssertEqual(testErrorTypeParseErrorList?.errorList?.count, 1, "Count should be 1")
        XCTAssertEqual(testErrorTypeParseErrorList?.errorList?.first?.fieldName,
                       "Field name",
                       "Should be 'Field name'")
        XCTAssertEqual(testErrorTypeParseErrorList?.errorList?.first?.message,
                       "Error message",
                       "Error message should be 'Error message'")
    }

    func testHyperwalletError_businessError() {
        // Given
        let fieldNameError = HyperwalletError(message: "Error message A",
                                              code: "INVALID_FIELD",
                                              fieldName: "Field name")
        let fieldNameBError = HyperwalletError(message: "Error message B",
                                               code: "INVALID_FIELD",
                                               fieldName: "Field name B")

        let testHyperWalletErrors = HyperwalletErrors(errorList: [fieldNameError, fieldNameBError])
        let testErrorTypeHttp = HyperwalletErrorType.http(testHyperWalletErrors, 400)

        // When
        let testErrorTypeHttpList = testErrorTypeHttp.getHyperwalletErrors()

        // Then
        XCTAssertNotNil(testErrorTypeHttp)
        XCTAssertEqual(testErrorTypeHttp.group, HyperwalletErrorGroup.business)
        XCTAssertEqual(testErrorTypeHttpList?.errorList?.count, 2, "Count should be 2")
        XCTAssertEqual(testErrorTypeHttpList?.errorList?.first?.fieldName,
                       "Field name",
                       "Should be 'Field name'")
        XCTAssertEqual(testErrorTypeHttpList?.errorList?.first?.message,
                       "Error message A",
                       "Error message should be 'Error message'")
    }

    func testHyperwalletError_generalHttpError() {
        let hyperwalletError = HyperwalletError(message: "Please check your login credentials and try again",
                                                code: "INCORRECT_LOGIN_CREDENTIALS")
        let testErrorTypeHttp = HyperwalletErrorType.http(HyperwalletErrors(errorList: [hyperwalletError]), 401)

        XCTAssertNotNil(testErrorTypeHttp)
        XCTAssertEqual(testErrorTypeHttp.group, HyperwalletErrorGroup.unexpected)
     }

    func testHyperwalletError_initializeHyperwalletNotInitializedError() {
        // Given
        let testErrorTypeNotInitialized = ErrorTypeHelper.notInitialized()

        // When
        let testErrorTypeNotInitializedList = testErrorTypeNotInitialized.getHyperwalletErrors()

        // Then
        XCTAssertNotNil(testErrorTypeNotInitialized)
        XCTAssertNotNil(testErrorTypeNotInitializedList)
        XCTAssertEqual(testErrorTypeNotInitializedList?.errorList?.count, 1, "Count should be 1")
        XCTAssertEqual(testErrorTypeNotInitializedList?.errorList?.first?.code,
                       "NOT_INITIALIZED",
                       "Error code should be 'NOT_INITIALIZED'")
        XCTAssertEqual(testErrorTypeNotInitializedList?.errorList?.first?.message,
                       "Cannot be initialized",
                       "Error message should be 'Cannot be initialized'")
    }

    func testHyperwalletError_initializeHyperwalletInvalidUrlError() {
        // Given
        let testErrorTypeInvalidUrl = ErrorTypeHelper.invalidUrl()

        // When
        let testErrorTypeInvalidUrlList = testErrorTypeInvalidUrl.getHyperwalletErrors()

        // Then
        XCTAssertNotNil(testErrorTypeInvalidUrl)
        XCTAssertNotNil(testErrorTypeInvalidUrlList)
        XCTAssertEqual(testErrorTypeInvalidUrlList?.errorList?.count, 1, "Count should be 1")
        XCTAssertEqual(testErrorTypeInvalidUrlList?.errorList?.first?.code,
                       "INVALID_URL",
                       "Error code should be 'INVALID_URL'")
        XCTAssertEqual(testErrorTypeInvalidUrlList?.errorList?.first?.message,
                       "Invalid Url",
                       "Error message should be 'Invalid Url'")
        XCTAssertNil(testErrorTypeInvalidUrl.getAuthenticationError())
    }

    func testHyperwalletError_initializeHyperwalletTransactionAbortedError() {
        // Given
        let testErrorTypeTransactionAborted = ErrorTypeHelper.transactionAborted()

        // When
        let testErrorTypeTransactionAbortedList = testErrorTypeTransactionAborted.getHyperwalletErrors()

        // Then
        XCTAssertNotNil(testErrorTypeTransactionAborted)
        XCTAssertNotNil(testErrorTypeTransactionAbortedList)
        XCTAssertEqual(testErrorTypeTransactionAbortedList?.errorList?.count, 1, "Count should be 1")
        XCTAssertEqual(testErrorTypeTransactionAbortedList?.errorList?.first?.code,
                       "TRANSACTION_ABORTED",
                       "Error code should be 'TRANSACTION_ABORTED'")
        XCTAssertEqual(testErrorTypeTransactionAbortedList?.errorList?.first?.message,
                       "Transaction aborted",
                       "Error message should be 'Transaction aborted'")
    }

    func testHyperwalletError_initializeHyperwalletUnexpectedError() {
        // Given
        let testErrorTypeUnexpectedError = ErrorTypeHelper.unexpectedError()

        // Then
        let testErrorTypeUnexpectedErrorList = testErrorTypeUnexpectedError.getHyperwalletErrors()

        // Then
        XCTAssertNotNil(testErrorTypeUnexpectedError)
        XCTAssertNotNil(testErrorTypeUnexpectedErrorList)
        XCTAssertEqual(testErrorTypeUnexpectedErrorList?.errorList?.count, 1, "Count should be 1")
        XCTAssertEqual(testErrorTypeUnexpectedErrorList?.errorList?.first?.code,
                       "UNEXPECTED_ERROR",
                       "Error code should be 'UNEXPECTED_ERROR'")
        XCTAssertEqual(testErrorTypeUnexpectedErrorList?.errorList?.first?.message,
                       String(describing: "Unexpected Error"),
                       "Error message should be 'Unexpected error'")
    }

    func testHyperwalletError_initializeHyperwalletConnectionError() {
        // Given
        let testErrorTypeConnectionError = ErrorTypeHelper.connectionError()

        // When
        let testErrorTypeConnectionErrorList = testErrorTypeConnectionError.getHyperwalletErrors()

        // Then
        XCTAssertNotNil(testErrorTypeConnectionError)
        XCTAssertEqual(testErrorTypeConnectionError.group, HyperwalletErrorGroup.connection)
        XCTAssertNotNil(testErrorTypeConnectionErrorList)
        XCTAssertEqual(testErrorTypeConnectionErrorList?.errorList?.count, 1, "Count should be 1")
        XCTAssertEqual(testErrorTypeConnectionErrorList?.errorList?.first?.code,
                       "CONNECTION_ERROR",
                       "Error code should be 'CONNECTION_ERROR'")
        XCTAssertEqual(testErrorTypeConnectionErrorList?.errorList?.first?.message,
                       "Please check network connection",
                       "Error message should be 'Please check network connection'")
    }

    func testErrorTypeHelper_GraphQlError() {
        // Given
        let testExtension = Extension(code: "500", timestamp: "2019-03-26 17:52:00.517")
        let testLocation = Location(column: 1, line: 1)
        let testGraphQlError = GraphQlError(extensions: testExtension,
                                            locations: [testLocation],
                                            message: "GraphQl Error",
                                            path: [AnyCodable(value: "Any Value")])
        let testErrorTypeGraphQlErrors = ErrorTypeHelper.graphQlErrors(errors: [testGraphQlError])

        // When
        let testErrorTypeGraphQlErrorsList = testErrorTypeGraphQlErrors.getHyperwalletErrors()

        // Then
        XCTAssertNotNil(testGraphQlError)
        XCTAssertNotNil(testErrorTypeGraphQlErrors)
        XCTAssertNotNil(testErrorTypeGraphQlErrorsList)
        XCTAssertEqual(testErrorTypeGraphQlErrorsList?.errorList?.count, 1, "Count should be 1")
        XCTAssertEqual(testErrorTypeGraphQlErrorsList?.errorList?.first?.code,
                       "500",
                       "Error code should be '500'")
        XCTAssertEqual(testErrorTypeGraphQlErrorsList?.errorList?.first?.message,
                       "GraphQl Error",
                       "Error message should be 'GraphQl Error'")
    }

    func testErrorType_AuthenticationExpiredError() {
        // Given
        let testAuthErrorExpired = HyperwalletErrorType.authenticationError(.expired("Expired"))

        // Then
        let testAuthErrorExpiredMessage = testAuthErrorExpired.getAuthenticationError()?.message()
        let testAuthErrorExpiredGroup = testAuthErrorExpired.group.rawValue

        // When
        XCTAssertNotNil(testAuthErrorExpired)
        XCTAssertEqual("Expired", testAuthErrorExpiredMessage, "Should be 'Expired'")
        XCTAssertEqual("UNEXPECTED_ERROR", testAuthErrorExpiredGroup, "Should be 'UNEXPECTED_ERROR'")
        XCTAssertNil(testAuthErrorExpired.getHttpCode())
    }

    func testErrorType_AuthenticationUnexpectedError() {
        // Given
        let testAuthErrorUnexpected = HyperwalletErrorType.authenticationError(.unexpected("Unexpected"))

        // When
        let testAuthErrorUnexpectedMessage = testAuthErrorUnexpected.getAuthenticationError()?.message()
        let testAuthErrorUnexpectedGroup = testAuthErrorUnexpected.group.rawValue

        // Then
        XCTAssertNotNil(testAuthErrorUnexpected)
        XCTAssertNil(testAuthErrorUnexpected.getHyperwalletErrors())
        XCTAssertEqual("Unexpected", testAuthErrorUnexpectedMessage, "Should be 'Unexpected'")
        XCTAssertEqual("UNEXPECTED_ERROR", testAuthErrorUnexpectedGroup, "Should be 'UNEXPECTED_ERROR'")
    }
}
