@testable import HyperwalletSDK
import XCTest

//swiftlint:disable force_cast force_try
class AnyCodableTests: XCTestCase {
    func testEncode() {
        // Given
        let bankAccount = HyperwalletBankAccount
            .Builder(transferMethodCountry: "US",
                     transferMethodCurrency: "USD",
                     transferMethodProfileType: "INDIVIDUAL",
                     transferMethodType: "BANK_ACCOUNT")
                     .bankAccountId("12345")
                     .branchId("123456")
                     .bankAccountPurpose(.checking)
            .build()

        // When
        let jsonBody = try! JSONEncoder().encode(bankAccount)

        // Then
        XCTAssertNotNil(jsonBody)
        let jsonBodyString = String(data: jsonBody, encoding: .utf8)!
        XCTAssertTrue(((jsonBodyString.contains("USD"))))
    }

    func testDecode() {
        // Given
        let jsonBody = HyperwalletTestHelper.getDataFromJson("BankAccountIndividualResponse")

        // When
        let decoder = JSONDecoder()
        let bankAccount = try! decoder.decode(HyperwalletBankAccount.self, from: jsonBody)

        // Then
        XCTAssertNotNil(bankAccount)
        XCTAssertEqual(bankAccount.token, "trm-12345")
        let links = bankAccount.getFields()["links"]!.value as! [Any]
        XCTAssertNotNil(links)
        XCTAssertNotNil(links.first)
    }

    func testEncode_supportedPrimitiveTypes() {
        // Given
        let data: [String: AnyCodable] = [
            "stringVal": AnyCodable(value: "String"),
            "intVal": AnyCodable(value: 1),
            "doubleVal": AnyCodable(value: 1.2),
            "boolVal": AnyCodable(value: false)
        ]

        // When
        let jsonBody = try! JSONEncoder().encode(data)

        // Then
        XCTAssertNotNil(jsonBody)
    }

    func testEncode_unsupportedType() {
        let data: [String: AnyCodable] = [
            "int64Val": AnyCodable(value: Int64(100))
        ]

        XCTAssertThrowsError(try JSONEncoder().encode(data)) { error in
            XCTAssertEqual((error as! HyperwalletErrorType).getHyperwalletErrors()?.errorList?.first?.code,
                           "PARSE_ERROR")
        }
    }

    func testDecode_arraySupportedTypes() {
        // Given
        let jsonBody = "[1, \"String\", 1.2, true, null]".data(using: .utf8)!

        // When
        let result = try! JSONDecoder().decode(Array<AnyCodable>.self, from: jsonBody)

        // Then
        XCTAssertNotNil(result)
        XCTAssertNotNil(result[0].value as! Int, "1")
        XCTAssertNotNil(result[1].value as! String, "String")
        XCTAssertNotNil(result[2].value as! Double, "1.2")
        XCTAssertNotNil(result[3].value as! Bool, "true")
        XCTAssertNotNil(result[4].value as! String, "") // null
    }
}
