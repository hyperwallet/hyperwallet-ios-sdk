import Hippolyte
@testable import HyperwalletSDK
import XCTest

class HyperwalletTests: XCTestCase {
    func testGetConfiguration_existingConfiguration() {
        // Given
        let expectation = XCTestExpectation(description: "Wait for async operation completion")
        var configuration: Configuration?

        // When
        Hyperwallet.setup(HyperwalletTestHelper.authenticationProvider)
        // Make sure that httpTransaction.configuration is populated
        Hyperwallet.shared.getUser { (_, _) in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)

        Hyperwallet.shared.getConfiguration(completion: { (result, _) in
            configuration = result
            expectation.fulfill()
        })

        // Then
        XCTAssertNotNil(configuration, "A valid configuration was not returned")
    }

    // This makes call to the provider to retrieve configuration
    func testGetConfiguration_retrieveConfiguration() {
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
        Hyperwallet.clearInstance()
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
        Hyperwallet.clearInstance()
    }

    func testSetup_getConfiguration_decodeError() {
        // Given
        let expectation = XCTestExpectation(description: "Wait for async operation completion")
        var configuration: Configuration?
        var errorResponse: HyperwalletErrorType?
        // Set garbage token value
        let authenticationProvider = AuthenticationProviderMock(authorizationData: "Garbage")

        // When
        Hyperwallet.clearInstance()
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
        Hyperwallet.clearInstance()
    }

    func testClearInstance() {
        Hyperwallet.setup(HyperwalletTestHelper.authenticationProvider)
        let hyperwalletInstance1 = Hyperwallet.shared
        XCTAssertNotNil(hyperwalletInstance1)
        Hyperwallet.clearInstance()
        Hyperwallet.setup(HyperwalletTestHelper.authenticationProvider)
        let hyperwalletInstance2 = Hyperwallet.shared
        XCTAssertNotNil(hyperwalletInstance2)
        XCTAssertNotEqual(hyperwalletInstance1,
                          hyperwalletInstance2,
                          "hyperwalletInstance2 should not be same as hyperwalletInstance1")
    }
}
