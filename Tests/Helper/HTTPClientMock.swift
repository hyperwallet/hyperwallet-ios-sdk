import Foundation
@testable import HyperwalletSDK

class HTTPClientMock: HTTPClientProtocol {
    var hasPerformed = false
    var request: URLRequest?
    var data: Data? = "{}".data(using: .utf8)
    var urlResponse: URLResponse?
    var error: Error?

    /// Resets mock status
    func reset() {
        hasPerformed = false
        request = nil
        data = "{}".data(using: .utf8)
        urlResponse = nil
        error = nil
    }

    func perform(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.hasPerformed = true
        self.request = request
        completionHandler(data, urlResponse, error)
    }

    func invalidateSession() {
    }
}
