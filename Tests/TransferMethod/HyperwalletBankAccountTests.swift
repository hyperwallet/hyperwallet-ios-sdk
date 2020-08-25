import Hippolyte
@testable import HyperwalletSDK
import XCTest

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
        XCTAssertEqual(bankAccountResponse?.bankAccountPurpose, "CHECKING")
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
        XCTAssertEqual(bankAccountResponse?.branchId, "026009593")
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
        let linkNext = bankAccountList?.links?.first { $0.params?.rel == "next" }
        XCTAssertNotNil(linkNext?.href)

        let bankAccount = bankAccountList?.data?.first
        XCTAssertEqual(bankAccount?.type, "BANK_ACCOUNT")
        XCTAssertEqual(bankAccount?.token, "trm-12345")
        XCTAssertEqual(bankAccount?.bankAccountId, "54629074")
        XCTAssertEqual(bankAccount?.dateOfBirth, "1980-01-01")
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
        HyperwalletBankAccount
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
        HyperwalletBankAccount
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
        HyperwalletBankAccount
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
        HyperwalletBankAccount
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
        XCTAssertEqual(bankAccountResponse?.profileType, "BUSINESS")
        XCTAssertEqual(bankAccountResponse?.bankAccountId, "7861012345")
        XCTAssertEqual(bankAccountResponse?.branchId, "102000021")

        verifyRelationship(.ownCompany, in: bankAccountResponse)
        verifyPurpose(.checking, in: bankAccountResponse)
        verifyBusinessType(.corporation, in: bankAccountResponse)

        XCTAssertEqual(bankAccountResponse?.businessName, "US BANK NA")
        XCTAssertEqual(bankAccountResponse?.phoneNumber, "604-345-1777")
        XCTAssertEqual(bankAccountResponse?.mobileNumber, "604-345-1888")
        XCTAssertEqual(bankAccountResponse?.country, "US")
        XCTAssertEqual(bankAccountResponse?.stateProvince, "WA")
        XCTAssertEqual(bankAccountResponse?.addressLine1, "1234, Broadway")
        XCTAssertEqual(bankAccountResponse?.addressLine2, "57 Market Street")
        XCTAssertEqual(bankAccountResponse?.city, "Test City")
        XCTAssertEqual(bankAccountResponse?.postalCode, "12345")
        XCTAssertEqual(bankAccountResponse?.profileType, "BUSINESS")
        XCTAssertEqual(bankAccountResponse?.type, "BANK_ACCOUNT")
    }

    func verifyIndividualResponse(_ bankAccountResponse: HyperwalletBankAccount?) {
        XCTAssertNotNil(bankAccountResponse?.getFields())
        XCTAssertEqual(bankAccountResponse?.bankAccountId, "675825206")
        XCTAssertEqual(bankAccountResponse?.branchId, "026009593")

        verifyRelationship(.self, in: bankAccountResponse)
        verifyPurpose(.checking, in: bankAccountResponse)
        verifyGender(.male, in: bankAccountResponse)
        verifyGovernmentIdType(.passport, in: bankAccountResponse)

        XCTAssertEqual(bankAccountResponse?.firstName, "Some")
        XCTAssertEqual(bankAccountResponse?.middleName, "Good")
        XCTAssertEqual(bankAccountResponse?.lastName, "Guy")
        XCTAssertEqual(bankAccountResponse?.phoneNumber, "604-345-1777")
        XCTAssertEqual(bankAccountResponse?.mobileNumber, "604-345-1888")
        XCTAssertEqual(bankAccountResponse?.dateOfBirth, "1991-01-01")
        XCTAssertEqual(bankAccountResponse?.addressLine1, "575 Market Street")
        XCTAssertEqual(bankAccountResponse?.addressLine2, "57 Market Street")
        XCTAssertEqual(bankAccountResponse?.city, "San Francisco")
        XCTAssertEqual(bankAccountResponse?.stateProvince, "CA")
        XCTAssertEqual(bankAccountResponse?.country, "US")
        XCTAssertEqual(bankAccountResponse?.postalCode, "94105")
        XCTAssertEqual(bankAccountResponse?.profileType, "INDIVIDUAL")
        XCTAssertEqual(bankAccountResponse?.type, "BANK_ACCOUNT")
        XCTAssertEqual(bankAccountResponse?.bankName, "ABC")
        XCTAssertEqual(bankAccountResponse?.branchName, "XYZ")
        XCTAssertEqual(bankAccountResponse?.countryOfBirth, "US")
        XCTAssertEqual(bankAccountResponse?.driversLicenseId, "1234")
        XCTAssertEqual(bankAccountResponse?.employerId, "1234")
        XCTAssertEqual(bankAccountResponse?.governmentId, "12898")
        XCTAssertEqual(bankAccountResponse?.passportId, "112323")
    }

    func verifyIndividualWireResponse(_ wireAccountResponse: HyperwalletBankAccount?) {
        XCTAssertNotNil(wireAccountResponse?.getFields())
        XCTAssertEqual(wireAccountResponse?.bankAccountId, "675825207")
        XCTAssertEqual(wireAccountResponse?.branchId, "026009593")

        verifyRelationship(.self, in: wireAccountResponse)
        verifyPurpose(.checking, in: wireAccountResponse)

        XCTAssertEqual(wireAccountResponse?.firstName, "Tommy")
        XCTAssertEqual(wireAccountResponse?.lastName, "Gray")
        XCTAssertEqual(wireAccountResponse?.phoneNumber, "604-345-1777")
        XCTAssertEqual(wireAccountResponse?.mobileNumber, "604-345-1888")
        XCTAssertEqual(wireAccountResponse?.dateOfBirth, "1991-01-01")
        XCTAssertEqual(wireAccountResponse?.addressLine1, "575 Market Street")
        XCTAssertEqual(wireAccountResponse?.addressLine2, "57 Market Street")
        XCTAssertEqual(wireAccountResponse?.city, "San Francisco")
        XCTAssertEqual(wireAccountResponse?.stateProvince, "CA")
        XCTAssertEqual(wireAccountResponse?.country, "US")
        XCTAssertEqual(wireAccountResponse?.postalCode, "94105")
        XCTAssertEqual(wireAccountResponse?.intermediaryBankAccountId, "246810")
        XCTAssertEqual(wireAccountResponse?.intermediaryBankAddressLine1,
                       "5 Market Street")
        XCTAssertEqual(wireAccountResponse?.intermediaryBankAddressLine2,
                       "75 Market Street")
        XCTAssertEqual(wireAccountResponse?.intermediaryBankCity, "New York")
        XCTAssertEqual(wireAccountResponse?.intermediaryBankCountry, "US")
        XCTAssertEqual(wireAccountResponse?.intermediaryBankId, "12345678901")
        XCTAssertEqual(wireAccountResponse?.intermediaryBankName,
                       "Intermediary Big Bank")
        XCTAssertEqual(wireAccountResponse?.intermediaryBankPostalCode, "134679")
        XCTAssertEqual(wireAccountResponse?.intermediaryBankStateProvince, "PA")
        XCTAssertEqual(wireAccountResponse?.wireInstructions, "This is instruction")
        XCTAssertEqual(wireAccountResponse?.profileType, "INDIVIDUAL")
        XCTAssertEqual(wireAccountResponse?.type, "WIRE_ACCOUNT")
    }

    func verifyBusinessWireResponse(_ bankAccountResponse: HyperwalletBankAccount?) {
        XCTAssertNotNil(bankAccountResponse?.getFields())
        XCTAssertEqual(bankAccountResponse?.transferMethodCountry, "US")
        XCTAssertEqual(bankAccountResponse?.transferMethodCurrency, "USD")
        XCTAssertEqual(bankAccountResponse?.profileType, "BUSINESS")
        XCTAssertEqual(bankAccountResponse?.bankAccountId, "675825208")
        XCTAssertEqual(bankAccountResponse?.branchId, "026009593")
        XCTAssertEqual(bankAccountResponse?.bankId, "13254687")
        XCTAssertEqual(bankAccountResponse?.branchId, "026009593")

        verifyRelationship(.ownCompany, in: bankAccountResponse)
        verifyPurpose(.checking, in: bankAccountResponse)
        verifyRole(.owner, in: bankAccountResponse)

        XCTAssertEqual(bankAccountResponse?.businessName, "Some company")
        XCTAssertEqual(bankAccountResponse?.businessRegistrationId, "123455511")
        XCTAssertEqual(bankAccountResponse?.businessRegistrationCountry, "CA")
        XCTAssertEqual(bankAccountResponse?.businessRegistrationStateProvince, "BC")
        XCTAssertEqual(bankAccountResponse?.phoneNumber, "604-345-1777")
        XCTAssertEqual(bankAccountResponse?.mobileNumber, "604-345-1888")
        XCTAssertEqual(bankAccountResponse?.country, "US")
        XCTAssertEqual(bankAccountResponse?.stateProvince, "WA")
        XCTAssertEqual(bankAccountResponse?.addressLine1, "1234, Broadway")
        XCTAssertEqual(bankAccountResponse?.addressLine2, "57 Market Street")
        XCTAssertEqual(bankAccountResponse?.city, "Test City")
        XCTAssertEqual(bankAccountResponse?.postalCode, "12345")
        XCTAssertEqual(bankAccountResponse?.intermediaryBankAccountId, "246810")
        XCTAssertEqual(bankAccountResponse?.intermediaryBankAddressLine1,
                       "5 Market Street")
        XCTAssertEqual(bankAccountResponse?.intermediaryBankAddressLine2,
                       "75 Market Street")
        XCTAssertEqual(bankAccountResponse?.intermediaryBankCity, "New York")
        XCTAssertEqual(bankAccountResponse?.intermediaryBankCountry, "US")
        XCTAssertEqual(bankAccountResponse?.intermediaryBankId, "12345678901")
        XCTAssertEqual(bankAccountResponse?.intermediaryBankName,
                       "Intermediary Big Bank")
        XCTAssertEqual(bankAccountResponse?.intermediaryBankPostalCode, "134679")
        XCTAssertEqual(bankAccountResponse?.intermediaryBankStateProvince, "PA")
        XCTAssertEqual(bankAccountResponse?.wireInstructions, "This is instruction")
        XCTAssertEqual(bankAccountResponse?.profileType, "BUSINESS")
        XCTAssertEqual(bankAccountResponse?.type, "WIRE_ACCOUNT")
        XCTAssertEqual(bankAccountResponse?.bankName, "Bank of America NA")
    }

    func verifyRelationship(_ relationship: HyperwalletBankAccount.RelationshipType,
                            in bankAccountResponse: HyperwalletBankAccount?) {
        XCTAssertEqual(bankAccountResponse?.bankAccountRelationship, relationship.rawValue)
    }

    func verifyPurpose(_ purpose: HyperwalletBankAccount.PurposeType,
                       in bankAccountResponse: HyperwalletBankAccount?) {
        XCTAssertEqual(bankAccountResponse?.bankAccountPurpose, purpose.rawValue)
    }

    func verifyRole(_ role: HyperwalletBankAccount.BusinessContactRole,
                    in bankAccountResponse: HyperwalletBankAccount?) {
        XCTAssertEqual(bankAccountResponse?.businessContactRole, role.rawValue)
    }

    func verifyBusinessType(_ type: HyperwalletBankAccount.BusinessType,
                            in bankAccountResponse: HyperwalletBankAccount?) {
        XCTAssertEqual(bankAccountResponse?.businessType, type.rawValue)
    }

    func verifyGender(_ gender: HyperwalletBankAccount.Gender,
                      in bankAccountResponse: HyperwalletBankAccount?) {
        XCTAssertEqual(bankAccountResponse?.gender, gender.rawValue)
    }

    func verifyGovernmentIdType(_ governmentIdType: HyperwalletBankAccount.GovernmentIdType,
                                in bankAccountResponse: HyperwalletBankAccount?) {
        XCTAssertEqual(bankAccountResponse?.governmentIdType, governmentIdType.rawValue)
    }
}
