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

import Hippolyte
@testable import HyperwalletSDK
import XCTest

class HyperwalletTransferMethodUpdateConfigurationTests: XCTestCase {
    override func setUp() {
        Hyperwallet.setup(HyperwalletTestHelper.authenticationProvider)
    }

    override func tearDown() {
        if Hippolyte.shared.isStarted {
            Hippolyte.shared.stop()
        }
    }

    func testRetrieveTransferMethodConfigurationFields_success() {
        // Given
        let request = setUpTransferMethodUpdateConfigurationRequest("TransferMethodUpdateConfigurationFieldsResponse")
        HyperwalletTestHelper.setUpMockServer(request: request)

        let expectation = self.expectation(description: "Retrieve update transfer method configuration fields")

        var graphQlResponse: HyperwalletTransferMethodUpdateConfigurationField?
        var errorResponse: HyperwalletErrorType?
        // When
        let fieldQuery = HyperwalletTransferMethodUpdateConfigurationFieldQuery(transferMethodToken: "trm-0000001")

        Hyperwallet.shared.retrieveTransferMethodUpdateConfigurationFields(request: fieldQuery) { (result, error) in
            graphQlResponse = result
            errorResponse = error
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(graphQlResponse)
        XCTAssertEqual(graphQlResponse?.fieldGroups()?.count, 3, "`fieldGroups()` should be 3")

//        let bankAccountIdMask = graphQlResponse?.fieldGroups()?
//            .first(where: { $0.group == "ACCOUNT_INFORMATION" })?.fields?
//            .first(where: { $0.name == "bankAccountId" })?.mask
//        XCTAssertNotNil(bankAccountIdMask)
//        XCTAssertEqual(bankAccountIdMask?.defaultPattern, "#####-####")
//        XCTAssertEqual(bankAccountIdMask?.scrubRegex, "\\-")
//        let branchIdMask = graphQlResponse?.fieldGroups()?
//            .first(where: { $0.group == "ACCOUNT_INFORMATION" })?.fields?
//            .first(where: { $0.name == "branchId" })?.mask
//        XCTAssertNotNil(branchIdMask)
//        XCTAssertEqual(branchIdMask?.conditionalPatterns?.count, 2)
//        XCTAssertEqual(branchIdMask?.conditionalPatterns?.first?.pattern, "# ###### ##")
//        XCTAssertEqual(branchIdMask?.conditionalPatterns?.first?.regex, "^4")
//        XCTAssertEqual(branchIdMask?.conditionalPatterns?.last?.pattern, "## #######")
//        XCTAssertEqual(branchIdMask?.conditionalPatterns?.last?.regex, "^5[1-5]")
//        XCTAssertEqual(branchIdMask?.defaultPattern, "#####.###.#")
//        XCTAssertEqual(branchIdMask?.scrubRegex, "\\s")
    }

    private func setUpTransferMethodUpdateConfigurationRequest(_ responseFile: String,
                                                               _ error: NSError? = nil)
        -> StubRequest {
        let data = HyperwalletTestHelper.getDataFromJson(responseFile)
        return HyperwalletTestHelper.buildPostRequest(baseUrl: HyperwalletTestHelper.graphQlURL,
                                                      HyperwalletTestHelper.setUpMockedResponse(payload: data,
                                                                                                error: error))
    }
}
