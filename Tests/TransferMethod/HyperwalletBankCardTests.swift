import Hippolyte
@testable import HyperwalletSDK
import XCTest

class HyperwalletBankCardTests: XCTestCase {
    override func setUp() {
        Hyperwallet.setup(HyperwalletTestHelper.authenticationProvider)
    }

    override func tearDown() {
        if Hippolyte.shared.isStarted {
            Hippolyte.shared.stop()
        }
    }

    func testCreateBankCard_success() {
        // Given
        let expectation = self.expectation(description: "Create bank card completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "BankCardResponse")
        let url = String(format: "%@/bank-cards", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var bankCardResponse: HyperwalletBankCard?
        var errorResponse: HyperwalletErrorType?

        // When
        let bankCard = HyperwalletBankCard.Builder(transferMethodCountry: "US",
                                                   transferMethodCurrency: "USD",
                                                   transferMethodProfileType: "INDIVIDUAL")
            .cardNumber("4216701111100114")
            .dateOfExpiry("2022-12")
            .cvv("123")
            .build()

        Hyperwallet.shared.createBankCard(account: bankCard, completion: { (result, error) in
            bankCardResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(bankCard)
        XCTAssertNotNil(bankCardResponse?.getFields())
        XCTAssertEqual(bankCardResponse?.token, "trm-123")
    }

    func testCreateBankCard_missingMandatoryField_returnBadRequest() {
        // Given
        let expectation = self.expectation(description: "Create bank card failed")
        let response = HyperwalletTestHelper.badRequestHTTPResponse(for: "BankCardErrorResponseWithMissingCardNumber")
        let url = String(format: "%@/bank-cards", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var bankCardResponse: HyperwalletBankCard?
        var errorResponse: HyperwalletErrorType?

        // When
        let bankCard = HyperwalletBankCard.Builder(transferMethodCountry: "US",
                                                   transferMethodCurrency: "USD",
                                                   transferMethodProfileType: "INDIVIDUAL")
            .cardNumber("")
            .dateOfExpiry("2018-12")
            .cvv("")
            .build()

        Hyperwallet.shared.createBankCard(account: bankCard, completion: { (result, error) in
            bankCardResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(errorResponse, "The `errorResponse` should not be nil")
        XCTAssertNil(bankCardResponse)
        XCTAssertEqual(errorResponse?.getHttpCode(), 400)
        XCTAssertEqual(errorResponse?.getHyperwalletErrors()?.errorList?.first?.fieldName, "cardNumber")
    }

    func testGetBankCard_success() {
        // Given
        let expectation = self.expectation(description: "Get bank card completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "BankCardResponse")
        let url = String(format: "%@/bank-cards/trm-12345", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var bankCardResponse: HyperwalletBankCard?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.getBankCard(transferMethodToken: "trm-12345", completion: { (result, error) in
            bankCardResponse = result
            errorResponse = error
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(bankCardResponse?.getFields())
        XCTAssertEqual(bankCardResponse?.cardBrand, "VISA")
    }

    func testUpdateBankCard_success() {
        // Given
        let expectation = self.expectation(description: "Update bank card completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "BankCardResponse")
        let url = String(format: "%@/bank-cards/trm-12345", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPutRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var bankCardResponse: HyperwalletBankCard?
        var errorResponse: HyperwalletErrorType?

        // When
        let bankCard = HyperwalletBankCard
            .Builder(token: "trm-12345")
            .dateOfExpiry("2022-12")
            .build()

        Hyperwallet.shared.updateBankCard(account: bankCard, completion: { (result, error) in
            bankCardResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(bankCardResponse?.getFields())
        XCTAssertEqual(bankCardResponse?.dateOfExpiry, "2022-12")
    }

    func testUpdateBankCard_invalidCardNumberLength() {
        // Given
        let expectation = self.expectation(description: "Update bank card failed")
        let response = HyperwalletTestHelper.badRequestHTTPResponse(for: "BankCardErrorResponseWithInvalidCardNumber")
        let url = String(format: "%@/bank-cards/trm-12345", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPutRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var bankCardResponse: HyperwalletBankCard?
        var errorResponse: HyperwalletErrorType?

        // When
        let bankCard = HyperwalletBankCard
            .Builder(token: "trm-12345")
            .cardNumber("123")
            .build()

        Hyperwallet.shared.updateBankCard(account: bankCard, completion: { (result, error) in
            bankCardResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(errorResponse, "The `errorResponse` should not be nil")
        XCTAssertNil(bankCardResponse, "The bankCardResponse should be nil")
        XCTAssertEqual(errorResponse?.getHttpCode(), 400)
        XCTAssertEqual(errorResponse?.getHyperwalletErrors()?.errorList?.first?.fieldName, "cardNumber")
        XCTAssertEqual(errorResponse?.getHyperwalletErrors()?.errorList?.first?.code, "INVALID_FIELD_LENGTH")
    }

    func testDeactivateBankCard_success() {
        // Given
        let expectation = self.expectation(description: "Deactivate bank card completed")
        let response = HyperwalletTestHelper .okHTTPResponse(for: "StatusTransitionMockedResponseSuccess")
        let url = String(format: "%@/bank-cards/trm-12345/status-transitions", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var statusTransitionResponse: HyperwalletStatusTransition?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.deactivateBankCard(transferMethodToken: "trm-12345",
                                              notes: "deactivate bank card",
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

    func testDeactivateBankCard_invalidTransition() {
        // Given
        let expectation = self.expectation(description: "Deactivate bank card failed")
        let response = HyperwalletTestHelper
            .badRequestHTTPResponse(for: "StatusTransitionMockedResponseInvalidTransition")
        let url = String(format: "%@/bank-cards/trm-12345/status-transitions", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var statusTransitionResponse: HyperwalletStatusTransition?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.deactivateBankCard(transferMethodToken: "trm-12345",
                                              notes: "deactivate bank card",
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

    func testListBankCards_success() {
        // Given
        let expectation = self.expectation(description: "List bank cards completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "ListBankCardResponse")
        let url = String(format: "%@/bank-cards?+", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequestRegexMatcher(pattern: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var bankCardList: HyperwalletPageList<HyperwalletBankCard>?
        var errorResponse: HyperwalletErrorType?

        // When
        let bankCardQueryParam = HyperwalletBankCardQueryParam()
        bankCardQueryParam.status = HyperwalletBankCardQueryParam.QueryStatus.deActivated
        bankCardQueryParam.sortBy = HyperwalletBankCardQueryParam.QuerySortable.ascendantCreatedOn.rawValue
        bankCardQueryParam.createdAfter = ISO8601DateFormatter.ignoreTimeZone.date(from: "2018-12-15T00:30:11")
        bankCardQueryParam.createdBefore = ISO8601DateFormatter.ignoreTimeZone.date(from: "2018-12-18T00:30:11")

        Hyperwallet.shared.listBankCards(queryParam: bankCardQueryParam) { (result, error) in
            bankCardList = result
            errorResponse = error
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(bankCardList, "The `bankCardList` should not be nil")
        XCTAssertEqual(bankCardList?.count, 21, "The `count` should be 21")
        XCTAssertNotNil(bankCardList?.data, "The `data` should be not nil")

        XCTAssertNotNil(bankCardList?.links, "The `links` should be not nil")
        let linkNext = bankCardList?.links.first { $0.params.rel == "next" }
        XCTAssertNotNil(linkNext?.href)

        let bankCard = bankCardList?.data.first
        XCTAssertEqual(bankCard?.type, "BANK_CARD")
        XCTAssertEqual(bankCard?.token, "trm-12345")
        XCTAssertEqual(bankCard?.cardNumber, "************0199")
        XCTAssertEqual(bankCard?.dateOfExpiry, "2022-12")
    }

    func testListBankCards_emptyResult() {
        // Given
        let expectation = self.expectation(description: "List bank cards completed")
        let response = HyperwalletTestHelper.noContentHTTPResponse()
        let url = String(format: "%@/bank-cards?+", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequestRegexMatcher(pattern: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var bankCardList: HyperwalletPageList<HyperwalletBankCard>?
        var errorResponse: HyperwalletErrorType?

        // When
        let bankCardQueryParam = HyperwalletBankCardQueryParam()
        bankCardQueryParam.status = HyperwalletBankCardQueryParam.QueryStatus.activated
        bankCardQueryParam.sortBy = HyperwalletBankCardQueryParam.QuerySortable.ascendantCreatedOn.rawValue
        bankCardQueryParam.createdAfter = ISO8601DateFormatter.ignoreTimeZone.date(from: "2019-01-01T00:30:11")

        Hyperwallet.shared.listBankCards(queryParam: bankCardQueryParam) { (result, error) in
            bankCardList = result
            errorResponse = error
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNil(bankCardList, "The `bankCardList` should be nil")
    }
}
