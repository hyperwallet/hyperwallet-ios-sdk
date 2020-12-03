import Hippolyte
@testable import HyperwalletSDK
import XCTest

class HyperwalletPaperCheckTests: XCTestCase {
    override func setUp() {
        Hyperwallet.setup(HyperwalletTestHelper.authenticationProvider)
    }

    override func tearDown() {
        if Hippolyte.shared.isStarted {
            Hippolyte.shared.stop()
        }
    }

    func testCreatePaperCheck_individual_success() {
        // Given
        let expectation = self.expectation(description: "Create paper check completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "PaperCheckIndividualResponse")
        let url = String(format: "%@/paper-checks", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var paperCheckResponse: HyperwalletPaperCheck?
        var errorResponse: HyperwalletErrorType?

        // When
        let paperCheck = buildIndividualPaperCheck()

        Hyperwallet.shared.createPaperCheck(account: paperCheck, completion: { (result, error) in
            paperCheckResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(paperCheck)
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")

        verifyIndividualResponse(paperCheckResponse)
    }

    func testCreatePaperCheck_business_success() {
        // Given
        let expectation = self.expectation(description: "Create paper check completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "PaperCheckBusinessResponse")
        let url = String(format: "%@/paper-checks", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var paperCheckResponse: HyperwalletPaperCheck?
        var errorResponse: HyperwalletErrorType?

        // When
        let paperCheck = buildBusinessPaperCheck()

        Hyperwallet.shared.createPaperCheck(account: paperCheck, completion: { (result, error) in
            paperCheckResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(paperCheck)
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")

        verifyBusinessResponse(paperCheckResponse)
    }

    func testCreatePaperCheck_missingMandatoryField_returnBadRequest() {
        // Given
        let expectation = self.expectation(description: "Create paper check failed")
        let response =
            HyperwalletTestHelper.badRequestHTTPResponse(for: "PaperCheckErrorResponseWithMissingStateProvince")
        let url = String(format: "%@/paper-checks", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var paperCheckResponse: HyperwalletPaperCheck?
        var errorResponse: HyperwalletErrorType?

        // When
        let paperCheck = HyperwalletPaperCheck.Builder(transferMethodCountry: "US",
                                                       transferMethodCurrency: "USD",
                                                       transferMethodProfileType: "INDIVIDUAL",
                                                       transferMethodType: "PAPER_CHECK")
            .build()

        Hyperwallet.shared.createPaperCheck(account: paperCheck, completion: { (result, error) in
            paperCheckResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(errorResponse, "The `errorResponse` should not be nil")
        XCTAssertNil(paperCheckResponse)
        XCTAssertEqual(errorResponse?.getHttpCode(), 400)
        XCTAssertEqual(errorResponse?.getHyperwalletErrors()?.errorList?.first?.fieldName, "stateProvince")
    }

    func testGetPaperCheck_success() {
        // Given
        let expectation = self.expectation(description: "Get paper check completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "PaperCheckIndividualResponse")
        let url = String(format: "%@/paper-checks/trm-12345", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var paperCheckResponse: HyperwalletPaperCheck?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.getPaperCheck(transferMethodToken: "trm-12345", completion: { (result, error) in
            paperCheckResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(paperCheckResponse?.getFields())
        XCTAssertEqual(paperCheckResponse?.shippingMethod, "STANDARD")
    }

    func testUpdatePaperCheck_success() {
        // Given
        let expectation = self.expectation(description: "Update paper check completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "PaperCheckIndividualResponse")
        let url = String(format: "%@/paper-checks/trm-12345", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPutRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var paperCheckResponse: HyperwalletPaperCheck?
        var errorResponse: HyperwalletErrorType?

        // When
        let paperCheck = HyperwalletPaperCheck
            .Builder(token: "trm-12345")
            .shippingMethod("STANDARD")
            .build()

        Hyperwallet.shared.updatePaperCheck(account: paperCheck, completion: { (result, error) in
            paperCheckResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(paperCheckResponse?.getFields())
        XCTAssertEqual(paperCheckResponse?.shippingMethod, "STANDARD")
    }

    func testUpdatePaperCheck_invalidStateProvince() {
        // Given
        let expectation = self.expectation(description: "Update paper check failed")
        let response =
            HyperwalletTestHelper.badRequestHTTPResponse(for: "PaperCheckErrorResponseWithMissingStateProvince")
        let url = String(format: "%@/paper-checks/trm-12345", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPutRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var paperCheckResponse: HyperwalletPaperCheck?
        var errorResponse: HyperwalletErrorType?

        // When
        let paperCheck = HyperwalletPaperCheck
            .Builder(token: "trm-12345")
            .shippingMethod("STANDARD")
            .build()

        Hyperwallet.shared.updatePaperCheck(account: paperCheck, completion: { (result, error) in
            paperCheckResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(errorResponse, "The `errorResponse` should not be nil")
        XCTAssertNil(paperCheckResponse, "The paperCheckResponse should be nil")
        XCTAssertEqual(errorResponse?.getHttpCode(), 400)
        XCTAssertEqual(errorResponse?.getHyperwalletErrors()?.errorList?.first?.fieldName, "stateProvince")
    }

    func testDeactivatePaperCheck_success() {
        // Given
        let expectation = self.expectation(description: "Deactivate paper check completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "StatusTransitionMockedResponseSuccess")
        let url = String(format: "%@/paper-checks/trm-12345/status-transitions", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var statusTransitionResponse: HyperwalletStatusTransition?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.deactivatePaperCheck(transferMethodToken: "trm-12345",
                                                notes: "deactivate paper check",
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

    func testDeactivatePaperCheck_invalidTransition() {
        // Given
        let expectation = self.expectation(description: "Deactivate paper check failed")
        let response = HyperwalletTestHelper
            .badRequestHTTPResponse(for: "StatusTransitionMockedResponseInvalidTransition")
        let url = String(format: "%@/paper-checks/trm-12345/status-transitions", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var statusTransitionResponse: HyperwalletStatusTransition?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.deactivatePaperCheck(transferMethodToken: "trm-12345",
                                                notes: "deactivate paper check",
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

    func testListPaperChecks_success() {
        // Given
        let expectation = self.expectation(description: "List paper check completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "ListPaperCheckResponse")
        let url = String(format: "%@/paper-checks?+", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequestRegexMatcher(pattern: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var paperCheckList: HyperwalletPageList<HyperwalletPaperCheck>?
        var errorResponse: HyperwalletErrorType?

        // When
        let paperCheckQueryParam = HyperwalletPaperCheckQueryParam()
        paperCheckQueryParam.status = HyperwalletPaperCheckQueryParam.QueryStatus.deActivated.rawValue
        paperCheckQueryParam.type = HyperwalletPaperCheckQueryParam.QueryType.paperCheck.rawValue
        paperCheckQueryParam.sortBy =
            HyperwalletPaperCheckQueryParam.QuerySortable.ascendantCreatedOn.rawValue
        paperCheckQueryParam.createdAfter = ISO8601DateFormatter.ignoreTimeZone.date(from: "2018-12-15T00:30:11")
        paperCheckQueryParam.createdBefore =
            ISO8601DateFormatter.ignoreTimeZone.date(from: "2018-12-18T00:30:11")

        Hyperwallet.shared.listPaperChecks(queryParam: paperCheckQueryParam) { (result, error) in
            paperCheckList = result
            errorResponse = error
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(paperCheckList, "The `PaperCheckList` should not be nil")
        XCTAssertEqual(paperCheckList?.count, 204, "The `count` should be 204")
        XCTAssertNotNil(paperCheckList?.data, "The `data` should be not nil")

        XCTAssertNotNil(paperCheckList?.links, "The `links` should be not nil")
        let linkNext = paperCheckList?.links?.first { $0.params?.rel == "next" }
        XCTAssertNotNil(linkNext?.href)

        let paperCheck = paperCheckList?.data?.first
        XCTAssertEqual(paperCheck?.type, "PAPER_CHECK")
        XCTAssertEqual(paperCheck?.token, "trm-001")
        XCTAssertEqual(paperCheck?.dateOfBirth, "1991-01-01")
    }

    func testListPaperChecks_emptyResult() {
        // Given
        let expectation = self.expectation(description: "List paper check completed")
        let response = HyperwalletTestHelper.noContentHTTPResponse()
        let url = String(format: "%@/paper-checks?+", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequestRegexMatcher(pattern: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var paperCheckList: HyperwalletPageList<HyperwalletPaperCheck>?
        var errorResponse: HyperwalletErrorType?
        let paperCheckQueryParam = HyperwalletPaperCheckQueryParam()
        paperCheckQueryParam.status = HyperwalletPaperCheckQueryParam.QueryStatus.activated.rawValue
        paperCheckQueryParam.type = HyperwalletPaperCheckQueryParam.QueryType.wireAccount.rawValue

        // When
        Hyperwallet.shared.listPaperChecks(queryParam: paperCheckQueryParam) { (result, error) in
            paperCheckList = result
            errorResponse = error
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNil(paperCheckList, "The `PaperCheckList` should be nil")
    }
}

private extension HyperwalletPaperCheckTests {
    func buildIndividualPaperCheck() -> HyperwalletPaperCheck {
        HyperwalletPaperCheck
            .Builder(transferMethodCountry: "US",
                     transferMethodCurrency: "USD",
                     transferMethodProfileType: "INDIVIDUAL",
                     transferMethodType: "{PAPER_CHECK}")
            .bankAccountRelationship("SELF")
            .passportId("112323")
            .firstName("Some")
            .middleName("Good")
            .lastName("Guy")
            .countryOfBirth("US")
            .gender("MALE")
            .driversLicenseId("1234")
            .employerId("1234")
            .governmentId("12898")
            .governmentIdType("PASSPORT")
            .phoneNumber("604-345-1777")
            .mobileNumber("604-345-1888")
            .dateOfBirth("1991-01-01")
            .addressLine1("575 Market Street")
            .addressLine2("57 Market Street")
            .city("San Francisco")
            .stateProvince("CA")
            .country("US")
            .postalCode("94105")
            .shippingMethod("EXPEDITED")
            .build()
    }

    func buildBusinessPaperCheck() -> HyperwalletPaperCheck {
        HyperwalletPaperCheck
            .Builder(transferMethodCountry: "US",
                     transferMethodCurrency: "USD",
                     transferMethodProfileType: "BUSINESS",
                     transferMethodType: "PAPER_CHECK")
            .bankAccountRelationship("OWN_COMPANY")
            .businessContactRole("OWNER")
            .businessRegistrationCountry("US")
            .businessRegistrationId("1234")
            .businessRegistrationStateProvince("WA")
            .businessType("CORPORATION")
            .businessName("US BANK NA")
            .phoneNumber("604-345-1777")
            .mobileNumber("604-345-1888")
            .country("US")
            .stateProvince("WA")
            .addressLine1("1234, Broadway")
            .addressLine2("57 Market Street")
            .city("Test City")
            .postalCode("12345")
            .shippingMethod("EXPEDITED")
            .build()
    }
}

private extension HyperwalletPaperCheckTests {
    func verifyBusinessResponse(_ paperCheckResponse: HyperwalletPaperCheck?) {
        XCTAssertNotNil(paperCheckResponse?.getFields())
        XCTAssertEqual(paperCheckResponse?.transferMethodCountry, "US")
        XCTAssertEqual(paperCheckResponse?.transferMethodCurrency, "USD")
        XCTAssertEqual(paperCheckResponse?.profileType, "BUSINESS")
        XCTAssertEqual(paperCheckResponse?.bankAccountRelationship, "OWN_COMPANY")
        XCTAssertEqual(paperCheckResponse?.businessType, "CORPORATION")
        XCTAssertEqual(paperCheckResponse?.businessName, "US BANK NA")
        XCTAssertEqual(paperCheckResponse?.phoneNumber, "604-345-1777")
        XCTAssertEqual(paperCheckResponse?.mobileNumber, "604-345-1888")
        XCTAssertEqual(paperCheckResponse?.country, "US")
        XCTAssertEqual(paperCheckResponse?.stateProvince, "WA")
        XCTAssertEqual(paperCheckResponse?.addressLine1, "1234, Broadway")
        XCTAssertEqual(paperCheckResponse?.addressLine2, "57 Market Street")
        XCTAssertEqual(paperCheckResponse?.city, "Test City")
        XCTAssertEqual(paperCheckResponse?.postalCode, "12345")
        XCTAssertEqual(paperCheckResponse?.profileType, "BUSINESS")
        XCTAssertEqual(paperCheckResponse?.type, "PAPER_CHECK")
    }

    func verifyIndividualResponse(_ paperCheckResponse: HyperwalletPaperCheck?) {
        XCTAssertNotNil(paperCheckResponse?.getFields())
        XCTAssertEqual(paperCheckResponse?.bankAccountRelationship, "SELF")
        XCTAssertEqual(paperCheckResponse?.gender, "MALE")
        XCTAssertEqual(paperCheckResponse?.governmentIdType, "PASSPORT")
        XCTAssertEqual(paperCheckResponse?.firstName, "Some")
        XCTAssertEqual(paperCheckResponse?.middleName, "Good")
        XCTAssertEqual(paperCheckResponse?.lastName, "Guy")
        XCTAssertEqual(paperCheckResponse?.phoneNumber, "604-345-1777")
        XCTAssertEqual(paperCheckResponse?.mobileNumber, "604-345-1888")
        XCTAssertEqual(paperCheckResponse?.dateOfBirth, "1991-01-01")
        XCTAssertEqual(paperCheckResponse?.addressLine1, "575 Market Street")
        XCTAssertEqual(paperCheckResponse?.addressLine2, "57 Market Street")
        XCTAssertEqual(paperCheckResponse?.city, "San Francisco")
        XCTAssertEqual(paperCheckResponse?.stateProvince, "CA")
        XCTAssertEqual(paperCheckResponse?.country, "US")
        XCTAssertEqual(paperCheckResponse?.postalCode, "94105")
        XCTAssertEqual(paperCheckResponse?.profileType, "INDIVIDUAL")
        XCTAssertEqual(paperCheckResponse?.type, "PAPER_CHECK")
        XCTAssertEqual(paperCheckResponse?.countryOfBirth, "US")
        XCTAssertEqual(paperCheckResponse?.driversLicenseId, "1234")
        XCTAssertEqual(paperCheckResponse?.employerId, "1234")
        XCTAssertEqual(paperCheckResponse?.governmentId, "12898")
        XCTAssertEqual(paperCheckResponse?.passportId, "112323")
    }
}
