@testable import HyperwalletSDK
import XCTest

//swiftlint:disable force_try
class TransferMethodConfigurationResultTests: XCTestCase {
    let transferMethodConfigurationKeysResult = TransferMethodConfigurationResult(
        response: hyperwalletGraphQlResult(data:
            HyperwalletTestHelper.getDataFromJson("TransferMethodConfigurationKeysResponse"))!)

    let transferMethodConfigurationFieldsResult = TransferMethodConfigurationResult(
        response: hyperwalletGraphQlResult(data:
            HyperwalletTestHelper.getDataFromJson("TransferMethodConfigurationFieldsResponse"))!)

    let emptyGraphQlResult = TransferMethodConfigurationResult(
        response: hyperwalletGraphQlResult(data:
            HyperwalletTestHelper.getDataFromJson("TransferMethodConfigurationEmptyResponse"))!)

    func testPerformanceCountries() {
        self.measure {
            _ = transferMethodConfigurationKeysResult.countries()
        }
    }

    func testPerformanceUSCurrencies() {
        self.measure {
            _ = transferMethodConfigurationKeysResult.currencies(from: "US")
        }
    }

    func testPerformanceTransferMethods() {
        self.measure {
            _ = transferMethodConfigurationKeysResult.transferMethodTypes(country: "US",
                                                                          currency: "USD",
                                                                          profileType: "INDIVIDUAL")
        }
    }

    func testPerformanceTransferMethodKeys() {
        self.measure {
            _ = transferMethodConfigurationKeysResult.transferMethodTypes(country: "US",
                                                                          currency: "USD",
                                                                          profileType: "INDIVIDUAL")
        }
    }

    func testCountries_success() {
        let countries = transferMethodConfigurationKeysResult.countries()
        XCTAssertEqual(countries.count, 5)
    }

    func testCountries_emptyResponse() {
        let countries = emptyGraphQlResult.countries()
        XCTAssertEqual(countries.count, 0)
    }

    func testTransferMethods_emptyResponse() {
        let transferMethodTypes = emptyGraphQlResult.transferMethodTypes(country: "US",
                                                                         currency: "USD",
                                                                         profileType: "INDIVIDUAL")
        XCTAssertEqual(transferMethodTypes.count, 0)
    }

    func testTransferMethods_countryUSCurrencyUSDIndividual_success() {
        let transferMethodTypes = transferMethodConfigurationKeysResult.transferMethodTypes(
                                                                    country: "US",
                                                                    currency: "USD",
                                                                    profileType: "INDIVIDUAL")
        XCTAssertEqual(transferMethodTypes.count, 3)
        XCTAssertNotNil(transferMethodTypes.first { $0 == "BANK_ACCOUNT" })
        XCTAssertNotNil(transferMethodTypes.first { $0 == "PAPER_CHECK" })
        XCTAssertNotNil(transferMethodTypes.first { $0 == "PAYPAL_ACCOUNT" })
    }

    func testTransferMethodKeyResults_countryUS_currencyUSD_Individual_success() {
        let transferMethodTypes = transferMethodConfigurationKeysResult.transferMethodTypes(
                                                                    country: "US",
                                                                    currency: "USD",
                                                                    profileType: "INDIVIDUAL")
        XCTAssertEqual(transferMethodTypes.count, 3)

        let transferMethodFilterByBankAccount = transferMethodTypes.filter { $0 == "BANK_ACCOUNT" }

        if let bankAccount = transferMethodFilterByBankAccount.first {
            XCTAssertEqual(bankAccount, "BANK_ACCOUNT", "Invalid transferMethod")
        } else {
            XCTFail("The BANK_ACCOUNT has not been found")
        }

        let transferMethodFilterByPaperCheck = transferMethodTypes.filter { $0 == "PAPER_CHECK" }
        if let paperCheck = transferMethodFilterByPaperCheck.first {
            XCTAssertEqual(paperCheck, "PAPER_CHECK", "Invalid transferMethod")
            //            XCTAssertEqual(paperCheck.fee, "$3.00 USD", "Invalid fee")
        } else {
            XCTFail("The PAPER_CHECK has not been found")
        }

        let transferMethodFilterByPayPalAccount = transferMethodTypes.filter { $0 == "PAYPAL_ACCOUNT" }
        if let payPalAccount = transferMethodFilterByPayPalAccount.first {
            XCTAssertEqual(payPalAccount, "PAYPAL_ACCOUNT", "Invalid transferMethod")
        } else {
            XCTFail("The PAYPAL_ACCOUNT has not been found")
        }
    }

    func testTransferMethods_countryDECurrencyUSDIndividual_success() {
        let transferMethodTypes = transferMethodConfigurationKeysResult.transferMethodTypes(country: "DE",
                                                                                            currency: "USD",
                                                                                            profileType: "INDIVIDUAL")
        XCTAssertEqual(transferMethodTypes.count, 1)
        XCTAssertNotNil(transferMethodTypes.first { $0 == "WIRE_ACCOUNT" })
    }

    func testCurrencies_emptyResponse() {
        assertCurrencies(emptyGraphQlResult, from: "US", amount: 0)
    }

    func testCurrencies_success() {
        assertCurrencies(transferMethodConfigurationKeysResult, from: "US", amount: 2)
    }

    func testCurrencies_invalidCountry() {
        assertCurrencies(transferMethodConfigurationKeysResult, from: "ZZ", amount: 0)
    }

    func testFees_success() {
        let keyFees = transferMethodConfigurationKeysResult.fees( country: "US",
                                                                  currency: "USD",
                                                                  profileType: "INDIVIDUAL",
                                                                  transferMethodType: "BANK_ACCOUNT")

        let fieldFees = transferMethodConfigurationFieldsResult.fees( country: "US",
                                                                      currency: "USD",
                                                                      profileType: "INDIVIDUAL",
                                                                      transferMethodType: "BANK_ACCOUNT")

        XCTAssertNotNil(keyFees)
        XCTAssertNotNil(fieldFees)
        XCTAssertEqual(keyFees?.first?.feeRateType, "PERCENT", "Type should be PERCENT")
        XCTAssertEqual(fieldFees?.first?.feeRateType, "FLAT", "Type should be FLAT")
    }

    func testFees_empty() {
        let keyFees = transferMethodConfigurationKeysResult.fees(country: "US",
                                                                 currency: "USD",
                                                                 profileType: "INDIVIDUAL",
                                                                 transferMethodType: "PAYPAL_ACCOUNT")

        XCTAssertNil(keyFees)
    }

    func testProcessingTime_success() {
        let keyProcessingTime = transferMethodConfigurationKeysResult.processingTime(
                                                              country: "US",
                                                              currency: "USD",
                                                              profileType: "INDIVIDUAL",
                                                              transferMethodType: "BANK_ACCOUNT")

        let fieldProcessingTime = transferMethodConfigurationFieldsResult.processingTime(
                                                            country: "US",
                                                            currency: "USD",
                                                            profileType: "INDIVIDUAL",
                                                            transferMethodType: "BANK_ACCOUNT")

        XCTAssertNotNil(keyProcessingTime)
        XCTAssertNotNil(fieldProcessingTime)
        XCTAssertEqual(keyProcessingTime, "1-3 Business days", "processingTime should be 1-3 Business days")
        XCTAssertEqual(fieldProcessingTime, "1-3 Business days", "processingTime should be 1-3 Business days")
    }

    func testProcessingTime_empty() {
        let processingTime = transferMethodConfigurationKeysResult.processingTime(
                                                              country: "US",
                                                              currency: "USD",
                                                              profileType: "INDIVIDUAL",
                                                              transferMethodType: "PAYPAL_ACCOUNT")

        XCTAssertNil(processingTime)
    }

    func testPerformanceFields() {
        // This is an example of a performance test case.
        self.measure {
            _ = transferMethodConfigurationFieldsResult.fields()
        }
    }

    func testFields_emptyResponse() {
        let fields = emptyGraphQlResult.fields()
        XCTAssertEqual(fields.count, 0, "The amount should be 0")
    }

    //swiftlint:disable function_body_length
    func testFields_success() {
        let fields = transferMethodConfigurationFieldsResult.fields()
        XCTAssertEqual(fields.count, 3, "The amount of elements is different from the expected value")
        // Assert Field bankAccountPurpose
        let fieldsFilterByBankAccountPurpose = fields.filter { $0.name == "bankAccountPurpose" }
        if let bankAccountPurpose = fieldsFilterByBankAccountPurpose.first {
            XCTAssertEqual(bankAccountPurpose.name, "bankAccountPurpose", "Invalid name")
            XCTAssertEqual(bankAccountPurpose.category, "ACCOUNT", "Invalid category")
            XCTAssertEqual(bankAccountPurpose.dataType, "SELECTION", "Invalid dataType")
            XCTAssertEqual(bankAccountPurpose.isRequired, true, "Should be required")
            XCTAssertNil(bankAccountPurpose.isEditable, "Should be nil")
            XCTAssertEqual(bankAccountPurpose.label, "Account Type", "Invalid label")
            XCTAssertEqual(bankAccountPurpose.placeholder, "", "Invalid placeholder")
            XCTAssertEqual(bankAccountPurpose.fieldSelectionOptions?.count, 2, "Invalid size")
            XCTAssertEqual(bankAccountPurpose.validationMessage?.length, "", "Invalid message")
            XCTAssertEqual(bankAccountPurpose.validationMessage?.empty,
                           "You must provide a value for this field",
                           "Invalid message")
            XCTAssertEqual(bankAccountPurpose.validationMessage?.pattern,
                           "accountType is invalid format.",
                           "Invalid message")
        } else {
            XCTFail("The field name bankAccountPurpose has not been found")
        }

        // Assert Field branchId
        let fieldsFilterByBranchId = fields.filter { $0.name == "branchId" }
        if let branchId = fieldsFilterByBranchId.first {
            XCTAssertEqual(branchId.name, "branchId", "Invalid name")
            XCTAssertEqual(branchId.category, "ACCOUNT", "Invalid category")
            XCTAssertEqual(branchId.dataType, "NUMBER", "Invalid dataType")
            XCTAssertEqual(branchId.isRequired, false, "Should not be required")
            XCTAssertEqual(branchId.isEditable, true, "Should be editable")
            XCTAssertEqual(branchId.value, "1234", "Should not be required")
            XCTAssertEqual(branchId.label, "Routing Number", "Invalid label")
            XCTAssertEqual(branchId.placeholder, "", "Invalid placeholder")
            XCTAssertEqual(branchId.regularExpression, "^[0-9]{9}$", "Invalid regularExpression")
            XCTAssertEqual(branchId.maxLength, 9, "The maxLength should not be nil")
            XCTAssertEqual(branchId.minLength, 9, "The minLength should not be nil")
            XCTAssertNotNil(branchId.validationMessage, "Validation Messages should not be nil")
            XCTAssertEqual(branchId.validationMessage?.length,
                           "The exact length of this field is 9.",
                           "Invalid message")
            XCTAssertEqual(branchId.validationMessage?.empty,
                           "You must provide a value for this field",
                           "Invalid message")
            XCTAssertEqual(branchId.validationMessage?.pattern, "abaCode is invalid format.", "Invalid message")
        } else {
            XCTFail("The field name bankId has not been found")
        }

        // Assert Field bankAccountId
        let fieldsFilterByBankAccountId = fields.filter { $0.name == "bankAccountId" }
        if let branchId = fieldsFilterByBankAccountId.first {
            XCTAssertEqual(branchId.name, "bankAccountId", "Invalid name")
            XCTAssertEqual(branchId.category, "ACCOUNT", "Invalid category")
            XCTAssertEqual(branchId.dataType, "NUMBER", "Invalid dataType")
            XCTAssertEqual(branchId.isRequired, true, "Should be required")
            XCTAssertEqual(branchId.isEditable, false, "Should not be editable")
            XCTAssertEqual(branchId.regularExpression, "^(?![0-]+$)[0-9-]{4,17}$", "Invalid regularExpression")
            XCTAssertEqual(branchId.maxLength, 17, "The maxLength should not be nil")
            XCTAssertEqual(branchId.minLength, 4, "The minLength should not be nil")
            XCTAssertNotNil(branchId.validationMessage, "Validation Messages should not be nil")
            XCTAssertEqual(branchId.validationMessage?.length,
                           "The minimum length of this field is 4 and maximum length is 17.",
                           "Invalid message")
            XCTAssertEqual(branchId.validationMessage?.empty,
                           "You must provide a value for this field",
                           "Invalid message")
            XCTAssertEqual(branchId.validationMessage?.pattern,
                           "accountNumber is invalid format.",
                           "Invalid message")
        } else {
            XCTFail("The field name bankAccountId has not been found")
        }
    }

    private func assertCurrencies(_ result: TransferMethodConfigurationResult,
                                  from country: String,
                                  amount: Int) {
        let currencies = result.currencies(from: country)
        XCTAssertEqual(currencies.count, amount, "The amount of elements is different")
    }

    private static func hyperwalletGraphQlResult(data: Data) -> Connection<TransferMethodConfiguration>? {
        let decoder = JSONDecoder()

        let graphQlResult = try! decoder.decode(GraphQlResult<Connection<TransferMethodConfiguration>>.self,
                                                from: data)
        return graphQlResult.data?["transferMethodConfigurations"]
    }
}
