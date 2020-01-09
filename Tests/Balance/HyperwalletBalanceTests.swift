import Hippolyte
@testable import HyperwalletSDK
import XCTest

class HyperwalletBalanceTests: XCTestCase {
    private var testCaseDescription: String?
    private var mockResponseFileName: String?
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
        let response = HyperwalletTestHelper.okHTTPResponse(for: mockResponseFileName!)
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
        XCTAssertNil(errorResponse, "\(testCaseDescription!) - The `errorResponse` should be nil")
        XCTAssertNotNil(userBalanceList, "\(testCaseDescription!) - The `userBalanceList` should not be nil")
        XCTAssertEqual(userBalanceList?.count,
                       Int(userBalanceCount!),
                       "\(testCaseDescription!) - The `count` should be \(userBalanceCount!)")
        XCTAssertNotNil(userBalanceList?.data, "\(testCaseDescription!) - The `data` should be not nil")
        XCTAssertNotNil(userBalanceList?.links, "\(testCaseDescription!) - The `links` should be not nil")
        XCTAssertNotNil(userBalanceList?.links?.first?.params?.rel)

        if let userBalance = userBalanceList?.data?.first {
            XCTAssertEqual(userBalance.amount, amount)
            XCTAssertEqual(userBalance.currency, expectedCurrency)
        } else {
            assertionFailure("\(testCaseDescription!) - The user balance should be not nil")
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
            let testCase = HyperwalletBalanceTests(invocation: invocation)
            testCase.testCaseDescription = testCaseParameters[0]!
            testCase.mockResponseFileName = testCaseParameters[1]!
            testCase.currency = testCaseParameters[2]
            testCase.sortBy = testCaseParameters[3]
            testCase.expectedCurrency = testCaseParameters[4]!
            testCase.amount = testCaseParameters[5]!
            testCase.userBalanceCount = testCaseParameters[6]!
            testSuite.addTest(testCase)
        }
    }

    private static func getTestParameters() -> [[String?]] {
        // Each test case parameter contains
        // testCaseDescription, mockResponseFileName, currency, sortBy, expectedCurrency, amount, userBalanceCount
        let testParameters = [
            [
                "List of balances for USD, sorted on currency",
                "ListUserBalancesResponseWithCurrency", "USD", "currency", "USD", "9933.35", "1"
            ],
            [
                "List of balances without currency, sorted on currency",
                "ListUserBalancesResponseWithoutCurrency", nil, "currency", "CAD", "988.03", "10"
            ],
            [
                "List of balances without currency, sorted on currency descending",
                "ListUserBalancesResponseSortCurrencyDesc", nil, "-currency", "USD", "9933.35", "10"
            ],
            [
                "List of balances without currency and sortBy",
                "ListUserBalancesResponseWithoutCurrency", nil, nil, "CAD", "988.03", "10"
            ]
        ]
        return testParameters
    }
}
