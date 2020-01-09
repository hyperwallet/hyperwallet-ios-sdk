import Hippolyte
@testable import HyperwalletSDK
import XCTest

class HyperwalletBalanceTests: XCTestCase {
    private var balanceResponse: String?
    private var currency: String?
    private var sortBy: String?
    private var expectedCurrency: String?
    private var amount: String?
    private var userBalanceCount: String?

    override func setUp() {
        Hyperwallet.setup(HyperwalletTestHelper.authenticationProvider)
    }

    override func tearDown() {
        if Hippolyte.shared.isStarted {
            Hippolyte.shared.stop()
        }
    }

    func testListUserBalances_success() {
        // Given
        let expectation = self.expectation(description: "List User Balances completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: balanceResponse!)
        let url = String(format: "%@/balances", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequestRegexMatcher(pattern: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var userBalanceList: HyperwalletPageList<HyperwalletBalance>?
        var errorResponse: HyperwalletErrorType?

        // When
        var balanceQueryParam: HyperwalletBalanceQueryParam?
        if sortBy != nil || currency != nil {
            balanceQueryParam = HyperwalletBalanceQueryParam()
            balanceQueryParam?.currency = currency
            balanceQueryParam?.sortBy = sortBy
        }

        Hyperwallet.shared.listUserBalances(queryParam: balanceQueryParam) { (result, error) in
            userBalanceList = result
            errorResponse = error
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(userBalanceList, "The `userBalanceList` should not be nil")
        XCTAssertEqual(userBalanceList?.count, Int(userBalanceCount!), "The `count` should be \(userBalanceCount!)")
        XCTAssertNotNil(userBalanceList?.data, "The `data` should be not nil")
        XCTAssertNotNil(userBalanceList?.links, "The `links` should be not nil")
        XCTAssertNotNil(userBalanceList?.links?.first?.params?.rel)

        if let userBalance = userBalanceList?.data?.first {
            XCTAssertEqual(userBalance.amount, amount)
            XCTAssertEqual(userBalance.currency, expectedCurrency)
        } else {
            assertionFailure("The user balance should be not nil")
        }
    }

    override static var defaultTestSuite: XCTestSuite {
        let testSuite = XCTestSuite(name: String(describing: self))
        let testParameters = getTestParameters()

        for testParameter in testParameters {
            addTest(balanceResponse: testParameter[0]!,
                    currency: testParameter[1],
                    sortBy: testParameter[2],
                    expectedCurrency: testParameter[3]!,
                    amount: testParameter[4]!,
                    userBalanceCount: testParameter[5]!,
                    toTestSuite: testSuite)
        }
        return testSuite
    }

    // swiftlint:disable function_parameter_count
    private static func addTest(balanceResponse: String,
                                currency: String?,
                                sortBy: String?,
                                expectedCurrency: String,
                                amount: String,
                                userBalanceCount: String,
                                toTestSuite testSuite: XCTestSuite) {
        testInvocations.forEach { invocation in
            let testCase = HyperwalletBalanceTests(invocation: invocation)
            testCase.balanceResponse = balanceResponse
            testCase.currency = currency
            testCase.sortBy = sortBy
            testCase.expectedCurrency = expectedCurrency
            testCase.amount = amount
            testCase.userBalanceCount = userBalanceCount
            testSuite.addTest(testCase)
        }
    }

    private static func getTestParameters() -> [[String?]] {
        let testParameters = [
            ["ListUserBalancesResponseWithCurrency", "USD", "currency", "USD", "9933.35", "1"],
            ["ListUserBalancesResponseWithoutCurrency", nil, "currency", "CAD", "988.03", "10"],
            ["ListUserBalancesResponseSortCurrencyDesc", nil, "-currency", "USD", "9933.35", "10"],
            ["ListUserBalancesResponseWithoutCurrency", nil, nil, "CAD", "988.03", "10"]
        ]
        return testParameters
    }
}
