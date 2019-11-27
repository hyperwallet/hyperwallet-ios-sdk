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
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            XCTAssertTrue(configuration.isTokenExpired(), "Token should be expired")
        }
    }

    func testIsTokenExpired_false() {
        let expiryOn = Double((Date().addingTimeInterval(600).timeIntervalSince1970).rounded())

        let configuration = getConfiguration(expiryOn)

        XCTAssertFalse(configuration.isTokenExpired(), "Token should not be expired")
    }

    private func getConfiguration (_ expiryOn: Double) -> Configuration {
        return Configuration(createOn: issueTime,
                             clientToken: "client-token",
                             expiresOn: expiryOn,
                             graphQlUrl: "https://test/graphql",
                             restUrl: "https://test/restUrl",
                             environment: "DEV",
                             insightsUrl: "https://test/insightsUrl",
                             issuer: "issuer-token",
                             userToken: "user-token",
                             authorization: "")
    }
}
