@testable import HyperwalletSDK
import XCTest

//swiftlint:disable force_try
class TransferMethodConfigurationResultTests: XCTestCase {
    var transferMethodConfigurationKey: TransferMethodConfigurationKey!
    var transferMethodConfigurationField: TransferMethodConfigurationField!
    var keyResult: TransferMethodConfigurationKeyResult!
    var fieldResult: TransferMethodConfigurationFieldResult!

    override func setUp() {
        transferMethodConfigurationKey = hyperwalletGraphQlKey(data:
            HyperwalletTestHelper.getDataFromJson("TransferMethodConfigurationKeysResponse"))!
        transferMethodConfigurationField = hyperwalletGraphQlField(data:
            HyperwalletTestHelper.getDataFromJson("TransferMethodConfigurationFieldsResponse"))!
        keyResult = TransferMethodConfigurationKeyResult(transferMethodConfigurationKey.countries.nodes)
        fieldResult = TransferMethodConfigurationFieldResult(transferMethodConfigurationField?
            .transferMethodUIConfigurations?.nodes, transferMethodConfigurationField.countries?.nodes?.first)
    }

    func testPerformanceCountries() {
        self.measure {
            _ = keyResult.countries()
        }
    }

    func testPerformanceUSCurrencies() {
        self.measure {
            _ = keyResult.currencies(from: keyResult.countries()?.first?.code ?? "")
        }
    }

    func testPerformanceTransferMethods() {
        self.measure {
            let country = keyResult.countries()?.first
            _ = keyResult.transferMethodTypes(countryCode: country?.code ?? "",
                                              currencyCode: country?.currencies?.nodes?.first?.code ?? "")
        }
    }

    func testCountries_success() {
        let countries = keyResult.countries()
        XCTAssertEqual(countries?.count, 4)
    }

    func testTransferMethods_countryUSCurrencyUSDIndividual_success() {
        let transferMethodTypes = keyResult.transferMethodTypes(countryCode: "US", currencyCode: "USD")
        XCTAssertEqual(transferMethodTypes?.count, 3)
        XCTAssertNotNil(transferMethodTypes?.first { $0.code == "BANK_ACCOUNT" })
        XCTAssertNotNil(transferMethodTypes?.first { $0.code == "PAYPAL_ACCOUNT" })
    }

    func testTransferMethodKeyResults_countryUS_currencyUSD_Individual_success() {
        let transferMethodTypes = keyResult.transferMethodTypes(countryCode: "US", currencyCode: "USD")

        XCTAssertEqual(transferMethodTypes?.count, 3)

        let transferMethodFilterByBankAccount = transferMethodTypes?.filter { $0.code == "BANK_ACCOUNT" }

        if let bankAccount = transferMethodFilterByBankAccount?.first?.code {
            XCTAssertEqual(bankAccount, "BANK_ACCOUNT", "Invalid transferMethod")
        } else {
            XCTFail("The BANK_ACCOUNT has not been found")
        }

        let transferMethodFilterByPayPalAccount = transferMethodTypes?.filter { $0.code == "PAYPAL_ACCOUNT" }
        if let payPalAccount = transferMethodFilterByPayPalAccount?.first?.code {
            XCTAssertEqual(payPalAccount, "PAYPAL_ACCOUNT", "Invalid transferMethod")
        } else {
            XCTFail("The PAYPAL_ACCOUNT has not been found")
        }
    }

    func testTransferMethods_countryCACurrencyCADIndividual_success() {
        let transferMethodTypes = keyResult.transferMethodTypes(countryCode: "CA", currencyCode: "CAD")
        XCTAssertEqual(transferMethodTypes?.count, 2)
        XCTAssertNotNil(transferMethodTypes?.first { $0.code == "BANK_ACCOUNT" })
        XCTAssertNotNil(transferMethodTypes?.last { $0.code == "PAYPAL_ACCOUNT" })
    }

    func testCurrencies_success() {
        assertCurrencies(keyResult, from: "US", amount: 2)
    }

    func testCurrencies_invalidCountry() {
        assertCurrencies(keyResult, from: "ZZ", amount: nil)
    }

    func testFees_success() {
        let keyFees = keyResult.transferMethodTypes(countryCode: "CA", currencyCode: "CAD")?.first?.fees?.nodes
        let fieldFees = fieldResult.transferMethodType()?.fees?.nodes

        XCTAssertNotNil(keyFees)
        XCTAssertNotNil(fieldFees)
        XCTAssertEqual(keyFees?.last?.feeRateType, "PERCENT", "Type should be PERCENT")
        XCTAssertEqual(fieldFees?.first?.feeRateType, "FLAT", "Type should be FLAT")
    }

    func testFees_empty() {
        let keyFees = keyResult.transferMethodTypes(countryCode: "HR", currencyCode: "HRK")?.first?.fees?.nodes
        XCTAssertNil(keyFees)
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

    private func assertCurrencies(_ result: TransferMethodConfigurationKeyResult,
                                  from country: String,
                                  amount: Int?) {
        let currencies = result.currencies(from: country)
        XCTAssertEqual(currencies?.count, amount, "The amount of elements is different")
    }

    private func hyperwalletGraphQlKey(data: Data) -> TransferMethodConfigurationKey? {
        let decoder = JSONDecoder()

        let graphQlResult = try! decoder.decode(GraphQlResult<TransferMethodConfigurationKey>.self, from: data)
        return graphQlResult.data
    }

    private func hyperwalletGraphQlField(data: Data) -> TransferMethodConfigurationField? {
        let decoder = JSONDecoder()

        let graphQlResult = try! decoder.decode(GraphQlResult<TransferMethodConfigurationField>.self, from: data)
        return graphQlResult.data
    }
}
