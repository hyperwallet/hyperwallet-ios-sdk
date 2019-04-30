import Hippolyte
@testable import HyperwalletSDK
import XCTest

// swiftlint:disable force_cast
class HyperwalletPaypalAccountTests: XCTestCase {
    override func setUp() {
        Hyperwallet.setup(HyperwalletTestHelper.authenticationProvider)
    }

    override func tearDown() {
        if Hippolyte.shared.isStarted {
            Hippolyte.shared.stop()
        }
    }

    func testCreatePaypalAccount_success() {
        // Given
        let expectation = self.expectation(description: "Create paypal account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "PaypalAccountResponse")
        let url = String(format: "%@/paypal-accounts", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostResquest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var paypalAccountResponse: HyperwalletPaypalAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let paypalAccount = HyperwalletPaypalAccount
            .Builder(transferMethodCountry: "US", transferMethodCurrency: "USD")
            .email("test@paypal.com")
            .build()

        Hyperwallet.shared.createPaypalAccount(account: paypalAccount, completion: { (result, error) in
            paypalAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(paypalAccount)
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(paypalAccountResponse?.getFields())
        XCTAssertEqual(paypalAccountResponse?.getField(fieldName: .email) as! String, "test@paypal.com")
    }

    func testCreatePaypalAccount_missingMandatoryField_returnBadRequest() {
        // Given
        let expectation = self.expectation(description: "Create paypal account failed")
        let response = HyperwalletTestHelper.badRequestHTTPResponse(for: "PaypalAccountResponseWithMissingEmail")
        let url = String(format: "%@/paypal-accounts", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostResquest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var paypalAccountResponse: HyperwalletPaypalAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let paypalAccount = HyperwalletPaypalAccount.Builder(transferMethodCountry: "US",
                                                             transferMethodCurrency: "USD")
                                                    .build()

        Hyperwallet.shared.createPaypalAccount(account: paypalAccount, completion: { (result, error) in
        paypalAccountResponse = result
        errorResponse = error
        expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(errorResponse, "The `errorResponse` should not be nil")
        XCTAssertNil(paypalAccountResponse)
        XCTAssertEqual(errorResponse?.getHttpCode(), 400)
        XCTAssertEqual(errorResponse?.getHyperwalletErrors()?.errorList?.first?.fieldName, "email")
    }

    func testGetPaypalAccount_success() {
        // Given
        let expectation = self.expectation(description: "Get paypal account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "PaypalAccountResponse")
        let url = String(format: "%@/paypal-accounts/trm-12345", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var paypalAccountResponse: HyperwalletPaypalAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.getPaypalAccount(transferMethodToken: "trm-12345", completion: { (result, error) in
            paypalAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(paypalAccountResponse?.getFields())
        XCTAssertEqual(paypalAccountResponse?.getField(fieldName: .email) as? String, "test@paypal.com")
    }

    func testUpdatePaypalAccount_success() {
        // Given
        let expectation = self.expectation(description: "Update paypal account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "PaypalAccountResponse")
        let url = String(format: "%@/paypal-accounts/trm-12345", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPutRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var paypalAccountResponse: HyperwalletPaypalAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let paypalAccount = HyperwalletPaypalAccount.Builder(token: "trm-12345").email("test@paypal.com").build()

        Hyperwallet.shared.updatePaypalAccount(account: paypalAccount, completion: { (result, error) in
            paypalAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(paypalAccountResponse?.getFields())
        XCTAssertEqual(paypalAccountResponse?.getField(fieldName: .email) as! String, "test@paypal.com")
    }

    func testUpdatePaypalAccount_invalidEmail() {
        // Given
        let expectation = self.expectation(description: "Update paypal account failed")
        let response = HyperwalletTestHelper.badRequestHTTPResponse(for: "PaypalAccountResponseWithInvalidEmail")
        let url = String(format: "%@/paypal-accounts/trm-12345", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPutRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var paypalAccountResponse: HyperwalletPaypalAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let paypalAccount = HyperwalletPaypalAccount.Builder(token: "trm-12345").email("test").build()

        Hyperwallet.shared.updatePaypalAccount(account: paypalAccount, completion: { (result, error) in
            paypalAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(errorResponse, "The `errorResponse` should not be nil")
        XCTAssertNil(paypalAccountResponse, "The paypalAccountResponse should be nil")
        XCTAssertEqual(errorResponse?.getHttpCode(), 400)
        XCTAssertEqual(errorResponse?.getHyperwalletErrors()?.errorList?.first?.fieldName, "email")
        XCTAssertEqual(errorResponse?.getHyperwalletErrors()?.errorList?.first?.code, "INVALID_EMAIL_ADDRESS")
    }

    func testDeactivatePaypalAccount_success() {
        // Given
        let expectation = self.expectation(description: "Deactivate paypal account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "StatusTransitionMockedResponseSuccess")
        let url = String(format: "%@/paypal-accounts/trm-12345/status-transitions", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostResquest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var statusTransitionResponse: HyperwalletStatusTransition?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.deactivatePaypalAccount(transferMethodToken: "trm-12345",
                                                   notes: "deactivate paypal account",
                                                   completion: { (result, error) in
                                                    statusTransitionResponse = result
                                                    errorResponse = error
                                                    expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(statusTransitionResponse)
        XCTAssertEqual(statusTransitionResponse?.transition, HyperwalletStatusTransition.Status.deactivated)
    }

    func testDeactivatePaypalAccount_invalidTransition() {
        // Given
        let expectation = self.expectation(description: "Deactivate paypal account failed")
        let response = HyperwalletTestHelper
            .badRequestHTTPResponse(for: "StatusTransitionMockedResponseInvalidTransition")
        let url = String(format: "%@/paypal-accounts/trm-12345/status-transitions", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostResquest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var statusTransitionResponse: HyperwalletStatusTransition?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.deactivatePaypalAccount(transferMethodToken: "trm-12345",
                                                   notes: "deactivate bank account",
                                                   completion: { (result, error) in
                                                    statusTransitionResponse = result
                                                    errorResponse = error
                                                    expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(errorResponse, "The `errorResponse` should not be nil")
        XCTAssertNil(statusTransitionResponse, "The statusTransitionResponse should be nil")
        XCTAssertEqual(errorResponse?.getHttpCode(), 400)
        XCTAssertEqual(errorResponse?.getHyperwalletErrors()?.errorList?.first?.code, "INVALID_FIELD_VALUE")
    }

    func testListPaypalAccounts_success() {
        // Given
        let expectation = self.expectation(description: "List paypal account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "ListPaypalAccountResponse")
        let url = String(format: "%@/paypal-accounts?+", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequestRegexMatcher(pattern: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var paypalAccountList: HyperwalletPageList<HyperwalletPaypalAccount>?
        var errorResponse: HyperwalletErrorType?

        // When
        let paypalAccountPagination = HyperwalletPaypalAccountPagination()
        paypalAccountPagination.status = .activated
        paypalAccountPagination.createdAfter = HyperwalletPaypalAccountPagination
                                                .iso8601
                                                .date(from: "2018-12-15T00:30:11")

        Hyperwallet.shared.listPaypalAccounts(pagination: paypalAccountPagination) { (result, error) in
            paypalAccountList = result
            errorResponse = error
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(paypalAccountList, "The `bankAccountList` should not be nil")
        XCTAssertEqual(paypalAccountList?.count, 1, "The `count` should be 204")
        XCTAssertNotNil(paypalAccountList?.data, "The `data` should be not nil")

        XCTAssertNotNil(paypalAccountList?.links, "The `links` should be not nil")
        XCTAssertNotNil(paypalAccountList?.links.first?.params.rel)

        let paypalAccount = paypalAccountList?.data.first
        XCTAssertEqual(paypalAccount?.getField(fieldName: .token) as? String, "trm-123456789")
        XCTAssertEqual(paypalAccount?.getField(fieldName: .email) as? String, "test@paypal.com")
    }

    func testListPaypalAccounts_emptyResult() {
        // Given
        let expectation = self.expectation(description: "List paypal account completed")
        let response = HyperwalletTestHelper.noContentHTTPResponse()
        let url = String(format: "%@/paypal-accounts?+", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequestRegexMatcher(pattern: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var paypalAccountList: HyperwalletPageList<HyperwalletPaypalAccount>?
        var errorResponse: HyperwalletErrorType?

        // When
        let paypalAccountPagination = HyperwalletPaypalAccountPagination()
        paypalAccountPagination.status = .deActivated

        // When
        Hyperwallet.shared.listPaypalAccounts(pagination: paypalAccountPagination) { (result, error) in
            paypalAccountList = result
            errorResponse = error
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNil(paypalAccountList, "The `paypalAccountList` should be nil")
    }
}
