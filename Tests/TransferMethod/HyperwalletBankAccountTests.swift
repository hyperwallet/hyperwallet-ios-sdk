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
        let bankAccount = buildIndividualBankAccount()

        Hyperwallet.shared.createBankAccount(account: bankAccount, completion: { (result, error) in
            bankAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(bankAccount)
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")

        verifyIndividualResponse(bankAccountResponse)
    }

    func testCreateBankAccount_business_success() {
        // Given
        let expectation = self.expectation(description: "Create bank account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "BankAccountBusinessResponse")
        let url = String(format: "%@/bank-accounts", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostResquest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var bankAccountResponse: HyperwalletBankAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let bankAccount = buildBusinessBankAccount()

        Hyperwallet.shared.createBankAccount(account: bankAccount, completion: { (result, error) in
            bankAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(bankAccount)
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")

        verifyBusinessResponse(bankAccountResponse)
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
        let bankAccountQueryParam = HyperwalletBankAccountQueryParam()
        bankAccountQueryParam.status = .deActivated
        bankAccountQueryParam.type = .bankAccount
        bankAccountQueryParam.sortBy = HyperwalletBankAccountQueryParam.QuerySortable.ascendantCreatedOn.rawValue
        bankAccountQueryParam.createdAfter = ISO8601DateFormatter.ignoreTimeZone.date(from: "2018-12-15T00:30:11")
        bankAccountQueryParam.createdBefore = ISO8601DateFormatter.ignoreTimeZone.date(from: "2018-12-18T00:30:11")

        Hyperwallet.shared.listBankAccounts(queryParam: bankAccountQueryParam) { (result, error) in
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
        let bankAccountQueryParam = HyperwalletBankAccountQueryParam()
        bankAccountQueryParam.status = .activated
        bankAccountQueryParam.type = .wireAccount

        // When
        Hyperwallet.shared.listBankAccounts(queryParam: bankAccountQueryParam) { (result, error) in
            bankAccountList = result
            errorResponse = error
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNil(bankAccountList, "The `bankAccountList` should be nil")
    }

    private func buildIndividualBankAccount() -> HyperwalletBankAccount {
        return HyperwalletBankAccount
            .Builder(transferMethodCountry: "US",
                     transferMethodCurrency: "USD",
                     transferMethodProfileType: "INDIVIDUAL")
            .bankAccountId("12345")
            .branchId("123456")
            .branchName("XYZ")
            .bankId("123")
            .bankName("ABC")
            .bankAccountRelationship(.self)
            .bankAccountPurpose(.checking)
            .intermediaryBankAccountId("123")
            .intermediaryBankId("12675")
            .passportId("112323")
            .firstName("Some")
            .middleName("Good")
            .lastName("Guy")
            .countryOfBirth("US")
            .gender(.male)
            .driversLicenseId("1234")
            .employerId("1234")
            .governmentId("12898")
            .governmentIdType(.passport)
            .phoneNumber("604-345-1777")
            .mobileNumber("604-345-1888")
            .dateOfBirth("1991-01-01")
            .addressLine1("575 Market Street")
            .city("San Francisco")
            .stateProvince("CA")
            .country("US")
            .postalCode("94105")
            .build()
    }

    func buildBusinessBankAccount() -> HyperwalletBankAccount {
        return HyperwalletBankAccount
            .Builder(transferMethodCountry: "US",
                     transferMethodCurrency: "USD",
                     transferMethodProfileType: "BUSINESS")
            .bankAccountId("7861012345")
            .branchId("102000021")
            .bankAccountRelationship(.ownCompany)
            .bankAccountPurpose(.checking)
            .businessContactRole(.owner)
            .businessRegistrationCountry("US")
            .businessRegistrationId("1234")
            .businessRegistrationStateProvince("WA")
            .businessType(.corporation)
            .businessName("US BANK NA")
            .phoneNumber("604-345-1777")
            .mobileNumber("604-345-1888")
            .country("US")
            .stateProvince("WA")
            .addressLine1("1234, Broadway")
            .city("Test City")
            .postalCode("12345")
            .build()
    }

    func verifyBusinessResponse(_ bankAccountResponse: HyperwalletBankAccount?) {
        XCTAssertNotNil(bankAccountResponse?.getFields())
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .transferMethodCountry) as! String, "US")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .transferMethodCurrency) as! String, "USD")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .profileType) as! String, "BUSINESS")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .bankAccountId) as! String, "7861012345")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .branchId) as! String, "102000021")

        let relationship = HyperwalletBankAccount.RelationshipType.ownCompany
        let responseRelationship = bankAccountResponse?.getField(fieldName: .bankAccountRelationship) as! String

        XCTAssertEqual(responseRelationship, relationship.rawValue)

        let purpose = HyperwalletBankAccount.PurposeType.checking
        let responsePurpose = bankAccountResponse?.getField(fieldName: .bankAccountPurpose) as! String

        XCTAssertEqual(responsePurpose, purpose.rawValue)

        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .businessName) as! String, "US BANK NA")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .phoneNumber) as! String, "604-345-1777")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .mobileNumber) as! String, "604-345-1888")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .country) as! String, "US")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .stateProvince) as! String, "WA")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .addressLine1) as! String, "1234, Broadway")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .city) as! String, "Test City")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .postalCode) as! String, "12345")
    }

    private func verifyIndividualResponse(_ bankAccountResponse: HyperwalletBankAccount?) {
        XCTAssertNotNil(bankAccountResponse?.getFields())
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .bankAccountId) as! String, "675825206")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .branchId) as! String, "026009593")

        let relationship: HyperwalletBankAccount.RelationshipType = .self
        let responseRelationship = bankAccountResponse?.getField(fieldName: .bankAccountRelationship) as! String

        XCTAssertEqual(responseRelationship, relationship.rawValue)

        let purpose = HyperwalletBankAccount.PurposeType.checking
        let responsePurpose = bankAccountResponse?.getField(fieldName: .bankAccountPurpose) as! String

        XCTAssertEqual(responsePurpose, purpose.rawValue)

        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .firstName) as! String, "Some")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .middleName) as! String, "Good")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .lastName) as! String, "Guy")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .phoneNumber) as! String, "604-345-1777")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .mobileNumber) as! String, "604-345-1888")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .dateOfBirth) as! String, "1991-01-01")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .addressLine1) as! String, "575 Market Street")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .city) as! String, "San Francisco")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .stateProvince) as! String, "CA")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .country) as! String, "US")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .postalCode) as! String, "94105")
    }
}
