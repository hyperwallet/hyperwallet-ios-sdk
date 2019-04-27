import Foundation

/// Generates a mock Authentication Token
struct AuthenticationTokenGeneratorMock {
    private var userToken: String
    private var restUrl: String
    private var graphQlUrl: String
    private var minuteExpireIn: Int

    init(hostName: String = "localhost",
         minuteExpireIn: Int = 10,
         userToken: String = "YourUserToken") {
        self.restUrl = "https://\(hostName)/rest/v3/"
        self.graphQlUrl = "https://\(hostName)/graphql"
        self.minuteExpireIn = minuteExpireIn
        self.userToken = userToken
    }

    init(
         restUrl: String = "https://localhost/rest/v3/",
         graphQlUrl: String = "https://localhost/graphql") {
        self.restUrl = restUrl
        self.graphQlUrl = graphQlUrl
        self.minuteExpireIn = 10
        self.userToken = "YourUserToken"
    }

    /// Returns the Authentication Token
    var token: String {
        let headerBase64 = Data(header.utf8).base64EncodedString()
        let payloadBase64 = Data(payload.utf8).base64EncodedString()
        let signatureBase64 = Data("fake Signature".utf8).base64EncodedString()

        return "\(headerBase64).\(payloadBase64).\(signatureBase64)"
    }

    private var payload: String {
        let currentDate = Date()
        let expireIn = buildFutureDate(baseDate: currentDate, minute: minuteExpireIn)
        return """
        {
        "sub": "\(userToken)",
        "iat": \(Int(currentDate.timeIntervalSince1970)),
        "exp": \(expireIn),
        "aud": "abc-00000-00000",
        "iss": "cbd-00000-00000",
        "rest-uri": "\(restUrl)",
        "graphql-uri": "\(graphQlUrl)"
        }
        """
    }

    /// Returns the Authentication header
    private var header: String {
        return """
        {
        "alg": "ALGORITHM"
        }
        """
    }

    /// Generates the future date based at the attributes `baseDate` and `minute`
    private func buildFutureDate(baseDate: Date = Date(), minute: Int = 10) -> Int {
        var dateComponent = DateComponents()
        dateComponent.minute = minute

        guard  let expiredDate = Calendar.current.date(byAdding: dateComponent, to: baseDate) else {
            return 0
        }
        return Int(expiredDate.timeIntervalSince1970)
    }
}
