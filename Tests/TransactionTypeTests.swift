@testable import HyperwalletSDK
import XCTest

class TransactionTypeTests: XCTestCase {
    func testCreateRestRequest_httpPostWithBody() {
        assertCreateRestRequestSucceeded(transactionType: .rest,
                                         httpMethod: .post,
                                         query: ["limit": "10"])
    }

    func testCreateGraphQlRequest_httpPostWithBody() {
        assertCreateGraphQlRequestSucceeded(transactionType: .graphQl,
                                            httpMethod: .post,
                                            query: ["limit": "10"])
    }

    func testCreateRestUrlRequest_restHttpPutWithBody() {
        assertCreateRestRequestSucceeded(transactionType: .rest, httpMethod: .put)
    }

    func testCreateRestUrlRequest_restHttpGetWithBody() {
        assertCreateRestRequestSucceeded(transactionType: .rest,
                                         httpMethod: .get,
                                         query: ["limit": "10", "offset": "0"])
    }

    func testCreateRestRequest_authorizationHeaderWithBearer() {
        let authenticationToken = HyperwalletTestHelper.authenticationToken
        let hyperwalletConfiguration = try? AuthenticationTokenDecoder.decode(from: authenticationToken)

        let transactionType = TransactionType.rest
        let request = try? transactionType.createRequest(hyperwalletConfiguration!,
                                                         method: .get,
                                                         urlPath: "users/%@/bank-accounts",
                                                         httpBody: "")

        let headers = request?.allHTTPHeaderFields
        let authorizationValue = headers?["Authorization"]

        XCTAssertNotNil(authorizationValue, "Authorization token is nil")
        XCTAssertEqual(authorizationValue, "Bearer \(authenticationToken)", "The Bearer token should be equals")
    }

    func testCreateGraphQlRequest_authorizationHeaderWithBearer() {
        let authenticationToken = HyperwalletTestHelper.authenticationToken
        let hyperwalletConfiguration = try? AuthenticationTokenDecoder.decode(from: authenticationToken)

        let transactionType = TransactionType.graphQl
        let request = try? transactionType.createRequest(hyperwalletConfiguration!,
                                                         method: .post,
                                                         urlPath: "/graphql",
                                                         httpBody: "")

        let headers = request?.allHTTPHeaderFields
        let authorizationValue = headers!["Authorization"]

        XCTAssertNotNil(authorizationValue, "Authorization token is nil")
        XCTAssertEqual(authorizationValue, "Bearer \(authenticationToken)", "The Bearer token should be equals")
    }

    //swiftlint:disable force_cast
    func testCreateRestRequest_invalidURL() {
        let transactionType: TransactionType = .rest
        let configuration = Configuration(createOn: 0,
                                          clientToken: "",
                                          expiresOn: 10,
                                          graphQlUrl: "",
                                          issuer: "",
                                          restUrl: "localhost/",
                                          userToken: "",
                                          authorization: "")

        XCTAssertThrowsError(try transactionType.createRequest(configuration,
                                                               method: .post,
                                                               urlPath: "?$filter=owners/ref eq 'test'",
                                                               httpBody: "")) { error in
            XCTAssertEqual((error as! HyperwalletErrorType).getHyperwalletErrors()?.errorList?.first?.code,
                           "INVALID_URL")
        }
    }

    private func assertCreateRestRequestSucceeded(transactionType: TransactionType,
                                                  httpMethod: HTTPMethod,
                                                  query: [String: String] = [String: String]()) {
        let payload = HyperwalletTransferMethodConfigurationFieldQuery(country: "US",
                                                                       currency: "USD",
                                                                       transferMethodType: "",
                                                                       profile: "")

        let configuration = Configuration(createOn: 0,
                                          clientToken: "",
                                          expiresOn: 0,
                                          graphQlUrl: "",
                                          issuer: "",
                                          restUrl: "http://localhost/",
                                          userToken: "",
                                          authorization: "")

        let urlPath = transactionType == .rest ? "users/%@/bank-account" : ""
        do {
            let urlRequest = try transactionType.createRequest(configuration,
                                                               method: httpMethod,
                                                               urlPath: urlPath,
                                                               urlQuery: query,
                                                               httpBody: payload)
            XCTAssertNotNil(urlRequest)
            XCTAssertEqual(urlRequest.httpMethod, httpMethod.rawValue)

            if httpMethod == .get {
                XCTAssertNil(urlRequest.httpBody, "The HTTP body should be nil")
            } else {
                let httpBody = String(data: urlRequest.httpBody!, encoding: .utf8)
                let payloadData = try JSONEncoder().encode(payload)
                let payloadString = String(data: payloadData, encoding: .utf8)
                XCTAssertEqual(httpBody, payloadString, "The HTTP body should be equals to payload")
            }

            let urlComponent = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false)
            query.forEach { (key: String, value: String) in
                let expectedQueryItem = URLQueryItem(name: key, value: value)
                XCTAssertTrue(urlComponent?.queryItems?.contains(expectedQueryItem) ?? false,
                              "The URL Query is invalid")
            }
        } catch {
            XCTFail("should not fail")
        }
    }

    private func assertCreateGraphQlRequestSucceeded(transactionType: TransactionType,
                                                     httpMethod: HTTPMethod,
                                                     query: [String: String] = [String: String]()) {
        let payload = HyperwalletTransferMethodConfigurationFieldQuery(country: "US",
                                                                       currency: "USD",
                                                                       transferMethodType: "",
                                                                       profile: "")
        let configuration = Configuration(createOn: 0,
                                          clientToken: "",
                                          expiresOn: 0,
                                          graphQlUrl: "http://localhost/",
                                          issuer: "",
                                          restUrl: "http://localhost/",
                                          userToken: "",
                                          authorization: "")

        let urlPath = transactionType == .graphQl ? "/graphql" : ""
        do {
            let urlRequest = try transactionType.createRequest(configuration,
                                                               method: httpMethod,
                                                               urlPath: urlPath,
                                                               urlQuery: query,
                                                               httpBody: payload)
            XCTAssertNotNil(urlRequest)
            XCTAssertEqual(urlRequest.httpMethod, httpMethod.rawValue)

            if httpMethod == .get {
                XCTAssertNil(urlRequest.httpBody, "The HTTP body should be nil")
            } else {
                let query = String(data: urlRequest.httpBody!, encoding: .utf8)
                let payloadString = payload.toGraphQl(userToken: configuration.userToken)
                XCTAssertEqual(query, payloadString, "The HTTP body should be equals to payload")
            }
        } catch {
            XCTFail("should not fail")
        }
    }
}
