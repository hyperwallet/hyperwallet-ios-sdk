import Hippolyte
@testable import HyperwalletSDK
import XCTest

class HyperwalletReceiptTests: XCTestCase {
    override func setUp() {
        Hyperwallet.setup(HyperwalletTestHelper.authenticationProvider)
    }

    override func tearDown() {
        if Hippolyte.shared.isStarted {
            Hippolyte.shared.stop()
        }
    }

    func testListUserReceipts_success() {
        // Given
        let expectation = self.expectation(description: "List User Receipts completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "ListUserReceiptResponse")
        let url = String(format: "%@/receipts", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequestRegexMatcher(pattern: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var userReceiptList: HyperwalletPageList<HyperwalletReceipt>?
        var errorResponse: HyperwalletErrorType?

        // When
        let receiptQueryParam = HyperwalletReceiptQueryParam()
        receiptQueryParam.createdAfter = ISO8601DateFormatter.ignoreTimeZone.date(from: "2018-12-01T00:00:00")
        receiptQueryParam.createdBefore = ISO8601DateFormatter.ignoreTimeZone.date(from: "2020-12-31T00:00:00")
        receiptQueryParam.currency = "USD"
        receiptQueryParam.sortBy = HyperwalletReceiptQueryParam.QuerySortable.descendantAmount

        Hyperwallet.shared.listUserReceipts(queryParam: receiptQueryParam) { (result, error) in
            userReceiptList = result
            errorResponse = error
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(userReceiptList, "The `payPalAccountList` should not be nil")
        XCTAssertEqual(userReceiptList?.count, 3, "The `count` should be 3")
        XCTAssertNotNil(userReceiptList?.data, "The `data` should be not nil")
        XCTAssertNotNil(userReceiptList?.links, "The `links` should be not nil")
        XCTAssertNotNil(userReceiptList?.links.first?.params.rel)

        if let userReceipt = userReceiptList?.data.first {
            XCTAssertEqual(userReceipt.journalId, "51660665")
            XCTAssertEqual(userReceipt.type.rawValue, "PAYMENT")
            XCTAssertEqual(userReceipt.createdOn, "2019-05-27T15:42:07")
            XCTAssertEqual(userReceipt.entry.rawValue, "CREDIT")
            XCTAssertEqual(userReceipt.sourceToken, "act-12345")
            XCTAssertEqual(userReceipt.destinationToken, "usr-12345")
            XCTAssertEqual(userReceipt.amount, "5000.00")
            XCTAssertEqual(userReceipt.fee, "0.00")
            XCTAssertEqual(userReceipt.currency, "USD")
            if let details = userReceipt.details {
                XCTAssertEqual(details.clientPaymentId, "trans-0001")
                XCTAssertEqual(details.payeeName, "Vasya Pupkin")
            } else {
                assertionFailure("The receipt details should be not nil")
            }
        } else {
            assertionFailure("The first receipt in the list should be not nil")
        }
    }
}
