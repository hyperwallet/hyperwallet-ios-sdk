//
// Copyright 2018 - Present Hyperwallet
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software
// and associated documentation files (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge, publish, distribute,
// sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
// BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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

    // swiftlint:disable force_try
    func testEncode() {
        // Given
        let user = HyperwalletUser
            .Builder()
            .addressLine1("AddressLine1")
            .addressLine2("AddressLine2")
            .businessContactAddressLine1("Business contact addressLine1")
            .businessContactAddressLine2("Business contact addressLine2")
            .businessContactCity("Phoenix")
            .businessContactCountry("US")
            .businessContactPostalCode("00000")
            .businessContactRole(.owner)
            .businessContactStateProvince("AZ")
            .businessName("My Business")
            .businessOperatingName("")
            .businessRegistrationCountry("US")
            .businessRegistrationId("0000")
            .businessRegistrationStateProvince("AZ")
            .businessType(.partnership)
            .city("Phoenix")
            .clientUserId("001")
            .country("US")
            .countryOfBirth("CA")
            .countryOfNationality("CA")
            .createdOn("2000-01-02T00:01:53")
            .dateOfBirth("1970-01-01")
            .driversLicenseId("L0000")
            .email("director@myCompany.com")
            .employerId("001")
            .firstName("Lisa")
            .gender(.female)
            .governmentId("001")
            .governmentIdType("PASSPORT")
            .language("EN")
            .lastName("SMITH")
            .middleName("A")
            .mobileNumber("000-000000")
            .passportId("ABC000")
            .phoneNumber("000-000-00000")
            .postalCode("ABC00")
            .profileType(.business)
            .programToken("0000000")
            .stateProvince("AZ")
            .status(.preActivated)
            .timeZone("PST")
            .token("0000")
            .verificationStatus(.required)
            .build()

        // When
        let jsonBody = try! JSONEncoder().encode(user)

        // Then
        XCTAssertNotNil(jsonBody)
        let jsonBodyString = String(data: jsonBody, encoding: .utf8)!
        XCTAssertTrue(((jsonBodyString.contains("Phoenix"))))
    }
}
