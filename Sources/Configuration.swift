//
// Copyright 2018 - Present Hyperwallet
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software
// and associated documentation files (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge, publish, distribute,
// sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
// BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Foundation

internal struct Configuration: Codable {
    let createOn: Double
    let clientToken: String
    let expiresOn: Double
    let graphQlUrl: String
    let issuer: String
    let restUrl: String
    let userToken: String
    var authorization: String!
    private static let stalePeriod = 30.0 // 30 seconds
    private let createOnBootTime = ProcessInfo.processInfo.systemUptime

    enum CodingKeys: String, CodingKey {
        case createOn = "iat"
        case clientToken = "aud"
        case expiresOn = "exp"
        case graphQlUrl = "graphql-uri"
        case issuer = "iss"
        case userToken = "sub"
        case restUrl = "rest-uri"
    }

    public func isTokenStale() -> Bool {
        let tokenLifespan = expiresOn - createOn
        return ProcessInfo.processInfo.systemUptime - createOnBootTime >= tokenLifespan - Configuration.stalePeriod
    }

    public func isTokenExpired() -> Bool {
        let tokenLifespan = expiresOn - createOn
        return ProcessInfo.processInfo.systemUptime - createOnBootTime >= tokenLifespan
    }
}
