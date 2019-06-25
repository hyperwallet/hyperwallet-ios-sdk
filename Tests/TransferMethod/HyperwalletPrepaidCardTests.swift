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
        let prepaidCardQueryParam = HyperwalletPrepaidCardQueryParm()
        prepaidCardQueryParam.status = HyperwalletPrepaidCardQueryParm.QueryStatus.deActivated
        prepaidCardQueryParam.sortBy = HyperwalletPrepaidCardQueryParm.QuerySortable.ascendantCreatedOn.rawValue
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
        XCTAssertNotNil(prepaidCardList, "The `bankAccountList` should not be nil")
        XCTAssertEqual(prepaidCardList?.count, 2, "The `count` should be 2")
        XCTAssertNotNil(prepaidCardList?.data, "The `data` should be not nil")

        XCTAssertNotNil(prepaidCardList?.links, "The `links` should be not nil")

        let firstPrepaidCard = prepaidCardList?.data.first
        XCTAssertEqual(firstPrepaidCard?.getField(fieldName: .type) as? String, "PREPAID_CARD")
        XCTAssertEqual(firstPrepaidCard?.getField(fieldName: .token) as? String, "trm-123")
        XCTAssertEqual(firstPrepaidCard?.getField(fieldName: .cardNumber) as? String, "************6198")
        XCTAssertEqual(firstPrepaidCard?.getField(fieldName: .dateOfExpiry) as? String, "2023-06")

        let lastPrepaidCard = prepaidCardList?.data.last
        XCTAssertEqual(lastPrepaidCard?.getField(fieldName: .type) as? String, "PREPAID_CARD")
        XCTAssertEqual(lastPrepaidCard?.getField(fieldName: .token) as? String, "trm-456")
        XCTAssertEqual(lastPrepaidCard?.getField(fieldName: .cardNumber) as? String, "************2345")
        XCTAssertEqual(lastPrepaidCard?.getField(fieldName: .dateOfExpiry) as? String, "2023-06")
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
        let prepaidCardQueryParam = HyperwalletPrepaidCardQueryParm()
        prepaidCardQueryParam.status = HyperwalletPrepaidCardQueryParm.QueryStatus.activated
        prepaidCardQueryParam.sortBy = HyperwalletPrepaidCardQueryParm.QuerySortable.ascendantCreatedOn.rawValue
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
