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
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
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

    func testCreateWireAccount_individual_success() {
        // Given
        let expectation = self.expectation(description: "Create wire account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "WireAccountIndividualResponse")
        let url = String(format: "%@/bank-accounts", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var wireAccountResponse: HyperwalletBankAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let wireAccount = buildIndividualWireAccount()

        Hyperwallet.shared.createBankAccount(account: wireAccount, completion: { (result, error) in
            wireAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(wireAccountResponse)
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")

        verifyIndividualWireResponse(wireAccountResponse)
    }

    func testCreateBankAccount_business_success() {
        // Given
        let expectation = self.expectation(description: "Create bank account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "BankAccountBusinessResponse")
        let url = String(format: "%@/bank-accounts", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
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

    func testCreateWireAccount_business_success() {
        // Given
        let expectation = self.expectation(description: "Create wire account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "WireAccountBusinessResponse")
        let url = String(format: "%@/bank-accounts", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var wireAccountResponse: HyperwalletBankAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let wireAccount = buildBusinessWireAccount()

        Hyperwallet.shared.createBankAccount(account: wireAccount, completion: { (result, error) in
            wireAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(wireAccountResponse)
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")

        verifyBusinessWireResponse(wireAccountResponse)
    }

    func testCreateBankAccount_missingMandatoryField_returnBadRequest() {
        // Given
        let expectation = self.expectation(description: "Create bank account failed")
        let response = HyperwalletTestHelper.badRequestHTTPResponse(for: "BankAccountErrorResponseWithMissingBankId")
        let url = String(format: "%@/bank-accounts", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var bankAccountResponse: HyperwalletBankAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let bankAccount = HyperwalletBankAccount.Builder(transferMethodCountry: "US",
                                                         transferMethodCurrency: "USD",
                                                         transferMethodProfileType: "INDIVIDUAL",
                                                         transferMethodType: "BANK_ACCOUNT")
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
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
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
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
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
        XCTAssertEqual(bankAccount?.type, "BANK_ACCOUNT")
        XCTAssertEqual(bankAccount?.token, "trm-12345")
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
}

private extension HyperwalletBankAccountIndividualTests {
    func buildIndividualBankAccount() -> HyperwalletBankAccount {
        return HyperwalletBankAccount
            .Builder(transferMethodCountry: "US",
                     transferMethodCurrency: "USD",
                     transferMethodProfileType: "INDIVIDUAL",
                     transferMethodType: "BANK_ACCOUNT")
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
            .addressLine2("57 Market Street")
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
                     transferMethodProfileType: "BUSINESS",
                     transferMethodType: "BANK_ACCOUNT")
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
            .addressLine2("57 Market Street")
            .city("Test City")
            .postalCode("12345")
            .build()
    }

    func buildIndividualWireAccount() -> HyperwalletBankAccount {
        return HyperwalletBankAccount
            .Builder(transferMethodCountry: "US",
                     transferMethodCurrency: "USD",
                     transferMethodProfileType: "INDIVIDUAL",
                     transferMethodType: "WIRE_ACCOUNT")
            .bankAccountId("675825207")
            .branchId("026009593")
            .bankAccountRelationship(.self)
            .bankAccountPurpose(.checking)
            .firstName("Tommy")
            .lastName("Gray")
            .phoneNumber("604-345-1777")
            .mobileNumber("604-345-1888")
            .dateOfBirth("1991-01-01")
            .addressLine1("575 Market Street")
            .addressLine2("57 Market Street")
            .city("San Francisco")
            .stateProvince("CA")
            .country("US")
            .postalCode("94105")
            .intermediaryBankAccountId("246810")
            .intermediaryBankAddressLine1("5 Market Street")
            .intermediaryBankAddressLine2("75 Market Street")
            .intermediaryBankCity("New York")
            .intermediaryBankCountry("US")
            .intermediaryBankId("12345678901")
            .intermediaryBankName("Intermediary Big Bank")
            .intermediaryBankPostalCode("134679")
            .intermediaryBankStateProvince("PA")
            .wireInstructions("This is instruction")
            .build()
    }

    func buildBusinessWireAccount() -> HyperwalletBankAccount {
        return HyperwalletBankAccount
            .Builder(transferMethodCountry: "US",
                     transferMethodCurrency: "USD",
                     transferMethodProfileType: "BUSINESS",
                     transferMethodType: "WIRE_ACCOUNT")
            .bankId("13254687")
            .bankName("US BANK NA")
            .branchId("026009593")
            .bankAccountId("675825208")
            .bankAccountRelationship(.ownCompany)
            .bankAccountPurpose(.checking)
            .businessName("Some company")
            .businessRegistrationId("123455511")
            .businessRegistrationStateProvince("BC")
            .businessRegistrationCountry("CA")
            .businessContactRole(.owner)
            .phoneNumber("604-345-1777")
            .mobileNumber("604-345-1888")
            .country("US")
            .stateProvince("WA")
            .addressLine1("1234, Broadway")
            .addressLine2("57 Market Street")
            .city("Test City")
            .postalCode("12345")
            .intermediaryBankAccountId("246810")
            .intermediaryBankAddressLine1("5 Market Street")
            .intermediaryBankAddressLine2("75 Market Street")
            .intermediaryBankCity("New York")
            .intermediaryBankCountry("US")
            .intermediaryBankId("12345678901")
            .intermediaryBankName("Intermediary Big Bank")
            .intermediaryBankPostalCode("134679")
            .intermediaryBankStateProvince("PA")
            .wireInstructions("This is instruction")
            .build()
    }
}

private extension HyperwalletBankAccountIndividualTests {
    func verifyBusinessResponse(_ bankAccountResponse: HyperwalletBankAccount?) {
        XCTAssertNotNil(bankAccountResponse?.getFields())
        XCTAssertEqual(bankAccountResponse?.transferMethodCountry, "US")
        XCTAssertEqual(bankAccountResponse?.transferMethodCurrency, "USD")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .profileType) as! String, "BUSINESS")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .bankAccountId) as! String, "7861012345")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .branchId) as! String, "102000021")

        verifyRelationship(.ownCompany, in: bankAccountResponse)
        verifyPurpose(.checking, in: bankAccountResponse)

        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .businessName) as! String, "US BANK NA")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .phoneNumber) as! String, "604-345-1777")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .mobileNumber) as! String, "604-345-1888")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .country) as! String, "US")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .stateProvince) as! String, "WA")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .addressLine1) as! String, "1234, Broadway")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .addressLine2) as! String, "57 Market Street")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .city) as! String, "Test City")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .postalCode) as! String, "12345")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .profileType) as! String, "BUSINESS")
        XCTAssertEqual(bankAccountResponse?.type, "BANK_ACCOUNT")
    }

    func verifyIndividualResponse(_ bankAccountResponse: HyperwalletBankAccount?) {
        XCTAssertNotNil(bankAccountResponse?.getFields())
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .bankAccountId) as! String, "675825206")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .branchId) as! String, "026009593")

        verifyRelationship(.self, in: bankAccountResponse)
        verifyPurpose(.checking, in: bankAccountResponse)

        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .firstName) as! String, "Some")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .middleName) as! String, "Good")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .lastName) as! String, "Guy")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .phoneNumber) as! String, "604-345-1777")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .mobileNumber) as! String, "604-345-1888")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .dateOfBirth) as! String, "1991-01-01")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .addressLine1) as! String, "575 Market Street")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .addressLine2) as! String, "57 Market Street")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .city) as! String, "San Francisco")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .stateProvince) as! String, "CA")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .country) as! String, "US")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .postalCode) as! String, "94105")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .profileType) as! String, "INDIVIDUAL")
        XCTAssertEqual(bankAccountResponse?.type, "BANK_ACCOUNT")
    }

    func verifyIndividualWireResponse(_ wireAccountResponse: HyperwalletBankAccount?) {
        XCTAssertNotNil(wireAccountResponse?.getFields())
        XCTAssertEqual(wireAccountResponse?.getField(fieldName: .bankAccountId) as! String, "675825207")
        XCTAssertEqual(wireAccountResponse?.getField(fieldName: .branchId) as! String, "026009593")

        verifyRelationship(.self, in: wireAccountResponse)
        verifyPurpose(.checking, in: wireAccountResponse)

        XCTAssertEqual(wireAccountResponse?.getField(fieldName: .firstName) as! String, "Tommy")
        XCTAssertEqual(wireAccountResponse?.getField(fieldName: .lastName) as! String, "Gray")
        XCTAssertEqual(wireAccountResponse?.getField(fieldName: .phoneNumber) as! String, "604-345-1777")
        XCTAssertEqual(wireAccountResponse?.getField(fieldName: .mobileNumber) as! String, "604-345-1888")
        XCTAssertEqual(wireAccountResponse?.getField(fieldName: .dateOfBirth) as! String, "1991-01-01")
        XCTAssertEqual(wireAccountResponse?.getField(fieldName: .addressLine1) as! String, "575 Market Street")
        XCTAssertEqual(wireAccountResponse?.getField(fieldName: .addressLine2) as! String, "57 Market Street")
        XCTAssertEqual(wireAccountResponse?.getField(fieldName: .city) as! String, "San Francisco")
        XCTAssertEqual(wireAccountResponse?.getField(fieldName: .stateProvince) as! String, "CA")
        XCTAssertEqual(wireAccountResponse?.getField(fieldName: .country) as! String, "US")
        XCTAssertEqual(wireAccountResponse?.getField(fieldName: .postalCode) as! String, "94105")
        XCTAssertEqual(wireAccountResponse?.getField(fieldName: .intermediaryBankAccountId) as! String, "246810")
        XCTAssertEqual(wireAccountResponse?.getField(fieldName: .intermediaryBankAddressLine1) as! String,
                       "5 Market Street")
        XCTAssertEqual(wireAccountResponse?.getField(fieldName: .intermediaryBankAddressLine2) as! String,
                       "75 Market Street")
        XCTAssertEqual(wireAccountResponse?.getField(fieldName: .intermediaryBankCity) as! String, "New York")
        XCTAssertEqual(wireAccountResponse?.getField(fieldName: .intermediaryBankCountry) as! String, "US")
        XCTAssertEqual(wireAccountResponse?.getField(fieldName: .intermediaryBankId) as! String, "12345678901")
        XCTAssertEqual(wireAccountResponse?.getField(fieldName: .intermediaryBankName) as! String,
                       "Intermediary Big Bank")
        XCTAssertEqual(wireAccountResponse?.getField(fieldName: .intermediaryBankPostalCode) as! String, "134679")
        XCTAssertEqual(wireAccountResponse?.getField(fieldName: .intermediaryBankStateProvince) as! String, "PA")
        XCTAssertEqual(wireAccountResponse?.getField(fieldName: .wireInstructions) as! String, "This is instruction")
        XCTAssertEqual(wireAccountResponse?.getField(fieldName: .profileType) as! String, "INDIVIDUAL")
        XCTAssertEqual(wireAccountResponse?.type, "WIRE_ACCOUNT")
    }

    func verifyBusinessWireResponse(_ bankAccountResponse: HyperwalletBankAccount?) {
        XCTAssertNotNil(bankAccountResponse?.getFields())
        XCTAssertEqual(bankAccountResponse?.transferMethodCountry, "US")
        XCTAssertEqual(bankAccountResponse?.transferMethodCurrency, "USD")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .profileType) as! String, "BUSINESS")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .bankAccountId) as! String, "675825208")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .branchId) as! String, "026009593")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .bankId) as! String, "13254687")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .branchId) as! String, "026009593")

        verifyRelationship(.ownCompany, in: bankAccountResponse)
        verifyPurpose(.checking, in: bankAccountResponse)
        verifyRole(.owner, in: bankAccountResponse)

        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .businessName) as! String, "Some company")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .businessRegistrationId) as! String, "123455511")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .businessRegistrationCountry) as! String, "CA")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .businessRegistrationStateProvince) as! String, "BC")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .phoneNumber) as! String, "604-345-1777")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .mobileNumber) as! String, "604-345-1888")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .country) as! String, "US")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .stateProvince) as! String, "WA")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .addressLine1) as! String, "1234, Broadway")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .addressLine2) as! String, "57 Market Street")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .city) as! String, "Test City")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .postalCode) as! String, "12345")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .intermediaryBankAccountId) as! String, "246810")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .intermediaryBankAddressLine1) as! String,
                       "5 Market Street")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .intermediaryBankAddressLine2) as! String,
                       "75 Market Street")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .intermediaryBankCity) as! String, "New York")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .intermediaryBankCountry) as! String, "US")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .intermediaryBankId) as! String, "12345678901")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .intermediaryBankName) as! String,
                       "Intermediary Big Bank")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .intermediaryBankPostalCode) as! String, "134679")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .intermediaryBankStateProvince) as! String, "PA")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .wireInstructions) as! String, "This is instruction")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .profileType) as! String, "BUSINESS")
        XCTAssertEqual(bankAccountResponse?.type, "WIRE_ACCOUNT")
    }

    func verifyRelationship(_ relationship: HyperwalletBankAccount.RelationshipType,
                            in bankAccountResponse: HyperwalletBankAccount?) {
        let responseRelationship = bankAccountResponse?.getField(fieldName: .bankAccountRelationship) as! String
        XCTAssertEqual(responseRelationship, relationship.rawValue)
    }

    func verifyPurpose(_ purpose: HyperwalletBankAccount.PurposeType,
                       in bankAccountResponse: HyperwalletBankAccount?) {
        let responsePurpose = bankAccountResponse?.getField(fieldName: .bankAccountPurpose) as! String
        XCTAssertEqual(responsePurpose, purpose.rawValue)
    }

    func verifyRole(_ role: HyperwalletBankAccount.BusinessContactRole,
                    in bankAccountResponse: HyperwalletBankAccount?) {
        let responseRole = bankAccountResponse?.getField(fieldName: .businessContactRole) as! String
        XCTAssertEqual(responseRole, role.rawValue)
    }
}
