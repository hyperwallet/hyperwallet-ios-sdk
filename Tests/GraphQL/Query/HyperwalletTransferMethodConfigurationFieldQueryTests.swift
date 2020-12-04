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
        let fieldQuery = HyperwalletTransferMethodUpdateConfigurationFieldQuery(transferMethodToken: "93939939393")
        let fieldQuery1 = HyperwalletTransferMethodUpdateConfigurationFieldQuery(transferMethodToken: "93939939398")
        XCTAssertNotEqual(fieldQuery, fieldQuery1)
        XCTAssertNotEqual(fieldQuery.hashValue, fieldQuery1.hashValue)
    }
}
