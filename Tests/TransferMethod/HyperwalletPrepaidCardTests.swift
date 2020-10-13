import Hippolyte
@testable import HyperwalletSDK
import XCTest

class HyperwalletPrepaidCardTests: XCTestCase {
    override func setUp() {
        Hyperwallet.setup(HyperwalletTestHelper.authenticationProvider)
    }

    override func tearDown() {
        if Hippolyte.shared.isStarted {
            Hippolyte.shared.stop()
        }
    }

    func testGetPrepaidCard_success() {
        // Given
        let expectation = self.expectation(description: "Get prepaid card completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "PrepaidCardResponse")
        let url = String(format: "%@/prepaid-cards/trm-123", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var prepaidCardResponse: HyperwalletPrepaidCard?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.getPrepaidCard(transferMethodToken: "trm-123", completion: { (result, error) in
            prepaidCardResponse = result
            errorResponse = error
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(prepaidCardResponse?.getFields())
        XCTAssertEqual(prepaidCardResponse?.cardBrand, "VISA")
        XCTAssertEqual(prepaidCardResponse?.type, HyperwalletTransferMethod.TransferMethodType.prepaidCard.rawValue)
    }

    //swiftlint:disable function_body_length
    func testListPrepaidCards_success() {
        // Given
        let expectation = self.expectation(description: "List prepaid cards completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "ListPrepaidCardResponse")
        let url = String(format: "%@/prepaid-cards?+", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequestRegexMatcher(pattern: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var prepaidCardList: HyperwalletPageList<HyperwalletPrepaidCard>?
        var errorResponse: HyperwalletErrorType?

        // When
        let prepaidCardQueryParam = HyperwalletPrepaidCardQueryParam()
        prepaidCardQueryParam.status = HyperwalletPrepaidCardQueryParam.QueryStatus.deActivated.rawValue
        prepaidCardQueryParam.sortBy = HyperwalletPrepaidCardQueryParam.QuerySortable.ascendantCreatedOn.rawValue
        prepaidCardQueryParam.createdAfter = ISO8601DateFormatter.ignoreTimeZone.date(from: "2019-06-20T21:21:43")
        prepaidCardQueryParam.createdBefore = ISO8601DateFormatter.ignoreTimeZone.date(from: "2019-06-20T23:21:43")

        Hyperwallet.shared.listPrepaidCards(queryParam: prepaidCardQueryParam) { (result, error) in
            prepaidCardList = result
            errorResponse = error
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(prepaidCardList, "The `prepaidCardList` should not be nil")
        XCTAssertEqual(prepaidCardList?.count, 2, "The `count` should be 2")
        XCTAssertNotNil(prepaidCardList?.data, "The `data` should be not nil")

        XCTAssertNotNil(prepaidCardList?.links, "The `links` should be not nil")

        let firstPrepaidCard = prepaidCardList?.data?.first
        XCTAssertEqual(firstPrepaidCard?.type, "PREPAID_CARD", "The type should be PREPAID_CARD")
        XCTAssertEqual(firstPrepaidCard?.token, "trm-123", "The token should be trm-123")
        XCTAssertEqual(firstPrepaidCard?.status, "DEACTIVATED", "The status should be DEACTIVATED")
        XCTAssertEqual(firstPrepaidCard?.transferMethodCountry, "CA", "The country code should be CA")
        XCTAssertEqual(firstPrepaidCard?.transferMethodCurrency, "USD", "The currency code should be USD")

        XCTAssertEqual(firstPrepaidCard?.cardNumber, "************6198", "The cardNumber should be ************6198")
        XCTAssertEqual(firstPrepaidCard?.dateOfExpiry, "2023-06", "The dateOfExpiry should be 2023-06")
        XCTAssertEqual(firstPrepaidCard?.cardPackage, "L1", "The cardPackage should be L1")
        XCTAssertEqual(firstPrepaidCard?.createdOn,
                       "2019-06-20T21:21:43",
                       "The createdOn should be 2019-06-20T21:21:43")

        let lastPrepaidCard = prepaidCardList?.data?.last
        XCTAssertEqual(lastPrepaidCard?.type, "PREPAID_CARD", "The type should be PREPAID_CARD")
        XCTAssertEqual(lastPrepaidCard?.token, "trm-456", "The token should be trm-456")
        XCTAssertEqual(lastPrepaidCard?.primaryCardToken, "trm-123", "The primary card token should be trm-123")
        XCTAssertEqual(lastPrepaidCard?.cardNumber, "************2345", "The cardNumber should be ************2345")
        XCTAssertEqual(lastPrepaidCard?.dateOfExpiry, "2023-06", "The dateOfExpiry should be 2023-06")
        XCTAssertEqual(lastPrepaidCard?.cardPackage, "L1", "The cardPackage should be L1")
        XCTAssertEqual(lastPrepaidCard?.createdOn,
                       "2019-06-20T22:21:43",
                       "The createdOn should be 2019-06-20T21:21:43")
    }

    func testListPrepaidCards_emptyResult() {
        // Given
        let expectation = self.expectation(description: "List prepaid cards completed")
        let response = HyperwalletTestHelper.noContentHTTPResponse()
        let url = String(format: "%@/prepaid-cards?+", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequestRegexMatcher(pattern: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var prepaidCardList: HyperwalletPageList<HyperwalletPrepaidCard>?
        var errorResponse: HyperwalletErrorType?

        // When
        let prepaidCardQueryParam = HyperwalletPrepaidCardQueryParam()
        prepaidCardQueryParam.status = HyperwalletPrepaidCardQueryParam.QueryStatus.activated.rawValue
        prepaidCardQueryParam.sortBy = HyperwalletPrepaidCardQueryParam.QuerySortable.ascendantCreatedOn.rawValue
        prepaidCardQueryParam.createdAfter = ISO8601DateFormatter.ignoreTimeZone.date(from: "2019-01-01T00:30:11")

        Hyperwallet.shared.listPrepaidCards(queryParam: prepaidCardQueryParam) { (result, error) in
            prepaidCardList = result
            errorResponse = error
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNil(prepaidCardList, "The `prepaidCardList` should be nil")
    }
}
