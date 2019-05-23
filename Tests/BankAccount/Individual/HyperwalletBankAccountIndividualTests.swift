import Hippolyte
@testable import HyperwalletSDK
import XCTest

// swiftlint:disable force_cast
class HyperwalletBankAccountIndividualTests: XCTestCase {
    override func setUp() {
        Hyperwallet.setup(HyperwalletTestHelper.authenticationProvider)
    }

    override func tearDown() {
        if Hippolyte.shared.isStarted {
            Hippolyte.shared.stop()
        }
    }

    func testCreateBankAccount_individual_success() {
        // Given
        let expectation = self.expectation(description: "Create bank account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "BankAccountIndividualResponse")
        let url = String(format: "%@/bank-accounts", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostResquest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var bankAccountResponse: HyperwalletBankAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let bankAccount = HyperwalletBankAccount
            .Builder(transferMethodCountry: "US",
                     transferMethodCurrency: "USD",
                     transferMethodProfileType: "INDIVIDUAL")
            .bankAccountId("12345")
            .branchId("123456")
            .bankId("0010")
            .bankAccountRelationship(.self)
            .bankAccountPurpose(.checking)
            .build()

        Hyperwallet.shared.createBankAccount(account: bankAccount, completion: { (result, error) in
            bankAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(bankAccount)
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(bankAccountResponse?.getFields())
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .city) as! String, "San Francisco")
    }

    func testCreateBankAccount_missingMandatoryField_returnBadRequest() {
        // Given
        let expectation = self.expectation(description: "Create bank account failed")
        let response = HyperwalletTestHelper.badRequestHTTPResponse(for: "BankAccountErrorResponseWithMissingBankId")
        let url = String(format: "%@/bank-accounts", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostResquest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var bankAccountResponse: HyperwalletBankAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let bankAccount = HyperwalletBankAccount.Builder(transferMethodCountry: "US",
                                                         transferMethodCurrency: "USD",
                                                         transferMethodProfileType: "INDIVIDUAL")
                                                .bankAccountId("12345")
                                                .branchId("123456")
                                                .bankAccountPurpose(.checking)
            .build()

        Hyperwallet.shared.createBankAccount(account: bankAccount, completion: { (result, error) in
            bankAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(errorResponse, "The `errorResponse` should not be nil")
        XCTAssertNil(bankAccountResponse)
        XCTAssertEqual(errorResponse?.getHttpCode(), 400)
        XCTAssertEqual(errorResponse?.getHyperwalletErrors()?.errorList?.first?.fieldName, "bankId")
    }

    func testGetBankAccount_success() {
        // Given
        let expectation = self.expectation(description: "Get bank account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "BankAccountIndividualResponse")
        let url = String(format: "%@/bank-accounts/trm-12345", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var bankAccountResponse: HyperwalletBankAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.getBankAccount(transferMethodToken: "trm-12345", completion: { (result, error) in
            bankAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(bankAccountResponse?.getFields())
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .bankAccountPurpose) as? String, "CHECKING")
    }

    func testUpdateBankAccount_success() {
        // Given
        let expectation = self.expectation(description: "Update bank account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "BankAccountIndividualResponse")
        let url = String(format: "%@/bank-accounts/trm-12345", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPutRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var bankAccountResponse: HyperwalletBankAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let bankAccount = HyperwalletBankAccount
            .Builder(token: "trm-12345")
            .branchId("026009593")
            .build()

        Hyperwallet.shared.updateBankAccount(account: bankAccount, completion: { (result, error) in
            bankAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(bankAccountResponse?.getFields())
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .branchId) as! String, "026009593")
    }

    func testUpdateBankAccount_invalidBranchIdLength() {
        // Given
        let expectation = self.expectation(description: "Update bank account failed")
        let response = HyperwalletTestHelper.badRequestHTTPResponse(for: "BankCardErrorResponseWithInvalidBranchId")
        let url = String(format: "%@/bank-accounts/trm-12345", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPutRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var bankAccountResponse: HyperwalletBankAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let bankAccount = HyperwalletBankAccount
            .Builder(token: "trm-12345")
            .branchId("026009593")
            .build()

        Hyperwallet.shared.updateBankAccount(account: bankAccount, completion: { (result, error) in
            bankAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(errorResponse, "The `errorResponse` should not be nil")
        XCTAssertNil(bankAccountResponse, "The bankCardResponse should be nil")
        XCTAssertEqual(errorResponse?.getHttpCode(), 400)
        XCTAssertEqual(errorResponse?.getHyperwalletErrors()?.errorList?.first?.fieldName, "branchId")
        XCTAssertEqual(errorResponse?.getHyperwalletErrors()?.errorList?.first?.code, "INVALID_FIELD_LENGTH")
    }

    func testDeactivateBankAccount_success() {
        // Given
        let expectation = self.expectation(description: "Deactivate bank account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "StatusTransitionMockedResponseSuccess")
        let url = String(format: "%@/bank-accounts/trm-12345/status-transitions", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostResquest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var statusTransitionResponse: HyperwalletStatusTransition?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.deactivateBankAccount(transferMethodToken: "trm-12345",
                                                 notes: "deactivate bank account",
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

    func testDeactivateBankAccount_invalidTransition() {
        // Given
        let expectation = self.expectation(description: "Deactivate bank account failed")
        let response = HyperwalletTestHelper
            .badRequestHTTPResponse(for: "StatusTransitionMockedResponseInvalidTransition")
        let url = String(format: "%@/bank-accounts/trm-12345/status-transitions", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostResquest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var statusTransitionResponse: HyperwalletStatusTransition?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.deactivateBankAccount(transferMethodToken: "trm-12345",
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

    func testListBankAccounts_success() {
        // Given
        let expectation = self.expectation(description: "List bank account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "ListBankAccountResponse")
        let url = String(format: "%@/bank-accounts?+", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequestRegexMatcher(pattern: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var bankAccountList: HyperwalletPageList<HyperwalletBankAccount>?
        var errorResponse: HyperwalletErrorType?

         // When
        let bankAccountPagination = HyperwalletBankAccountPagination()
        bankAccountPagination.status = .deActivated
        bankAccountPagination.type = .bankAccount
        bankAccountPagination.sortBy = .ascendantCreatedOn
        bankAccountPagination.createdAfter = HyperwalletBankAccountPagination.iso8601.date(from: "2018-12-15T00:30:11")
        bankAccountPagination.createdBefore = HyperwalletBankAccountPagination.iso8601.date(from: "2018-12-18T00:30:11")

        Hyperwallet.shared.listBankAccounts(pagination: bankAccountPagination) { (result, error) in
            bankAccountList = result
            errorResponse = error
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(bankAccountList, "The `bankAccountList` should not be nil")
        XCTAssertEqual(bankAccountList?.count, 204, "The `count` should be 204")
        XCTAssertNotNil(bankAccountList?.data, "The `data` should be not nil")

        XCTAssertNotNil(bankAccountList?.links, "The `links` should be not nil")
        let linkNext = bankAccountList?.links.first { $0.params.rel == "next" }
        XCTAssertNotNil(linkNext?.href)

        let bankAccount = bankAccountList?.data.first
        XCTAssertEqual(bankAccount?.getField(fieldName: .type) as? String, "BANK_ACCOUNT")
        XCTAssertEqual(bankAccount?.getField(fieldName: .token) as? String, "trm-12345")
        XCTAssertEqual(bankAccount?.getField(fieldName: .bankAccountId) as? String, "54629074")
        XCTAssertEqual(bankAccount?.getField(fieldName: .dateOfBirth) as? String, "1980-01-01")
    }

    func testListBankAccounts_emptyResult() {
        // Given
        let expectation = self.expectation(description: "List bank account completed")
        let response = HyperwalletTestHelper.noContentHTTPResponse()
        let url = String(format: "%@/bank-accounts?+", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequestRegexMatcher(pattern: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var bankAccountList: HyperwalletPageList<HyperwalletBankAccount>?
        var errorResponse: HyperwalletErrorType?
        let bankAccountPagination = HyperwalletBankAccountPagination()
        bankAccountPagination.status = .activated
        bankAccountPagination.type = .wireAccount

        // When
        Hyperwallet.shared.listBankAccounts(pagination: bankAccountPagination) { (result, error) in
            bankAccountList = result
            errorResponse = error
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNil(bankAccountList, "The `bankAccountList` should be nil")
    }
}
