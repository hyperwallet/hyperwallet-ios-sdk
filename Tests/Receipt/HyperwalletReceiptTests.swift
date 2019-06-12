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

    //swiftlint:disable function_body_length
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
        receiptQueryParam.sortBy = HyperwalletReceiptQueryParam.QuerySortable.descendantAmount.rawValue

        Hyperwallet.shared.listUserReceipts(queryParam: receiptQueryParam) { (result, error) in
            userReceiptList = result
            errorResponse = error
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(userReceiptList, "The `payPalAccountList` should not be nil")
        XCTAssertEqual(userReceiptList?.count, 4, "The `count` should be 4")
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
            assertionFailure("The receipt details should be not nil")
        }

        let lastReceipt = userReceiptList?.data.last!
        XCTAssertEqual(lastReceipt?.type.rawValue, "UNKNOWN_RECEIPT_TYPE")
    }

    func testListPrepaidCardReceipts_success() {
        // Given
        let prepaidCardToken = "trm-a4b44375"
        let expectation = self.expectation(description: "List Prepaid Card Receipts completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "ListPrepaidCardReceiptResponse")
        let url = String(format: "%@/prepaid-cards/\(prepaidCardToken)/receipts", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequestRegexMatcher(pattern: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var prepaidCardReceiptList: HyperwalletPageList<HyperwalletReceipt>?
        var errorResponse: HyperwalletErrorType?
        // When
        let receiptQueryParam = HyperwalletReceiptQueryParam()
        receiptQueryParam.createdAfter = ISO8601DateFormatter.ignoreTimeZone.date(from: "2016-12-01T00:00:00")
        receiptQueryParam.createdBefore = ISO8601DateFormatter.ignoreTimeZone.date(from: "2020-12-31T00:00:00")

        Hyperwallet.shared.listPrepaidCardReceipts(prepaidCardToken: prepaidCardToken,
                                                   queryParam: receiptQueryParam,
                                                   completion: { (result, error) in
            prepaidCardReceiptList = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        guard errorResponse == nil else {
            assertionFailure("The response error should be nil")
            return
        }
        XCTAssertNoThrow(prepaidCardReceiptList!, "The `payPalAccountList` should not be nil")
        XCTAssertNotNil(prepaidCardReceiptList!.data, "The `data` should be not nil")
        XCTAssertEqual(prepaidCardReceiptList!.data.count, 3, "The `data.count` should be 3")
        XCTAssertNotNil(prepaidCardReceiptList!.links, "The `links` should be not nil")
        XCTAssertNotNil(prepaidCardReceiptList!.links.first?.params.rel)

        if let userReceipt = prepaidCardReceiptList?.data.first {
            XCTAssertEqual(userReceipt.journalId, "CC002F14A570")
            XCTAssertEqual(userReceipt.type.rawValue, "DEPOSIT")
            XCTAssertEqual(userReceipt.createdOn, "2019-05-27T16:01:10")
            XCTAssertEqual(userReceipt.entry.rawValue, "CREDIT")
            XCTAssertEqual(userReceipt.destinationToken, "trm-a4b44375")
            XCTAssertEqual(userReceipt.amount, "18.05")
            XCTAssertEqual(userReceipt.currency, "USD")
            if let details = userReceipt.details {
                XCTAssertEqual(details.cardNumber, "************7917")
            } else {
                assertionFailure("The receipt details should be not nil")
            }
        } else {
            assertionFailure("The first receipt in the list should be not nil")
        }
    }
}
