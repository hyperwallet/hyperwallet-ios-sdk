import Hippolyte
@testable import HyperwalletSDK
import XCTest

class HyperwalletUserTests: XCTestCase {
    override func setUp() {
        Hyperwallet.setup(HyperwalletTestHelper.authenticationProvider)
    }

    override func tearDown() {
        if Hippolyte.shared.isStarted {
            Hippolyte.shared.stop()
        }
    }

    // swiftlint:disable function_body_length
    func testGetUser_individualSuccess() {
        // Given
        let expectation = self.expectation(description: "Get HyperwalletUser completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "UserIndividualResponse")
        let request = HyperwalletTestHelper.buildGetRequest(baseUrl: HyperwalletTestHelper.userRestURL, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var user: HyperwalletUser?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.getUser { (result, error) in
            user = result
            errorResponse = error
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(user)

        XCTAssertEqual(user!.clientUserId!, "myAppUserId01")
        XCTAssertEqual(user!.token!, "YourUserToken")
        XCTAssertEqual(user!.status!, HyperwalletUser.Status.activated)
        XCTAssertEqual(user!.verificationStatus!, HyperwalletUser.VerificationStatus.notRequired)
        XCTAssertEqual(user!.profileType!, HyperwalletUser.ProfileType.individual)
        XCTAssertEqual(user!.gender!, HyperwalletUser.Gender.male)
        XCTAssertEqual(user!.employerId!, "001")
        XCTAssertNil(user?.countryOfNationality)

        XCTAssertEqual(user!.firstName!, "Stan")
        XCTAssertEqual(user!.middleName!, "Albert")
        XCTAssertEqual(user!.lastName!, "Fung")
        XCTAssertEqual(user!.dateOfBirth!, "1980-01-01")
        XCTAssertEqual(user!.countryOfBirth!, "US")
        XCTAssertEqual(user!.driversLicenseId!, "000123")
        XCTAssertEqual(user!.governmentIdType!, "PASSPORT")
        XCTAssertEqual(user!.passportId!, "00000")

        XCTAssertEqual(user!.createdOn!, "2019-04-30T00:01:53")
        XCTAssertEqual(user!.phoneNumber!, "000-000000")
        XCTAssertEqual(user!.mobileNumber!, "000-000-0000")
        XCTAssertEqual(user!.email!, "user01@myApp.com")
        XCTAssertEqual(user!.governmentId!, "0000000000")

        XCTAssertEqual(user!.addressLine1!, "abc")
        XCTAssertEqual(user!.addressLine2!, "def")
        XCTAssertEqual(user!.city!, "Phoenix")
        XCTAssertEqual(user!.stateProvince!, "AZ")

        XCTAssertEqual(user!.country!, "US")
        XCTAssertEqual(user!.postalCode!, "12345")
        XCTAssertEqual(user!.language!, "en")
        XCTAssertEqual(user!.timeZone!, "PST")
        XCTAssertEqual(user!.programToken!, "prg-00000000-0000-0000-0000-000000000000")
    }

    func testGetUser_businessSuccess() {
        // Given
        let expectation = self.expectation(description: "Get HyperwalletUser completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "UserBusinessResponse")
        let request = HyperwalletTestHelper.buildGetRequest(baseUrl: HyperwalletTestHelper.userRestURL, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var user: HyperwalletUser?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.getUser { (result, error) in
            user = result
            errorResponse = error
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(user)

        XCTAssertEqual(user!.clientUserId!, "myBusinessIdd01")
        XCTAssertEqual(user!.token!, "YourUserToken")
        XCTAssertEqual(user!.status!, HyperwalletUser.Status.preActivated)
        XCTAssertEqual(user!.verificationStatus!, HyperwalletUser.VerificationStatus.notRequired)
        XCTAssertEqual(user!.profileType!, HyperwalletUser.ProfileType.business)
        XCTAssertEqual(user!.gender!, HyperwalletUser.Gender.male)

        XCTAssertEqual(user!.businessType!, HyperwalletUser.BusinessType.corporation)

        XCTAssertEqual(user!.businessRegistrationId!, "ABC0000")
        XCTAssertEqual(user!.businessName!, "Your Business LTD")
        XCTAssertEqual(user!.businessOperatingName!, "My Business LTD")
        XCTAssertEqual(user!.businessRegistrationStateProvince!, "BCA")
        XCTAssertEqual(user!.businessRegistrationCountry!, "US")
        XCTAssertEqual(user!.businessContactRole!, HyperwalletUser.BusinessContactRole.director)
        XCTAssertEqual(user!.businessContactCountry!, "US")
        XCTAssertEqual(user!.email!, "director@mybusiness.net")
        XCTAssertEqual(user!.governmentId!, "000000000")

        XCTAssertEqual(user!.businessContactAddressLine1!, "Business-Address")
        XCTAssertEqual(user!.businessContactAddressLine2!, "Business-Address 2")
        XCTAssertEqual(user!.businessContactCity!, "Flagstaff")
        XCTAssertEqual(user!.businessContactPostalCode!, "0000")
        XCTAssertEqual(user!.businessContactStateProvince!, "AZ")
        XCTAssertEqual(user!.countryOfNationality!, "US")
    }
}
