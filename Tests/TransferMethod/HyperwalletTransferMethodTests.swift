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
        let bankCard = transferMethods?.data.first { ($0.getField(fieldName: .type) as? String ?? "")  == "BANK_CARD" }
        XCTAssertEqual(bankCard?.getField(fieldName: .type) as? String, "BANK_CARD")
        XCTAssertEqual(bankCard?.getField(fieldName: .token) as? String, "trm-00002")
        XCTAssertEqual(bankCard?.getField(fieldName: .cardNumber) as? String, "************1358")
        XCTAssertEqual(bankCard?.getField(fieldName: .dateOfExpiry) as? String, "2022-12")
        XCTAssertEqual(bankCard?.getField(fieldName: .cardType) as? String, "DEBIT")
        XCTAssertEqual(bankCard?.getField(fieldName: .cardBrand) as? String, "VISA")
        XCTAssertEqual(bankCard?.getField(fieldName: .status) as? String, "ACTIVATED")
        XCTAssertEqual(bankCard?.getField(fieldName: .transferMethodCountry) as? String, "US")
        XCTAssertEqual(bankCard?.getField(fieldName: .transferMethodCurrency) as? String, "USD")

        // check the bank account
        let bankAccount = transferMethods?.data.first {
            ($0.getField(fieldName: .type) as? String ?? "")  == "BANK_ACCOUNT"
        }
        XCTAssertEqual(bankAccount?.getField(fieldName: .type) as? String, "BANK_ACCOUNT")
        XCTAssertEqual(bankAccount?.getField(fieldName: .token) as? String, "trm-00001")
        XCTAssertEqual(bankAccount?.getField(fieldName: .bankAccountId) as? String, "25589087")
        XCTAssertEqual(bankAccount?.getField(fieldName: .status) as? String, "ACTIVATED")
        XCTAssertEqual(bankAccount?.getField(fieldName: .createdOn) as? String, "2018-12-15T00:30:12")
        XCTAssertEqual(bankAccount?.getField(fieldName: .transferMethodCountry) as? String, "US")
        XCTAssertEqual(bankAccount?.getField(fieldName: .transferMethodCurrency) as? String, "USD")
        XCTAssertEqual(bankAccount?.getField(fieldName: .bankId) as? String, "021000021")
        XCTAssertEqual(bankAccount?.getField(fieldName: .branchId) as? String, "021000021")
        XCTAssertEqual(bankAccount?.getField(fieldName: .bankAccountRelationship) as? String, "SELF")
        XCTAssertEqual(bankAccount?.getField(fieldName: .bankAccountPurpose) as? String, "CHECKING")
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
