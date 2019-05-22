import Hippolyte
@testable import HyperwalletSDK
import XCTest

// swiftlint:disable force_cast
class HyperwalletBankAccountBusinessTests: XCTestCase {
    override func setUp() {
        Hyperwallet.setup(HyperwalletTestHelper.authenticationProvider)
    }

    override func tearDown() {
        if Hippolyte.shared.isStarted {
            Hippolyte.shared.stop()
        }
    }

    func testCreateBankAccount_business_success() {
        // Given
        let expectation = self.expectation(description: "Create bank account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "BankAccountBusinessResponse")
        let url = String(format: "%@/bank-accounts", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostResquest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var bankAccountResponse: HyperwalletBankAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let bankAccount = HyperwalletBankAccount
            .Builder(transferMethodCountry: "US",
                     transferMethodCurrency: "USD",
                     transferMethodProfileType: "BUSINESS")
            .bankAccountId("7861012345")
            .branchId("102000021")
            .bankAccountRelationship(.ownCompany)
            .bankAccountPurpose(.checking)
            .build()

        Hyperwallet.shared.createBankAccount(account: bankAccount, completion: { (result, error) in
            bankAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(bankAccount)
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(bankAccountResponse?.getFields())
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .city) as! String, "Test City")
    }
}
