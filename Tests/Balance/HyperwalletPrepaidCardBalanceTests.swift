import Hippolyte
@testable import HyperwalletSDK
import XCTest

class HyperwalletPrepaidCardBalanceTests: XCTestCase {
    private var amount: String?
    private var currency: String?
    private var expectedCurrency: String?
    private var mockResponseFileName: String?
    private var sortBy: String?
    private var testCaseDescription: String?
    private var prepaidCardBalanceCount: String?

    override func setUp() {
        Hyperwallet.setup(HyperwalletTestHelper.authenticationProvider)
    }

    override func tearDown() {
        if Hippolyte.shared.isStarted {
            Hippolyte.shared.stop()
        }
    }

    func testListPrepaidCardBalances_success() {
        if testCaseDescription != "Empty Result" {
            // Given
            let expectation = self.expectation(description: "List Prepaid Card Balances completed")
            let response = HyperwalletTestHelper.okHTTPResponse(for: mockResponseFileName!)
            let url = String(format: "%@/prepaid-cards/%@/balances", HyperwalletTestHelper.userRestURL, "trm-1234")
            let request = HyperwalletTestHelper.buildGetRequestRegexMatcher(pattern: url, response)
            HyperwalletTestHelper.setUpMockServer(request: request)

            var prepaidCardBalanceList: HyperwalletPageList<HyperwalletBalance>?
            var errorResponse: HyperwalletErrorType?

            // When
            var balanceQueryParam: HyperwalletPrepaidCardBalanceQueryParam?
            if sortBy != nil {
                balanceQueryParam = HyperwalletPrepaidCardBalanceQueryParam()
                balanceQueryParam?.sortBy = sortBy
            }

            Hyperwallet.shared.listPrepaidCardBalances(prepaidCardToken: "trm-1234",
                                                       queryParam: balanceQueryParam) { (result, error) in
                prepaidCardBalanceList = result
                errorResponse = error
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 1)

            // Then
            XCTAssertNil(errorResponse, "\(testCaseDescription!) - The `errorResponse` should be nil")
            XCTAssertNotNil(prepaidCardBalanceList,
                            "\(testCaseDescription!) - The `prepaidCardBalanceList` should not be nil")
            XCTAssertEqual(prepaidCardBalanceList?.count,
                           Int(prepaidCardBalanceCount!),
                           "\(testCaseDescription!) - The `count` should be \(prepaidCardBalanceCount!)")
            XCTAssertNotNil(prepaidCardBalanceList?.data, "\(testCaseDescription!) - The `data` should be not nil")
            XCTAssertNotNil(prepaidCardBalanceList?.links, "\(testCaseDescription!) - The `links` should be not nil")
            XCTAssertNotNil(prepaidCardBalanceList?.links?.first?.params?.rel)

            if let prepaidCardBalance = prepaidCardBalanceList?.data?.first {
                XCTAssertEqual(prepaidCardBalance.amount, amount)
                XCTAssertEqual(prepaidCardBalance.currency, expectedCurrency)
            } else {
                assertionFailure("\(testCaseDescription!) - The prepaid card balance should be not nil")
            }
        }
    }

    func testListPrepaidACardBalances_emptyResult() {
        if testCaseDescription == "Empty Result" {
            // Given
            let expectation = self.expectation(description: "List Prepaid Card Balances completed")
            let response = HyperwalletTestHelper.noContentHTTPResponse()
            let url = String(format: "%@/prepaid-cards/%@/balances", HyperwalletTestHelper.userRestURL, "trm-1234")
            let request = HyperwalletTestHelper.buildGetRequestRegexMatcher(pattern: url, response)
            HyperwalletTestHelper.setUpMockServer(request: request)

            var prepaidCardBalanceList: HyperwalletPageList<HyperwalletBalance>?
            var errorResponse: HyperwalletErrorType?

            //When
           Hyperwallet.shared.listPrepaidCardBalances(prepaidCardToken: "trm-1234") { (result, error) in
                prepaidCardBalanceList = result
                errorResponse = error
                expectation.fulfill()
           }
            wait(for: [expectation], timeout: 1)

            // Then
            XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
            XCTAssertNil(prepaidCardBalanceList, "The `prepaidCardBalanceList` should be nil")
        }
    }

    override static var defaultTestSuite: XCTestSuite {
        let testSuite = XCTestSuite(name: String(describing: self))
        let testParameters = getTestParameters()

        for testCaseParameters in testParameters {
            addTest(with: testCaseParameters, toTestSuite: testSuite)
        }
        return testSuite
    }

    private static func addTest(with testCaseParameters: [String?],
                                toTestSuite testSuite: XCTestSuite) {
        testInvocations.forEach { invocation in
            let testCase = HyperwalletPrepaidCardBalanceTests(invocation: invocation)
            testCase.testCaseDescription = testCaseParameters[0]!
            testCase.mockResponseFileName = testCaseParameters[1]
            testCase.currency = testCaseParameters[2]
            testCase.sortBy = testCaseParameters[3]
            testCase.expectedCurrency = testCaseParameters[4]
            testCase.amount = testCaseParameters[5]
            testCase.prepaidCardBalanceCount = testCaseParameters[6]
            testSuite.addTest(testCase)
        }
    }

    private static func getTestParameters() -> [[String?]] {
        // Each test case parameter contains
        // testCaseDescription, mockResponseFileName, currency, sortBy, expectedCurrency, amount,
        // prepaidCardBalanceCount
        let testParameters = [
            [
                "List of balances for USD, sorted on currency",
                "ListPrepaidCardBalancesResponseSuccess", "USD", "currency", "USD", "9933.35", "1"
            ],
            ["Empty Result", nil, nil, nil, nil, nil, nil]
        ]
        return testParameters
    }
}
