@testable import HyperwalletSDK
import XCTest

//swiftlint:disable force_try
class TransferMethodConfigurationKeyResultTests: XCTestCase {
    var transferMethodConfigurationKey: TransferMethodConfigurationKey!
    var keyResult: TransferMethodConfigurationKeyResult!

    override func setUp() {
        transferMethodConfigurationKey = hyperwalletGraphQlKey(data:
            HyperwalletTestHelper.getDataFromJson("TransferMethodConfigurationKeysResponse"))!
        keyResult = TransferMethodConfigurationKeyResult(transferMethodConfigurationKey.countries.nodes)
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

        XCTAssertNotNil(keyFees)
        XCTAssertEqual(keyFees?.last?.feeRateType, "PERCENT", "Type should be PERCENT")
    }

    func testFees_empty() {
        let keyFees = keyResult.transferMethodTypes(countryCode: "HR", currencyCode: "HRK")?.first?.fees?.nodes
        XCTAssertNil(keyFees)
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
}
