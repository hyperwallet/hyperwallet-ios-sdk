import Hippolyte
@testable import HyperwalletSDK
import XCTest

class HyperwalletPaperCheckAccountTests: XCTestCase {
    override func setUp() {
        Hyperwallet.setup(HyperwalletTestHelper.authenticationProvider)
    }

    override func tearDown() {
        if Hippolyte.shared.isStarted {
            Hippolyte.shared.stop()
        }
    }

    func testCreatePaperCheckAccount_individual_success() {
        // Given
        let expectation = self.expectation(description: "Create paper check account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "PaperCheckAccountIndividualResponse")
        let url = String(format: "%@/paper-checks", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var paperCheckAccountResponse: HyperwalletPaperCheckAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let paperCheckAccount = buildIndividualPaperCheckAccount()

        Hyperwallet.shared.createPaperCheckAccount(account: paperCheckAccount, completion: { (result, error) in
            paperCheckAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(paperCheckAccount)
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")

        verifyIndividualResponse(paperCheckAccountResponse)
    }

    func testCreatePaperCheckAccount_business_success() {
        // Given
        let expectation = self.expectation(description: "Create paper check account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "PaperCheckAccountBusinessResponse")
        let url = String(format: "%@/paper-checks", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var paperCheckAccountResponse: HyperwalletPaperCheckAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let paperCheckAccount = buildBusinessPaperCheckAccount()

        Hyperwallet.shared.createPaperCheckAccount(account: paperCheckAccount, completion: { (result, error) in
            paperCheckAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(paperCheckAccount)
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")

        verifyBusinessResponse(paperCheckAccountResponse)
    }

    func testCreatePaperCheckAccount_missingMandatoryField_returnBadRequest() {
        // Given
        let expectation = self.expectation(description: "Create paper check account failed")
        let response =
            HyperwalletTestHelper.badRequestHTTPResponse(for: "PaperCheckAccountErrorResponseWithMissingStateProvince")
        let url = String(format: "%@/paper-checks", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var paperCheckAccountResponse: HyperwalletPaperCheckAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let paperCheckAccount = HyperwalletPaperCheckAccount.Builder(transferMethodCountry: "US",
                                                                     transferMethodCurrency: "USD",
                                                                     transferMethodProfileType: "INDIVIDUAL",
                                                                     transferMethodType: "PAPER_CHECK")
            .build()

        Hyperwallet.shared.createPaperCheckAccount(account: paperCheckAccount, completion: { (result, error) in
            paperCheckAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(errorResponse, "The `errorResponse` should not be nil")
        XCTAssertNil(paperCheckAccountResponse)
        XCTAssertEqual(errorResponse?.getHttpCode(), 400)
        XCTAssertEqual(errorResponse?.getHyperwalletErrors()?.errorList?.first?.fieldName, "stateProvince")
    }

    func testGetPaperCheckAccount_success() {
        // Given
        let expectation = self.expectation(description: "Get paper check account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "PaperCheckAccountIndividualResponse")
        let url = String(format: "%@/paper-checks/trm-12345", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var paperCheckAccountResponse: HyperwalletPaperCheckAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.getPaperCheckAccount(transferMethodToken: "trm-12345", completion: { (result, error) in
            paperCheckAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(paperCheckAccountResponse?.getFields())
        XCTAssertEqual(paperCheckAccountResponse?.shippingMethod, "STANDARD")
    }

    func testUpdatePaperCheckAccount_success() {
        // Given
        let expectation = self.expectation(description: "Update paper check account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "PaperCheckAccountIndividualResponse")
        let url = String(format: "%@/paper-checks/trm-12345", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPutRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var paperCheckAccountResponse: HyperwalletPaperCheckAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let paperCheckAccount = HyperwalletPaperCheckAccount
            .Builder(token: "trm-12345")
            .shippingMethod(.standard)
            .build()

        Hyperwallet.shared.updatePaperCheckAccount(account: paperCheckAccount, completion: { (result, error) in
            paperCheckAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(paperCheckAccountResponse?.getFields())
        XCTAssertEqual(paperCheckAccountResponse?.shippingMethod, "STANDARD")
    }

    func testUpdatePaperCheckAccount_invalidStateProvince() {
        // Given
        let expectation = self.expectation(description: "Update paper check account failed")
        let response =
            HyperwalletTestHelper.badRequestHTTPResponse(for: "PaperCheckAccountErrorResponseWithMissingStateProvince")
        let url = String(format: "%@/paper-checks/trm-12345", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPutRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var paperCheckAccountResponse: HyperwalletPaperCheckAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let paperCheckAccount = HyperwalletPaperCheckAccount
            .Builder(token: "trm-12345")
            .shippingMethod(.standard)
            .build()

        Hyperwallet.shared.updatePaperCheckAccount(account: paperCheckAccount, completion: { (result, error) in
            paperCheckAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(errorResponse, "The `errorResponse` should not be nil")
        XCTAssertNil(paperCheckAccountResponse, "The paperCheckAccountResponse should be nil")
        XCTAssertEqual(errorResponse?.getHttpCode(), 400)
        XCTAssertEqual(errorResponse?.getHyperwalletErrors()?.errorList?.first?.fieldName, "stateProvince")
    }

    func testDeactivatePaperCheckAccount_success() {
        // Given
        let expectation = self.expectation(description: "Deactivate paper check account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "StatusTransitionMockedResponseSuccess")
        let url = String(format: "%@/paper-checks/trm-12345/status-transitions", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var statusTransitionResponse: HyperwalletStatusTransition?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.deactivatePaperCheckAccount(transferMethodToken: "trm-12345",
                                                       notes: "deactivate paper check account",
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

    func testDeactivatePaperCheckAccount_invalidTransition() {
        // Given
        let expectation = self.expectation(description: "Deactivate paper check account failed")
        let response = HyperwalletTestHelper
            .badRequestHTTPResponse(for: "StatusTransitionMockedResponseInvalidTransition")
        let url = String(format: "%@/paper-checks/trm-12345/status-transitions", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var statusTransitionResponse: HyperwalletStatusTransition?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.deactivatePaperCheckAccount(transferMethodToken: "trm-12345",
                                                       notes: "deactivate paper check account",
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

    func testListPaperCheckAccounts_success() {
        // Given
        let expectation = self.expectation(description: "List paper check account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "ListPaperCheckAccountResponse")
        let url = String(format: "%@/paper-checks?+", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequestRegexMatcher(pattern: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var paperCheckAccountList: HyperwalletPageList<HyperwalletPaperCheckAccount>?
        var errorResponse: HyperwalletErrorType?

        // When
        let paperCheckAccountQueryParam = HyperwalletPaperCheckAccountQueryParam()
        paperCheckAccountQueryParam.status = HyperwalletPaperCheckAccountQueryParam.QueryStatus.deActivated.rawValue
        paperCheckAccountQueryParam.type = HyperwalletPaperCheckAccountQueryParam.QueryType.paperCheckAccount.rawValue
        paperCheckAccountQueryParam.sortBy =
            HyperwalletPaperCheckAccountQueryParam.QuerySortable.ascendantCreatedOn.rawValue
        paperCheckAccountQueryParam.createdAfter = ISO8601DateFormatter.ignoreTimeZone.date(from: "2018-12-15T00:30:11")
        paperCheckAccountQueryParam.createdBefore =
            ISO8601DateFormatter.ignoreTimeZone.date(from: "2018-12-18T00:30:11")

        Hyperwallet.shared.listPaperCheckAccounts(queryParam: paperCheckAccountQueryParam) { (result, error) in
            paperCheckAccountList = result
            errorResponse = error
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(paperCheckAccountList, "The `PaperCheckAccountList` should not be nil")
        XCTAssertEqual(paperCheckAccountList?.count, 204, "The `count` should be 204")
        XCTAssertNotNil(paperCheckAccountList?.data, "The `data` should be not nil")

        XCTAssertNotNil(paperCheckAccountList?.links, "The `links` should be not nil")
        let linkNext = paperCheckAccountList?.links?.first { $0.params?.rel == "next" }
        XCTAssertNotNil(linkNext?.href)

        let paperCheckAccount = paperCheckAccountList?.data?.first
        XCTAssertEqual(paperCheckAccount?.type, "PAPER_CHECK")
        XCTAssertEqual(paperCheckAccount?.token, "trm-001")
        XCTAssertEqual(paperCheckAccount?.dateOfBirth, "1991-01-01")
    }

    func testListPaperCheckAccounts_emptyResult() {
        // Given
        let expectation = self.expectation(description: "List paper check account completed")
        let response = HyperwalletTestHelper.noContentHTTPResponse()
        let url = String(format: "%@/paper-checks?+", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequestRegexMatcher(pattern: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var paperCheckAccountList: HyperwalletPageList<HyperwalletPaperCheckAccount>?
        var errorResponse: HyperwalletErrorType?
        let paperCheckAccountQueryParam = HyperwalletPaperCheckAccountQueryParam()
        paperCheckAccountQueryParam.status = HyperwalletPaperCheckAccountQueryParam.QueryStatus.activated.rawValue
        paperCheckAccountQueryParam.type = HyperwalletPaperCheckAccountQueryParam.QueryType.wireAccount.rawValue

        // When
        Hyperwallet.shared.listPaperCheckAccounts(queryParam: paperCheckAccountQueryParam) { (result, error) in
            paperCheckAccountList = result
            errorResponse = error
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNil(paperCheckAccountList, "The `PaperCheckAccountList` should be nil")
    }
}

private extension HyperwalletPaperCheckAccountTests {
    func buildIndividualPaperCheckAccount() -> HyperwalletPaperCheckAccount {
        HyperwalletPaperCheckAccount
            .Builder(transferMethodCountry: "US",
                     transferMethodCurrency: "USD",
                     transferMethodProfileType: "INDIVIDUAL",
                     transferMethodType: "{PAPER_CHECK}")
            .bankAccountRelationship(.self)
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
            .shippingMethod(.expedited)
            .build()
    }

    func buildBusinessPaperCheckAccount() -> HyperwalletPaperCheckAccount {
        HyperwalletPaperCheckAccount
            .Builder(transferMethodCountry: "US",
                     transferMethodCurrency: "USD",
                     transferMethodProfileType: "BUSINESS",
                     transferMethodType: "PAPER_CHECK")
            .bankAccountRelationship(.ownCompany)
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
            .shippingMethod(.expedited)
            .build()
    }
}

private extension HyperwalletPaperCheckAccountTests {
    func verifyBusinessResponse(_ paperCheckAccountResponse: HyperwalletPaperCheckAccount?) {
        XCTAssertNotNil(paperCheckAccountResponse?.getFields())
        XCTAssertEqual(paperCheckAccountResponse?.transferMethodCountry, "US")
        XCTAssertEqual(paperCheckAccountResponse?.transferMethodCurrency, "USD")
        XCTAssertEqual(paperCheckAccountResponse?.profileType, "BUSINESS")

        verifyRelationship(.ownCompany, in: paperCheckAccountResponse)
        verifyBusinessType(.corporation, in: paperCheckAccountResponse)

        XCTAssertEqual(paperCheckAccountResponse?.businessName, "US BANK NA")
        XCTAssertEqual(paperCheckAccountResponse?.phoneNumber, "604-345-1777")
        XCTAssertEqual(paperCheckAccountResponse?.mobileNumber, "604-345-1888")
        XCTAssertEqual(paperCheckAccountResponse?.country, "US")
        XCTAssertEqual(paperCheckAccountResponse?.stateProvince, "WA")
        XCTAssertEqual(paperCheckAccountResponse?.addressLine1, "1234, Broadway")
        XCTAssertEqual(paperCheckAccountResponse?.addressLine2, "57 Market Street")
        XCTAssertEqual(paperCheckAccountResponse?.city, "Test City")
        XCTAssertEqual(paperCheckAccountResponse?.postalCode, "12345")
        XCTAssertEqual(paperCheckAccountResponse?.profileType, "BUSINESS")
        XCTAssertEqual(paperCheckAccountResponse?.type, "PAPER_CHECK")
    }

    func verifyIndividualResponse(_ paperCheckAccountResponse: HyperwalletPaperCheckAccount?) {
        XCTAssertNotNil(paperCheckAccountResponse?.getFields())

        verifyRelationship(.self, in: paperCheckAccountResponse)
        verifyGender(.male, in: paperCheckAccountResponse)
        verifyGovernmentIdType(.passport, in: paperCheckAccountResponse)

        XCTAssertEqual(paperCheckAccountResponse?.firstName, "Some")
        XCTAssertEqual(paperCheckAccountResponse?.middleName, "Good")
        XCTAssertEqual(paperCheckAccountResponse?.lastName, "Guy")
        XCTAssertEqual(paperCheckAccountResponse?.phoneNumber, "604-345-1777")
        XCTAssertEqual(paperCheckAccountResponse?.mobileNumber, "604-345-1888")
        XCTAssertEqual(paperCheckAccountResponse?.dateOfBirth, "1991-01-01")
        XCTAssertEqual(paperCheckAccountResponse?.addressLine1, "575 Market Street")
        XCTAssertEqual(paperCheckAccountResponse?.addressLine2, "57 Market Street")
        XCTAssertEqual(paperCheckAccountResponse?.city, "San Francisco")
        XCTAssertEqual(paperCheckAccountResponse?.stateProvince, "CA")
        XCTAssertEqual(paperCheckAccountResponse?.country, "US")
        XCTAssertEqual(paperCheckAccountResponse?.postalCode, "94105")
        XCTAssertEqual(paperCheckAccountResponse?.profileType, "INDIVIDUAL")
        XCTAssertEqual(paperCheckAccountResponse?.type, "PAPER_CHECK")
        XCTAssertEqual(paperCheckAccountResponse?.countryOfBirth, "US")
        XCTAssertEqual(paperCheckAccountResponse?.driversLicenseId, "1234")
        XCTAssertEqual(paperCheckAccountResponse?.employerId, "1234")
        XCTAssertEqual(paperCheckAccountResponse?.governmentId, "12898")
        XCTAssertEqual(paperCheckAccountResponse?.passportId, "112323")
    }

    func verifyRelationship(_ relationship: HyperwalletPaperCheckAccount.RelationshipType,
                            in paperCheckAccountResponse: HyperwalletPaperCheckAccount?) {
        XCTAssertEqual(paperCheckAccountResponse?.bankAccountRelationship, relationship.rawValue)
    }

    func verifyBusinessType(_ type: HyperwalletPaperCheckAccount.BusinessType,
                            in paperCheckAccountResponse: HyperwalletPaperCheckAccount?) {
        XCTAssertEqual(paperCheckAccountResponse?.businessType, type.rawValue)
    }

    func verifyGender(_ gender: HyperwalletPaperCheckAccount.Gender,
                      in paperCheckAccountResponse: HyperwalletPaperCheckAccount?) {
        XCTAssertEqual(paperCheckAccountResponse?.gender, gender.rawValue)
    }

    func verifyGovernmentIdType(_ governmentIdType: HyperwalletPaperCheckAccount.GovernmentIdType,
                                in paperCheckAccountResponse: HyperwalletPaperCheckAccount?) {
        XCTAssertEqual(paperCheckAccountResponse?.governmentIdType, governmentIdType.rawValue)
    }
}
