@testable import HyperwalletSDK
import XCTest

class ConfigurationTests: XCTestCase {
    var issueDate: Date!
    var issueTime: Double!

    override func setUp() {
        issueDate = Date()
        issueTime = Double((issueDate.timeIntervalSince1970).rounded())
    }

    func testIsTokenStale_true() {
        let expiryOn = Double((Date().addingTimeInterval(0.1).timeIntervalSince1970).rounded())
        let configuration = getConfiguration(expiryOn)
        XCTAssertTrue(configuration.isTokenStale(), "Token should be stale")
    }

    func testIsTokenStale_false() {
        let expiryOn = Double((Date().addingTimeInterval(600).timeIntervalSince1970).rounded())
        let configuration = getConfiguration(expiryOn)
        XCTAssertFalse(configuration.isTokenStale(), "Token should not be stale")
    }

    func testIsTokenExpired_true() {
        let expiryOn = Double((Date().addingTimeInterval(0.1).timeIntervalSince1970).rounded())
        let configuration = getConfiguration(expiryOn)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(configuration.isTokenExpired(), "Token should be expired")
        }
    }

    func testIsTokenExpired_false() {
        let expiryOn = Double((Date().addingTimeInterval(600).timeIntervalSince1970).rounded())

        let configuration = getConfiguration(expiryOn)

        XCTAssertFalse(configuration.isTokenExpired(), "Token should not be expired")
    }

    private func getConfiguration(_ expiryOn: Double) -> Configuration {
        return Configuration(createOn: issueTime,
                             clientToken: "pgu-022a69d0-d651-11e5-a276-d47cee384cd5",
                             expiresOn: expiryOn,
                             graphQlUrl: "https://qamaster.aws.paylution.net/graphql",
                             issuer: "prg-0438cadc-614c-11e5-af23-0faa28ca7c0f",
                             restUrl: "https://qamaster.aws.paylution.net/rest/v3/",
                             userToken: "usr-7e713de4-34e9-4e10-93cc-1f085b2d8397",
                             authorization: nil)
    }
}
