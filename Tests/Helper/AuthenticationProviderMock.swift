import Foundation
@testable import HyperwalletSDK

class AuthenticationProviderMock: HyperwalletAuthenticationTokenProvider {
    /// Authentication token
    let authorizationData: String?
    var error: HyperwalletAuthenticationErrorType?

    /// Indicates the `completionHandler` has been performed
    var hasRequestedClientToken = false

    init(authorizationData: String?, error: HyperwalletAuthenticationErrorType? = nil) {
        self.authorizationData = authorizationData
        self.error = error
    }

    /// Resets mock status
    func reset() {
        hasRequestedClientToken = false
        error = nil
    }

    func retrieveAuthenticationToken(completionHandler authenticationTokenHandler: @escaping
        AuthenticationProviderMock.CompletionHandler) {
        hasRequestedClientToken = true
        authenticationTokenHandler(authorizationData, error)
    }
}
