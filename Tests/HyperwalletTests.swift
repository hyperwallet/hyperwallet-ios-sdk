import Hippolyte
@testable import HyperwalletSDK
import XCTest

class HyperwalletTests: XCTestCase {
    func testSetup_getConfiguration() {
        // Given
        let expectation = XCTestExpectation(description: "Wait for async operation completion")
        var configuration: Configuration?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.setup(HyperwalletTestHelper.authenticationProvider)
        Hyperwallet.shared.getConfiguration(completion: { (result, error) in
            configuration = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(configuration, "A valid configuration was not returned")
        XCTAssertNil(errorResponse, "No errors should be returned")
        XCTAssertNotNil(configuration?.clientToken, "The clientToken has not been initialized")
        XCTAssertGreaterThan(configuration!.expiresOn, 0, "The expiresOn has not been initialized")
        XCTAssertNotNil(configuration?.graphQlUrl, "The graphQlUrl has not been initialized")
        XCTAssertNotNil(configuration?.restUrl, "The restUrl has not been initialized")
        XCTAssertNotNil(configuration?.issuer, "The issuer has not been initialized")
        XCTAssertNotNil(configuration?.authorization, "The authorization has not been initialized")
        XCTAssertNotNil(configuration?.authorization, "The authorization has not been initialized")
        XCTAssertNotNil(configuration?.insightsUrl, "The insightsUrl has not been initialized")
        XCTAssertNotNil(configuration?.environment, "The environment has not been initialized")
    }

    func testSetup_getConfiguration_authenticationError() {
        // Given
        let expectation = XCTestExpectation(description: "Wait for async operation completion")
        var configuration: Configuration?
        var errorResponse: HyperwalletErrorType?
        let authErrorResponse: HyperwalletAuthenticationErrorType? = HyperwalletAuthenticationErrorType
            .unexpected("Authentication token cannot be retrieved")

        let authenticationProvider = AuthenticationProviderMock(
            authorizationData: HyperwalletTestHelper.authenticationToken,
            error: authErrorResponse)

        // When
        Hyperwallet.setup(authenticationProvider)
        Hyperwallet.shared.getConfiguration(completion: { (result, error) in
            configuration = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(configuration, "Configuration should not be returned")
        XCTAssertNotNil(errorResponse, "A valid error response should be returned")
        XCTAssertTrue(errorResponse?.getAuthenticationError()?.message() == "Authentication token cannot be retrieved")
    }

    func testSetup_getConfiguration_decodeError() {
        // Given
        let expectation = XCTestExpectation(description: "Wait for async operation completion")
        var configuration: Configuration?
        var errorResponse: HyperwalletErrorType?
        // Set garbage token value
        let authenticationProvider = AuthenticationProviderMock(authorizationData: "Garbage")

        // When
        Hyperwallet.setup(authenticationProvider)
        Hyperwallet.shared.getConfiguration(completion: { (result, error) in
            configuration = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(configuration, "Configuration should not be returned")
        XCTAssertNotNil(errorResponse, "A valid error response should be returned")
        XCTAssertTrue(errorResponse?.getHyperwalletErrors()?.errorList?.count == 1)
        XCTAssertTrue(errorResponse?.getHyperwalletErrors()?.errorList?[0].message == "Invalid Authnetication token")
    }
}
