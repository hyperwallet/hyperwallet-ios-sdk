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

        let relationship = HyperwalletBankAccount.RelationshipType.ownCompany
        let purpose = HyperwalletBankAccount.PurposeType.checking
        
        // When
        let bankAccount = HyperwalletBankAccount
            .Builder(transferMethodCountry: "US",
                     transferMethodCurrency: "USD",
                     transferMethodProfileType: "BUSINESS")
            .bankAccountId("7861012345")
            .branchId("102000021")
            .bankAccountRelationship(relationship)
            .bankAccountPurpose(purpose)
            .businessName("US BANK NA")
            .phoneNumber("604-345-1777")
            .mobileNumber("604-345-1888")
            .country("US")
            .stateProvince("WA")
            .addressLine1("1234, Broadway")
            .city("Test City")
            .postalCode("12345")
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
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .transferMethodCountry) as! String, "US")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .transferMethodCurrency) as! String, "USD")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .profileType) as! String, "BUSINESS")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .bankAccountId) as! String, "7861012345")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .branchId) as! String, "102000021")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .bankAccountRelationship) as! String, relationship.rawValue)
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .bankAccountPurpose) as! String, purpose.rawValue)
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .businessName) as! String, "US BANK NA")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .phoneNumber) as! String, "604-345-1777")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .mobileNumber) as! String, "604-345-1888")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .country) as! String, "US")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .stateProvince) as! String, "WA")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .addressLine1) as! String, "1234, Broadway")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .city) as! String, "Test City")
        XCTAssertEqual(bankAccountResponse?.getField(fieldName: .postalCode) as! String, "12345")
    }
}
