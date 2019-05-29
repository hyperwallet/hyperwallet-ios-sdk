@testable import HyperwalletSDK
import XCTest

//swiftlint:disable force_try
class TransferMethodConfigurationFieldResultTests: XCTestCase {
    var transferMethodConfigurationField: TransferMethodConfigurationField!
    var fieldResult: TransferMethodConfigurationFieldResult!

    override func setUp() {
        transferMethodConfigurationField = hyperwalletGraphQlField(data:
            HyperwalletTestHelper.getDataFromJson("TransferMethodConfigurationFieldsResponse"))!
        fieldResult = TransferMethodConfigurationFieldResult(transferMethodConfigurationField?
            .transferMethodUIConfigurations?.nodes, transferMethodConfigurationField.countries?.nodes?.first)
    }

    func testFees_success() {
        let fieldFees = fieldResult.transferMethodType()?.fees?.nodes
        XCTAssertNotNil(fieldFees)
        XCTAssertEqual(fieldFees?.first?.feeRateType, "FLAT", "Type should be FLAT")
    }

    func testProcessingTime_success() {
        let processingTime = fieldResult?.transferMethodType()?.processingTime
        XCTAssertNotNil(processingTime)
        XCTAssertEqual(processingTime, "1 - 3 business days", "Type should be 1 - 3 business days")
    }

    func testFieldGroupds_success() {
        XCTAssertEqual(fieldResult.fieldGroups()?.count, 2, "The amount of groups is different from the expected value")
        XCTAssertEqual(fieldResult.fieldGroups()?.first?.group, "IDENTIFICATION")
        XCTAssertEqual(fieldResult.fieldGroups()?.last?.group, "BUSINESS_INFORMATION")
    }

    func testFields_success() {
        let identificationGroup = fieldResult.fieldGroups()?.first?.fields
        let businessInfoGroupd = fieldResult.fieldGroups()?.last?.fields
        // IDENTIFICATION groupd field
        let firstName = identificationGroup?.filter { $0.name == "firstName" }
        if let firstName = firstName?.first {
            XCTAssertEqual(firstName.name, "firstName", "Invalid name")
            XCTAssertEqual(firstName.dataType, "TEXT", "Invalid dataType")
            XCTAssertEqual(firstName.isRequired, true, "Should be required")
            XCTAssertEqual(firstName.isEditable, true, "Should be editable")
            XCTAssertEqual(firstName.label, "First Name", "Invalid label")
            XCTAssertEqual(firstName.placeholder, "", "Invalid placeholder")
            XCTAssertEqual(firstName.validationMessage?.length, "", "Invalid message")
            XCTAssertEqual(firstName.validationMessage?.empty,
                           "You must provide a value for this field",
                           "Invalid message")
            XCTAssertEqual(firstName.validationMessage?.pattern,
                           "is invalid length or format.",
                           "Invalid message")
        } else {
            XCTFail("The field name firstName has not been found")
        }

        // BUSINESS_INFORMATION groupd field
        let fieldsFilterByBankAccountId = businessInfoGroupd?.filter { $0.name == "bankAccountId" }
        if let bankAccountId = fieldsFilterByBankAccountId?.first {
            XCTAssertEqual(bankAccountId.name, "bankAccountId", "Invalid name")
            XCTAssertEqual(bankAccountId.dataType, "NUMBER", "Invalid dataType")
            XCTAssertEqual(bankAccountId.isRequired, true, "Should be required")
            XCTAssertEqual(bankAccountId.isEditable, true, "Should be editable")
            XCTAssertEqual(bankAccountId.regularExpression, "^(?![0-]+$)[0-9-]{4,17}$", "Invalid regularExpression")
            XCTAssertEqual(bankAccountId.maxLength, 17, "The maxLength should not be nil")
            XCTAssertEqual(bankAccountId.minLength, 4, "The minLength should not be nil")
            XCTAssertNotNil(bankAccountId.validationMessage, "Validation Messages should not be nil")
            XCTAssertEqual(bankAccountId.validationMessage?.length,
                           "The minimum length of this field is 4 and maximum length is 17.",
                           "Invalid message")
            XCTAssertEqual(bankAccountId.validationMessage?.empty,
                           "You must provide a value for this field",
                           "Invalid message")
            XCTAssertEqual(bankAccountId.validationMessage?.pattern,
                           "is invalid length or format.",
                           "Invalid message")
        } else {
            XCTFail("The field name bankAccountId has not been found")
        }
    }

    private func hyperwalletGraphQlField(data: Data) -> TransferMethodConfigurationField? {
        let decoder = JSONDecoder()

        let graphQlResult = try! decoder.decode(GraphQlResult<TransferMethodConfigurationField>.self, from: data)
        return graphQlResult.data
    }
}
