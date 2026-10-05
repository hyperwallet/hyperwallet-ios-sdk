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

@testable import HyperwalletSDK
import XCTest

class HyperwalletTransferMethodConfigurationFieldQueryTests: XCTestCase {
    func testHashable_fieldQueryNotEqual() {
        let usUsdFieldQuery = HyperwalletTransferMethodConfigurationFieldQuery(country: "US",
                                                                               currency: "USD",
                                                                               transferMethodType: "BANK_CARD",
                                                                               profile: "INDIVIDUAL")

        let usCadFieldQuery = HyperwalletTransferMethodConfigurationFieldQuery(country: "US",
                                                                               currency: "CAD",
                                                                               transferMethodType: "BANK_CARD",
                                                                               profile: "INDIVIDUAL")

        XCTAssertNotEqual(usUsdFieldQuery, usCadFieldQuery)
        XCTAssertNotEqual(usUsdFieldQuery.hashValue, usCadFieldQuery.hashValue)
    }

    func testHashable_editFieldQueryNotEqual() {
        let fieldQuery = HyperwalletTransferMethodUpdateConfigurationFieldQuery(transferMethodToken: "trm-93939939393")
        let fieldQuery1 = HyperwalletTransferMethodUpdateConfigurationFieldQuery(transferMethodToken: "trm-93939939398")
        XCTAssertNotEqual(fieldQuery, fieldQuery1)
        XCTAssertNotEqual(fieldQuery.hashValue, fieldQuery1.hashValue)
    }

    func testToGraphQlNeutralizesInjectionInUnquotedLiteralFields() {
        // Payload from the vulnerability report: attempts to break out of the `Country` field and
        // append a `__schema` introspection selection.
        let injection = "US\") { __schema { types { name } } } #"
        let query = HyperwalletTransferMethodConfigurationFieldQuery(country: injection,
                                                                     currency: "USD",
                                                                     transferMethodType: "BANK_CARD",
                                                                     profile: "INDIVIDUAL")

        let result = query.toGraphQl(userToken: "usr-12345")

        XCTAssertFalse(result.contains("\") {"), "The quote/brace break-out must be removed")
        XCTAssertFalse(result.contains("__schema {"), "The injected introspection selection must not survive")
        XCTAssertFalse(result.contains("#"), "The injected comment marker must be removed")
    }

    func testToGraphQlEscapesQuotesInQuotedStringFields() {
        let injection = "trm-1\" injected"
        let query = HyperwalletTransferMethodUpdateConfigurationFieldQuery(transferMethodToken: injection)

        let result = query.toGraphQl(userToken: "usr-12345")

        XCTAssertTrue(result.contains("trm-1\\\" injected"), "Embedded double quotes must be escaped")
        XCTAssertFalse(result.contains("\"trm-1\" injected\""), "The raw unescaped value must not appear")
    }

    func testToGraphQlKeepsValidValuesUnchanged() {
        let query = HyperwalletTransferMethodConfigurationFieldQuery(country: "US",
                                                                     currency: "USD",
                                                                     transferMethodType: "BANK_CARD",
                                                                     profile: "INDIVIDUAL")

        let result = query.toGraphQl(userToken: "usr-12345")

        XCTAssertTrue(result.contains("US"), "A valid country code must be preserved")
        XCTAssertTrue(result.contains("USD"), "A valid currency code must be preserved")
        XCTAssertTrue(result.contains("BANK_CARD"), "A valid transfer method type must be preserved")
        XCTAssertTrue(result.contains("INDIVIDUAL"), "A valid profile must be preserved")
    }

    func testToGraphQlEscapesQuotesInUserToken() {
        let injection = "usr-1\" injected"
        let query = HyperwalletTransferMethodConfigurationFieldQuery(country: "US",
                                                                     currency: "USD",
                                                                     transferMethodType: "BANK_CARD",
                                                                     profile: "INDIVIDUAL")

        let result = query.toGraphQl(userToken: injection)

        XCTAssertTrue(result.contains("usr-1\\\" injected"), "Embedded double quotes in userToken must be escaped")
        XCTAssertFalse(result.contains("\"usr-1\" injected\""), "The raw unescaped userToken must not appear")
    }

    func testKeysQueryEscapesQuotesInUserToken() {
        let injection = "usr-1\" injected"
        let query = HyperwalletTransferMethodConfigurationKeysQuery(limit: 10)

        let result = query.toGraphQl(userToken: injection)

        XCTAssertTrue(result.contains("usr-1\\\" injected"), "Embedded double quotes in userToken must be escaped")
        XCTAssertFalse(result.contains("\"usr-1\" injected\""), "The raw unescaped userToken must not appear")
    }

    func testFeesAndProcessingTimesNeutralizesInjectionInUnquotedLiteralFields() {
        let injection = "US\") { __schema { types { name } } } #"
        let query = HyperwalletTransferMethodTypesFeesAndProcessingTimesQuery(country: injection, currency: "USD")

        let result = query.toGraphQl(userToken: "usr-12345")

        XCTAssertFalse(result.contains("\") {"), "The quote/brace break-out must be removed")
        XCTAssertFalse(result.contains("__schema {"), "The injected introspection selection must not survive")
        XCTAssertFalse(result.contains("#"), "The injected comment marker must be removed")
    }

    func testFeesAndProcessingTimesEscapesQuotesInUserToken() {
        let injection = "usr-1\" injected"
        let query = HyperwalletTransferMethodTypesFeesAndProcessingTimesQuery(country: "US", currency: "USD")

        let result = query.toGraphQl(userToken: injection)

        XCTAssertTrue(result.contains("usr-1\\\" injected"), "Embedded double quotes in userToken must be escaped")
        XCTAssertFalse(result.contains("\"usr-1\" injected\""), "The raw unescaped userToken must not appear")
    }

    func testFeesAndProcessingTimesKeepsValidValuesUnchanged() {
        let query = HyperwalletTransferMethodTypesFeesAndProcessingTimesQuery(country: "US", currency: "USD")

        let result = query.toGraphQl(userToken: "usr-12345")

        XCTAssertTrue(result.contains("US"), "A valid country code must be preserved")
        XCTAssertTrue(result.contains("USD"), "A valid currency code must be preserved")
    }
}
