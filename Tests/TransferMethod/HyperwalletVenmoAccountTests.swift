import Hippolyte
@testable import HyperwalletSDK
import XCTest

class HyperwalletVenmoAccountTests: XCTestCase {
    override func setUp() {
        Hyperwallet.setup(HyperwalletTestHelper.authenticationProvider)
    }

    override func tearDown() {
        if Hippolyte.shared.isStarted {
            Hippolyte.shared.stop()
        }
    }

    // create
    func testCreateVenmoAccount_success() {
        // Given
        let expectation = self.expectation(description: "Create Venmo account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "VenmoAccountResponse")
        let url = String(format: "%@/venmo-accounts", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var venmoAccountResponse: HyperwalletVenmoAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let venmoAccount = HyperwalletVenmoAccount
                .Builder(transferMethodCountry: "US",
                         transferMethodCurrency: "USD",
                         transferMethodProfileType: "INDIVIDUAL")
                .accountId("9876543210")
                .build()

        Hyperwallet.shared.createVenmoAccount(account: venmoAccount, completion: { (result, error) in
            venmoAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(venmoAccount)
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(venmoAccountResponse?.getFields())
        XCTAssertEqual(venmoAccountResponse?.accountId, "9876543210")
    }

    func testCreateVenmoAccount_missingMandatoryField_returnBadRequest() {
        // Given
        let expectation = self.expectation(description: "Create Venmo account failed")
        let response = HyperwalletTestHelper.badRequestHTTPResponse(for: "VenmoAccountMissingAccountId")
        let url = String(format: "%@/venmo-accounts", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var venmoResponse: HyperwalletVenmoAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let venmoAccount = HyperwalletVenmoAccount.Builder(
                        transferMethodCountry: "US",
                        transferMethodCurrency: "USD",
                        transferMethodProfileType: "INDIVIDUAL")
                .build()

        Hyperwallet.shared.createVenmoAccount(account: venmoAccount, completion: { (result, error) in
            venmoResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(errorResponse, "The `errorResponse` should not be nil")
        XCTAssertNil(venmoResponse)
        XCTAssertEqual(errorResponse?.getHttpCode(), 400)
        XCTAssertEqual(
                errorResponse?.getHyperwalletErrors()?.errorList?.first?.message,
                "Mobile Number is required. The Mobile Number cannot be left blank. "
                        + "Please enter a valid US Mobile Number.")
        XCTAssertEqual(errorResponse?.getHyperwalletErrors()?.errorList?.first?.code, "CONSTRAINT_VIOLATIONS")
    }

    func testCreateVenmoAccount_wrongFormatPhone_returnBadRequest() {
        // Given
        let expectation = self.expectation(description: "Create Venmo account failed")
        let response = HyperwalletTestHelper.badRequestHTTPResponse(for: "VenmoAccountWrongFormatAccountId")
        let url = String(format: "%@/venmo-accounts", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var venmoResponse: HyperwalletVenmoAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let venmoAccount = HyperwalletVenmoAccount.Builder(
                        transferMethodCountry: "US",
                        transferMethodCurrency: "USD",
                        transferMethodProfileType: "INDIVIDUAL")
                .accountId("my-phone-number")
                .build()

        Hyperwallet.shared.createVenmoAccount(account: venmoAccount, completion: { (result, error) in
            venmoResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(errorResponse, "The `errorResponse` should not be nil")
        XCTAssertNil(venmoResponse)
        XCTAssertEqual(errorResponse?.getHttpCode(), 400)
        XCTAssertEqual(errorResponse?.getHyperwalletErrors()?.errorList?.first?.message,
                       "Mobile Number is invalid. The maximum length of this field is 10.")
        XCTAssertEqual(errorResponse?.getHyperwalletErrors()?.errorList?.first?.code, "CONSTRAINT_VIOLATIONS")
    }

    // get
    func testGetVenmoAccount_success() {
        // Given
        let expectation = self.expectation(description: "Get Venmo account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "VenmoAccountResponse")
        let url = String(format: "%@/venmo-accounts/trm-12345", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var venmoResponse: HyperwalletVenmoAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.getVenmoAccount(transferMethodToken: "trm-12345", completion: { (result, error) in
            venmoResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(venmoResponse?.getFields())
        XCTAssertEqual(venmoResponse?.accountId, "9876543210")
        XCTAssertEqual(venmoResponse?.status, "ACTIVATED")
    }

    // list
    func testListVenmoAccounts_success() {
        // Given
        let expectation = self.expectation(description: "List Venmo account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "VenmoAccountList")
        let url = String(format: "%@/venmo-accounts?+", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequestRegexMatcher(pattern: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var venmoAccounts: HyperwalletPageList<HyperwalletVenmoAccount>?
        var errorResponse: HyperwalletErrorType?

        // When
    let venmoQuery = HyperwalletVenmoQueryParam()
        venmoQuery.status = .activated
        venmoQuery.type = .venmoAccount
        venmoQuery.createdAfter = ISO8601DateFormatter.ignoreTimeZone.date(from: "2018-12-15T00:30:11")

        Hyperwallet.shared.listVenmoAccounts(queryParam: venmoQuery) { (result, error) in
            venmoAccounts = result
            errorResponse = error
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(venmoAccounts, "The `venmoAccounts` should not be nil")
        XCTAssertEqual(venmoAccounts?.count, 1, "The `count` should be 1")
        XCTAssertNotNil(venmoAccounts?.data, "The `data` should be not nil")

        XCTAssertNotNil(venmoAccounts?.links, "The `links` should be not nil")
        XCTAssertNotNil(venmoAccounts?.links?.first?.params?.rel)

        let venmoAccount = venmoAccounts?.data?.first
        XCTAssertEqual(venmoAccount?.token, "trm-123456789")
        XCTAssertEqual(venmoAccount?.accountId, "9876543210")
    }

    func testListVenmoAccounts_emptyResult() {
        // Given
        let expectation = self.expectation(description: "List Venmo account completed")
        let response = HyperwalletTestHelper.noContentHTTPResponse()
        let url = String(format: "%@/venmo-accounts?+", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequestRegexMatcher(pattern: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var venmoAccounts: HyperwalletPageList<HyperwalletVenmoAccount>?
        var errorResponse: HyperwalletErrorType?

        // When
        let venmoQuery = HyperwalletVenmoQueryParam()
        venmoQuery.status = .deActivated
        venmoQuery.type = .venmoAccount

        // When
        Hyperwallet.shared.listVenmoAccounts(queryParam: venmoQuery) { (result, error) in
            venmoAccounts = result
            errorResponse = error
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNil(venmoAccounts, "The `venmoAccounts` should be nil")
    }

    // update
    func testUpdateVenmoAccount_success() {
        // Given
        let expectation = self.expectation(description: "Update Venmo account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "VenmoAccountResponse")
        let url = String(format: "%@/venmo-accounts/trm-123456789", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPutRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var venmoResponse: HyperwalletVenmoAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let venmoAccount = HyperwalletVenmoAccount
                .Builder(token: "trm-123456789")
                .accountId("9876543210")
                .profileType("INDIVIDUAL")
                .build()

        Hyperwallet.shared.updateVenmoAccount(account: venmoAccount, completion: { (result, error) in
            venmoResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(venmoResponse?.getFields())
        XCTAssertEqual(venmoResponse?.accountId, "9876543210")
    }

    func testUpdateVenmoAccount_wrongFormatPhone() {
        // Given
        let expectation = self.expectation(description: "Update Venmo account failed")
        let response = HyperwalletTestHelper.badRequestHTTPResponse(for: "VenmoAccountWrongFormatAccountId")
        let url = String(format: "%@/venmo-accounts/trm-12345", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPutRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var venmoResponse: HyperwalletVenmoAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let venmoAccount = HyperwalletVenmoAccount.Builder(token: "trm-12345").accountId("9876543210").build()

        Hyperwallet.shared.updateVenmoAccount(account: venmoAccount, completion: { (result, error) in
            venmoResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(errorResponse, "The `errorResponse` should not be nil")
        XCTAssertNil(venmoResponse, "The `venmoResponse` should be nil")
        XCTAssertEqual(errorResponse?.getHttpCode(), 400)
        XCTAssertEqual(errorResponse?.getHyperwalletErrors()?.errorList?.first?.message,
                       "Mobile Number is invalid. The maximum length of this field is 10.")
        XCTAssertEqual(errorResponse?.getHyperwalletErrors()?.errorList?.first?.code, "CONSTRAINT_VIOLATIONS")
    }

    // deactivate
    func testDeactivateVenmoAccount_success() {
        // Given
        let expectation = self.expectation(description: "Deactivate Venmo account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "StatusTransitionMockedResponseSuccess")
        let url = String(format: "%@/venmo-accounts/trm-12345/status-transitions", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var statusTransitionResponse: HyperwalletStatusTransition?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.deactivateVenmoAccount(
                transferMethodToken: "trm-12345",
                notes: "deactivate Venmo account",
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

    func testDeactivateVenmoAccount_invalidTransition() {
        // Given
        let expectation = self.expectation(description: "Deactivate Venmo account failed")
        let response = HyperwalletTestHelper
                .badRequestHTTPResponse(for: "StatusTransitionMockedResponseInvalidTransition")
        let url = String(format: "%@/venmo-accounts/trm-12345/status-transitions", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var statusTransitionResponse: HyperwalletStatusTransition?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.deactivateVenmoAccount(
                transferMethodToken: "trm-12345",
                notes: "deactivate Venmo account",
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
}
