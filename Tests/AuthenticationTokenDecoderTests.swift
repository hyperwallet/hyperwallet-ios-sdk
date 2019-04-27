@testable import HyperwalletSDK
import XCTest

class AuthenticationTokenDecoderTests: XCTestCase {
    func testDecode_emptyAuthenticationToken_throwsParseError() {
        performDecodeThrowsParseError("")
    }

    func testDecode_authenticationTokenWithTwoParts_throwsParseError() {
        let authenticationToken = "123.hJQWHABDBjoPHorYF5xghQ"

        performDecodeThrowsParseError(authenticationToken)
    }

    func testDecode_badAuthenticationToken_throwsParseError() {
        let authenticationToken = "123.hJQWHABDBjoPHorYF5xghQ.00123"

        performDecodeThrowsParseError(authenticationToken)
    }

    func testDecode_valid_configuration() {
        do {
            let configuration = try AuthenticationTokenDecoder.decode(from: HyperwalletTestHelper.authenticationToken)
            XCTAssertNotNil(configuration.clientToken, "The clientToken has not been initialized")
            XCTAssertGreaterThan(configuration.createOn, 0, "The createOn has not been initialized")
            XCTAssertGreaterThan(configuration.expiresOn, 0, "The expiresOn has not been initialized")
            XCTAssertFalse(configuration.graphQlUrl.isEmpty, "The graphQlUrl has not been initialized")
            XCTAssertFalse(configuration.restUrl.isEmpty, "The restUrl has not been initialized")
            XCTAssertFalse(configuration.issuer.isEmpty, "The issuer has not been initialized")
            XCTAssertNotNil(configuration.authorization, "The authorization has not been initialized")
            XCTAssertFalse(configuration.authorization!.isEmpty, "The authorization has not been initialized")
        } catch {
            XCTFail("should be unexpected error")
        }
    }

    func performDecodeThrowsParseError(_ authenticationToken: String) {
        XCTAssertThrowsError(try AuthenticationTokenDecoder.decode(from: authenticationToken)) { error in
            XCTAssertNotNil(error as? HyperwalletErrorType)
            let errorType = error as? HyperwalletErrorType
            XCTAssertEqual(errorType?.getHyperwalletErrors()?.errorList?.first?.code, "PARSE_ERROR")
        }
    }
}
