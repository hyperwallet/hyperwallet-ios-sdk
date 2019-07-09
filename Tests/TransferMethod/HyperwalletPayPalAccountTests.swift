import Hippolyte
@testable import HyperwalletSDK
import XCTest

// swiftlint:disable force_cast
class HyperwalletPayPalAccountTests: XCTestCase {
    override func setUp() {
        Hyperwallet.setup(HyperwalletTestHelper.authenticationProvider)
    }

    override func tearDown() {
        if Hippolyte.shared.isStarted {
            Hippolyte.shared.stop()
        }
    }

    func testCreatePayPalAccount_success() {
        // Given
        let expectation = self.expectation(description: "Create PayPal account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "PayPalAccountResponse")
        let url = String(format: "%@/paypal-accounts", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var payPalAccountResponse: HyperwalletPayPalAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let payPalAccount = HyperwalletPayPalAccount
            .Builder(transferMethodCountry: "US",
                     transferMethodCurrency: "USD",
                     transferMethodProfileType: "INDIVIDUAL")
            .email("test@paypal.com")
            .build()

        Hyperwallet.shared.createPayPalAccount(account: payPalAccount, completion: { (result, error) in
            payPalAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(payPalAccount)
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(payPalAccountResponse?.getFields())
        XCTAssertEqual(payPalAccountResponse?.email, "test@paypal.com")
    }

    func testCreatePayPalAccount_missingMandatoryField_returnBadRequest() {
        // Given
        let expectation = self.expectation(description: "Create PayPal account failed")
        let response = HyperwalletTestHelper.badRequestHTTPResponse(for: "PayPalAccountResponseWithMissingEmail")
        let url = String(format: "%@/paypal-accounts", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var payPalAccountResponse: HyperwalletPayPalAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let payPalAccount = HyperwalletPayPalAccount.Builder(transferMethodCountry: "US",
                                                             transferMethodCurrency: "USD",
                                                             transferMethodProfileType: "INDIVIDUAL")
                                                    .build()

        Hyperwallet.shared.createPayPalAccount(account: payPalAccount, completion: { (result, error) in
        payPalAccountResponse = result
        errorResponse = error
        expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(errorResponse, "The `errorResponse` should not be nil")
        XCTAssertNil(payPalAccountResponse)
        XCTAssertEqual(errorResponse?.getHttpCode(), 400)
        XCTAssertEqual(errorResponse?.getHyperwalletErrors()?.errorList?.first?.fieldName, "email")
    }

    func testCreatePayPalAccount_notProfileEmail_returnBadRequest() {
        // Given
        let expectation = self.expectation(description: "Create PayPal account failed")
        let response = HyperwalletTestHelper.badRequestHTTPResponse(for: "PayPalAccountResponseNotProfileEmail")
        let url = String(format: "%@/paypal-accounts", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var payPalAccountResponse: HyperwalletPayPalAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let payPalAccount = HyperwalletPayPalAccount.Builder(transferMethodCountry: "US",
                                                             transferMethodCurrency: "USD",
                                                             transferMethodProfileType: "INDIVIDUAL")
                                                    .email("notProfileEmail@paypal.com")
                                                    .build()

        Hyperwallet.shared.createPayPalAccount(account: payPalAccount, completion: { (result, error) in
            payPalAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(errorResponse, "The `errorResponse` should not be nil")
        XCTAssertNil(payPalAccountResponse)
        XCTAssertEqual(errorResponse?.getHttpCode(), 400)
        XCTAssertNil(errorResponse?.getHyperwalletErrors()?.errorList?.first?.fieldName)
        XCTAssertEqual(errorResponse?.getHyperwalletErrors()?.errorList?.first?.code, "CONSTRAINT_VIOLATIONS")
    }

    func testGetPayPalAccount_success() {
        // Given
        let expectation = self.expectation(description: "Get PayPal account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "PayPalAccountResponse")
        let url = String(format: "%@/paypal-accounts/trm-12345", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var payPalAccountResponse: HyperwalletPayPalAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.getPayPalAccount(transferMethodToken: "trm-12345", completion: { (result, error) in
            payPalAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(payPalAccountResponse?.getFields())
        XCTAssertEqual(payPalAccountResponse?.email, "test@paypal.com")
        XCTAssertEqual(payPalAccountResponse?.profileType, "INDIVIDUAL")
    }

    func testUpdatePayPalAccount_success() {
        // Given
        let expectation = self.expectation(description: "Update PayPal account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "PayPalAccountResponse")
        let url = String(format: "%@/paypal-accounts/trm-12345", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPutRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var payPalAccountResponse: HyperwalletPayPalAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let payPalAccount = HyperwalletPayPalAccount
            .Builder(token: "trm-12345")
            .email("test@paypal.com")
            .profileType("INDIVIDUAL")
            .build()

        Hyperwallet.shared.updatePayPalAccount(account: payPalAccount, completion: { (result, error) in
            payPalAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(payPalAccountResponse?.getFields())
        XCTAssertEqual(payPalAccountResponse?.email, "test@paypal.com")
    }

    func testUpdatePayPalAccount_invalidEmail() {
        // Given
        let expectation = self.expectation(description: "Update PayPal account failed")
        let response = HyperwalletTestHelper.badRequestHTTPResponse(for: "PayPalAccountResponseWithInvalidEmail")
        let url = String(format: "%@/paypal-accounts/trm-12345", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPutRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var payPalAccountResponse: HyperwalletPayPalAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let payPalAccount = HyperwalletPayPalAccount.Builder(token: "trm-12345").email("test").build()

        Hyperwallet.shared.updatePayPalAccount(account: payPalAccount, completion: { (result, error) in
            payPalAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(errorResponse, "The `errorResponse` should not be nil")
        XCTAssertNil(payPalAccountResponse, "The payPalAccountResponse should be nil")
        XCTAssertEqual(errorResponse?.getHttpCode(), 400)
        XCTAssertEqual(errorResponse?.getHyperwalletErrors()?.errorList?.first?.fieldName, "email")
        XCTAssertEqual(errorResponse?.getHyperwalletErrors()?.errorList?.first?.code, "INVALID_EMAIL_ADDRESS")
    }

    func testDeactivatePayPalAccount_success() {
        // Given
        let expectation = self.expectation(description: "Deactivate PayPal account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "StatusTransitionMockedResponseSuccess")
        let url = String(format: "%@/paypal-accounts/trm-12345/status-transitions", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var statusTransitionResponse: HyperwalletStatusTransition?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.deactivatePayPalAccount(transferMethodToken: "trm-12345",
                                                   notes: "deactivate PayPal account",
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

    func testDeactivatePayPalAccount_invalidTransition() {
        // Given
        let expectation = self.expectation(description: "Deactivate PayPal account failed")
        let response = HyperwalletTestHelper
            .badRequestHTTPResponse(for: "StatusTransitionMockedResponseInvalidTransition")
        let url = String(format: "%@/paypal-accounts/trm-12345/status-transitions", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var statusTransitionResponse: HyperwalletStatusTransition?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.deactivatePayPalAccount(transferMethodToken: "trm-12345",
                                                   notes: "deactivate PayPal account",
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

    func testListPayPalAccounts_success() {
        // Given
        let expectation = self.expectation(description: "List PayPal account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "ListPayPalAccountResponse")
        let url = String(format: "%@/paypal-accounts?+", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequestRegexMatcher(pattern: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var payPalAccountList: HyperwalletPageList<HyperwalletPayPalAccount>?
        var errorResponse: HyperwalletErrorType?

        // When
        let payPalAccountQueryParam = HyperwalletPayPalAccountQueryParam()
        payPalAccountQueryParam.status = .activated
        payPalAccountQueryParam.createdAfter = ISO8601DateFormatter.ignoreTimeZone.date(from: "2018-12-15T00:30:11")

        Hyperwallet.shared.listPayPalAccounts(queryParam: payPalAccountQueryParam) { (result, error) in
            payPalAccountList = result
            errorResponse = error
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(payPalAccountList, "The `payPalAccountList` should not be nil")
        XCTAssertEqual(payPalAccountList?.count, 1, "The `count` should be 1")
        XCTAssertNotNil(payPalAccountList?.data, "The `data` should be not nil")

        XCTAssertNotNil(payPalAccountList?.links, "The `links` should be not nil")
        XCTAssertNotNil(payPalAccountList?.links.first?.params.rel)

        let payPalAccount = payPalAccountList?.data.first
        XCTAssertEqual(payPalAccount?.token, "trm-123456789")
        XCTAssertEqual(payPalAccount?.email, "test@paypal.com")
    }

    func testListPayPalAccounts_emptyResult() {
        // Given
        let expectation = self.expectation(description: "List PayPal account completed")
        let response = HyperwalletTestHelper.noContentHTTPResponse()
        let url = String(format: "%@/paypal-accounts?+", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequestRegexMatcher(pattern: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var payPalAccountList: HyperwalletPageList<HyperwalletPayPalAccount>?
        var errorResponse: HyperwalletErrorType?

        // When
        let payPalAccountQueryParam = HyperwalletPayPalAccountQueryParam()
        payPalAccountQueryParam.status = .deActivated

        // When
        Hyperwallet.shared.listPayPalAccounts(queryParam: payPalAccountQueryParam) { (result, error) in
            payPalAccountList = result
            errorResponse = error
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNil(payPalAccountList, "The `payPalAccountList` should be nil")
    }
}
