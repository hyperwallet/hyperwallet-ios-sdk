import Hippolyte
@testable import HyperwalletSDK
import XCTest

class HyperwalletTests: XCTestCase {
    func testSetup_withConfiguration_configReturned() {
        // Given
        let expectation = XCTestExpectation(description: "Wait for async operation completion")
        var configuration: Configuration?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.setup(HyperwalletTestHelper.authenticationProvider, completion: { (result, error) in
            configuration = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(configuration)
        XCTAssertNil(errorResponse)
        XCTAssertNotNil(configuration?.clientToken, "The clientToken has not been initialized")
        XCTAssertGreaterThan(configuration!.expiresOn, 0, "The expiresOn has not been initialized")
        XCTAssertFalse((configuration?.graphQlUrl.isEmpty)!, "The graphQlUrl has not been initialized")
        XCTAssertFalse(configuration!.restUrl.isEmpty, "The restUrl has not been initialized")
        XCTAssertFalse(configuration!.issuer.isEmpty, "The issuer has not been initialized")
        XCTAssertNotNil(configuration?.authorization, "The authorization has not been initialized")
        XCTAssertFalse((configuration?.authorization!.isEmpty)!, "The authorization has not been initialized")
        XCTAssertFalse((configuration?.insightsUrl!.isEmpty)!, "The insightsUrl has not been initialized")
        XCTAssertFalse((configuration?.environment!.isEmpty)!, "The environment has not been initialized")
    }

    func testSetup_authenticationError() {
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
        Hyperwallet.setup(authenticationProvider, completion: { (result, error) in
            configuration = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(configuration)
        XCTAssertNotNil(errorResponse)
        XCTAssertTrue(errorResponse?.getAuthenticationError()?.message() == "Authentication token cannot be retrieved")
    }

    func testSetup_decodeError() {
        // Given
        let expectation = XCTestExpectation(description: "Wait for async operation completion")
        var configuration: Configuration?
        var errorResponse: HyperwalletErrorType?
        // Set garbage token value
        let authenticationProvider = AuthenticationProviderMock(authorizationData: "Garbage")

        // When
        Hyperwallet.setup(authenticationProvider, completion: { (result, error) in
            configuration = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(configuration)
        XCTAssertNotNil(errorResponse)
        XCTAssertTrue(errorResponse?.getHyperwalletErrors()?.errorList?.count == 1)
        XCTAssertTrue(errorResponse?.getHyperwalletErrors()?.errorList?[0].message == "Invalid Authnetication token")
    }
}
