import Hippolyte
@testable import HyperwalletSDK
import XCTest

// swiftlint:disable function_body_length
class HyperwalletTransferMethodTests: XCTestCase {
    override func setUp() {
        Hyperwallet.setup(HyperwalletTestHelper.authenticationProvider)
    }

    override func tearDown() {
        if Hippolyte.shared.isStarted {
            Hippolyte.shared.stop()
        }
    }

    func testListTransferMethods_success() {
        // Given
        let expectation = self.expectation(description: "List transfer methods completed")
        let url = String(format: "%@%@", HyperwalletTestHelper.userRestURL, "/transfer-methods?")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "TransferMethodMockedSuccessResponse")
        let request = HyperwalletTestHelper.buildGetRequestRegexMatcher(pattern: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var transferMethods: HyperwalletPageList<HyperwalletTransferMethod>?
        var errorResponse: HyperwalletErrorType?

        let transferMethodQueryParam = HyperwalletTransferMethodQueryParam()
        transferMethodQueryParam.sortBy = HyperwalletTransferMethodQueryParam.QuerySortable.ascendantCreatedOn.rawValue
        transferMethodQueryParam.createdAfter = ISO8601DateFormatter.ignoreTimeZone.date(
            from: "2018-12-15T00:30:11")
        transferMethodQueryParam.createdBefore = ISO8601DateFormatter.ignoreTimeZone.date(
            from: "2018-12-18T00:30:11")

        // When
        Hyperwallet.shared.listTransferMethods(queryParam: transferMethodQueryParam) { (result, error) in
            transferMethods = result
            errorResponse = error
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(transferMethods, "The `transferMethods` should not be nil")
        XCTAssertEqual(transferMethods?.count, 2, "The `count` should be 2")
        XCTAssertNotNil(transferMethods?.data, "The `data` should be not nil")

        // Check the links
        XCTAssertNotNil(transferMethods?.links, "The `links` should be not nil")
        let linkNext = transferMethods?.links.first { $0.params.rel == "next" }
        XCTAssertNotNil(linkNext?.href)

        // check the bank card
        let bankCard = transferMethods?.data.first { ($0.type ?? "")  == "BANK_CARD" }

        XCTAssertEqual(bankCard?.type, "BANK_CARD")
        XCTAssertEqual(bankCard?.token, "trm-00002")
        XCTAssertEqual(bankCard?.status, "ACTIVATED")
        XCTAssertEqual(bankCard?.transferMethodCountry, "US")
        XCTAssertEqual(bankCard?.transferMethodCurrency, "USD")
        XCTAssertEqual(bankCard?.getField(fieldName: .cardNumber), "************1358")
        XCTAssertEqual(bankCard?.getField(fieldName: .dateOfExpiry), "2022-12")
        XCTAssertEqual(bankCard?.getField(fieldName: .cardType), "DEBIT")
        XCTAssertEqual(bankCard?.getField(fieldName: .cardBrand), "VISA")

        // check the bank account
        let bankAccount = transferMethods?.data.first { ($0.type ?? "")  == "BANK_ACCOUNT" }

        XCTAssertEqual(bankAccount?.type, "BANK_ACCOUNT")
        XCTAssertEqual(bankAccount?.token, "trm-00001")
        XCTAssertEqual(bankAccount?.status, "ACTIVATED")
        XCTAssertEqual(bankAccount?.createdOn, "2018-12-15T00:30:12")
        XCTAssertEqual(bankAccount?.transferMethodCountry, "US")
        XCTAssertEqual(bankAccount?.transferMethodCurrency, "USD")
        XCTAssertEqual(bankAccount?.getField(fieldName: .bankAccountId), "25589087")
        XCTAssertEqual(bankAccount?.getField(fieldName: .bankId), "021000021")
        XCTAssertEqual(bankAccount?.getField(fieldName: .branchId), "021000021")
        XCTAssertEqual(bankAccount?.getField(fieldName: .bankAccountRelationship), "SELF")
        XCTAssertEqual(bankAccount?.getField(fieldName: .bankAccountPurpose), "CHECKING")
    }

    func testListTransferMethods_emptyResult() {
        // Given
        let expectation = self.expectation(description: "List transfer methods completed")
        let url = String(format: "%@%@", HyperwalletTestHelper.userRestURL, "/transfer-methods?")
        let response = HyperwalletTestHelper.noContentHTTPResponse()
        let request = HyperwalletTestHelper.buildGetRequestRegexMatcher(pattern: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var transferMethods: HyperwalletPageList<HyperwalletTransferMethod>?
        var errorResponse: HyperwalletErrorType?

        let transferMethodQueryParam = HyperwalletTransferMethodQueryParam()
        transferMethodQueryParam.sortBy = HyperwalletTransferMethodQueryParam.QuerySortable.ascendantCreatedOn.rawValue
        transferMethodQueryParam.createdAfter = ISO8601DateFormatter.ignoreTimeZone.date(from: "2019-01-01T00:30:11")

        // When
        Hyperwallet.shared.listTransferMethods(queryParam: transferMethodQueryParam) { (result, error) in
            transferMethods = result
            errorResponse = error
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNil(transferMethods, "The `transferMethods` should be nil")
    }
}
