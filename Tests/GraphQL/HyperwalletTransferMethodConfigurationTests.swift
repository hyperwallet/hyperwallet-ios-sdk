import Hippolyte
@testable import HyperwalletSDK
import XCTest

// swiftlint:disable multiline_arguments
class HyperwalletTransferMethodConfigurationTests: XCTestCase {
    override func setUp() {
        Hyperwallet.setup(HyperwalletTestHelper.authenticationProvider)
    }

    override func tearDown() {
        if Hippolyte.shared.isStarted {
            Hippolyte.shared.stop()
        }
    }

    // swiftlint:disable function_body_length
    func testRetrieveTransferMethodConfigurationKeys_success() {
        // Given
        let request = setUpTransferMethodConfigurationRequest("TransferMethodConfigurationKeysResponse")
        HyperwalletTestHelper.setUpMockServer(request: request)

        let expectation = self.expectation(description: "Retrieve transfer method configuration keys")

        var graphQlResponse: HyperwalletTransferMethodConfigurationKey?
        var errorResponse: HyperwalletErrorType?

        // When
        let keysQuery = HyperwalletTransferMethodConfigurationKeysQuery()

        Hyperwallet.shared.retrieveTransferMethodConfigurationKeys(request: keysQuery,
                                                                   completion: { (result, error) in
                                                                    graphQlResponse = result
                                                                    errorResponse = error
                                                                    expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertEqual(graphQlResponse?.countries()?.count, 4, "countries()` should be 4")
        XCTAssertEqual(graphQlResponse?.currencies(from: "CA")?.count, 2, "currencies(...)` should be 2")
        XCTAssertEqual(graphQlResponse?.transferMethodTypes(countryCode: "CA", currencyCode: "CAD")?
                                       .count, 2, "`transferMethodTypes(...)` should be 2")
    }

    func testRetrieveTransferMethodConfigurationKeys_withoutFees() {
        // Given
        let request = setUpTransferMethodConfigurationRequest("TransferMethodConfigurationKeysWithoutFeeResponse")
        HyperwalletTestHelper.setUpMockServer(request: request)

        let expectation = self.expectation(description: "Retrieve transfer method configuration keys")
        var errorResponse: HyperwalletErrorType?
        var fees: [HyperwalletFee]?
        var graphQlResponse: HyperwalletTransferMethodConfigurationKey?
        // When
        let keysQuery = HyperwalletTransferMethodConfigurationKeysQuery(limit: 10)

        Hyperwallet.shared.retrieveTransferMethodConfigurationKeys(request: keysQuery,
                                                                   completion: { (result, error) in
                                                                    graphQlResponse = result
                                                                    errorResponse = error
                                                                    expectation.fulfill()
        })

        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "Error response should be nil" )
        fees = graphQlResponse?.transferMethodTypes(countryCode: "HR", currencyCode: "HRK")?
                               .first(where: { $0.code == "BANK_ACCOUNT" })
                               .flatMap { $0.fees?.nodes }

        XCTAssertNil(fees, "Fees should be nil" )
        XCTAssertEqual(graphQlResponse?.countries()?.count, 1, "`countries()` should be 1")
        XCTAssertEqual(graphQlResponse?.currencies(from: "HR")?.count, 1, "currencies(...)` should be 1")
        XCTAssertEqual(graphQlResponse?.transferMethodTypes(countryCode: "HR", currencyCode: "HRK")?
                                       .count, 1, "transferMethodTypes(...)` should be 1")
    }

    func testRetrieveTransferMethodConfigurationFields_success() {
        // Given
        let request = setUpTransferMethodConfigurationRequest("TransferMethodConfigurationFieldsResponse")
        HyperwalletTestHelper.setUpMockServer(request: request)

        let expectation = self.expectation(description: "Retrieve transfer method configuration fields")

        var graphQlResponse: HyperwalletTransferMethodConfigurationField?
        var errorResponse: HyperwalletErrorType?
        // When
        let fieldQuery = HyperwalletTransferMethodConfigurationFieldQuery(country: "AR",
                                                                          currency: "ARS",
                                                                          transferMethodType: "BANK_ACCOUNT",
                                                                          profile: "INDIVIDUAL")

        Hyperwallet.shared.retrieveTransferMethodConfigurationFields(request: fieldQuery,
                                                                     completion: { (result, error) in
                                                                     graphQlResponse = result
                                                                     errorResponse = error
                                                                     expectation.fulfill()
        })

        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(graphQlResponse)
        XCTAssertEqual(graphQlResponse?.fieldGroups()?.count, 2, "`fieldGroups()` should be 2")
        let fees = graphQlResponse?.transferMethodType()?.fees?.nodes
        XCTAssertNotNil(fees)
        XCTAssertEqual(fees?.count, 1)
        XCTAssertEqual(fees?.first?.feeRateType, "FLAT")
        XCTAssertEqual(fees?.first?.value, "2.00")
        let bankAccountIdMask = graphQlResponse?.fieldGroups()?
            .first(where: { $0.group == "ACCOUNT_INFORMATION" })?.fields?
            .first(where: { $0.name == "bankAccountId" })?.mask
        XCTAssertNotNil(bankAccountIdMask)
        XCTAssertEqual(bankAccountIdMask?.defaultPattern, "#####-####")
        XCTAssertEqual(bankAccountIdMask?.scrubRegex, "\\-")
        let branchIdMask = graphQlResponse?.fieldGroups()?
            .first(where: { $0.group == "ACCOUNT_INFORMATION" })?.fields?
            .first(where: { $0.name == "branchId" })?.mask
        XCTAssertNotNil(branchIdMask)
        XCTAssertEqual(branchIdMask?.conditionalPatterns?.count, 2)
        XCTAssertEqual(branchIdMask?.conditionalPatterns?.first?.pattern, "# ###### ##")
        XCTAssertEqual(branchIdMask?.conditionalPatterns?.first?.regex, "^4")
        XCTAssertEqual(branchIdMask?.conditionalPatterns?.last?.pattern, "## #######")
        XCTAssertEqual(branchIdMask?.conditionalPatterns?.last?.regex, "^5[1-5]")
        XCTAssertEqual(branchIdMask?.defaultPattern, "#####.###.#")
        XCTAssertEqual(branchIdMask?.scrubRegex, "\\s")
    }

    func testRetrieveTransferMethodConfigurationFeeAndProcessingTime_success() {
        // Given
        let request = setUpTransferMethodConfigurationRequest("TransferMethodConfigurationFeeAndProcessingTimeResponse")
        HyperwalletTestHelper.setUpMockServer(request: request)

        let expectation = self.expectation(description: "Retrieve transfer method configuration keys")

        var graphQlResponse: HyperwalletTransferMethodConfigurationKey?
        var errorResponse: HyperwalletErrorType?
        var fees: [HyperwalletFee]?
        var flatFee: HyperwalletFee?
        var percentFee: HyperwalletFee?
        var bankAccountProcessingTime: HyperwalletProcessingTime?
        var paperCheckProcessingTime: HyperwalletProcessingTime?

        // When
        let keysQuery = HyperwalletTransferMethodConfigurationFeeAndProcessingTimeQuery(country: "CA", currency: "CAD")

        Hyperwallet.shared
            .retrieveFeeAndProcessingTime(request: keysQuery,
                                                                            completion: { (result, error) in
                                                                                graphQlResponse = result
                                                                                errorResponse = error
                                                                                expectation.fulfill()
                                                                            })
        wait(for: [expectation], timeout: 1)

        print(graphQlResponse?.transferMethodTypes(countryCode: "CA", currencyCode: "CAD") ?? "")

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertEqual(graphQlResponse?.countries()?.count, 1, "countries()` should be 1")
        XCTAssertEqual(graphQlResponse?.currencies(from: "CA")?.count, 1, "currencies(...)` should be 1")
        XCTAssertEqual(graphQlResponse?.transferMethodTypes(countryCode: "CA", currencyCode: "CAD")?
                                       .count, 2, "`transferMethodTypes(...)` should be 2")
        fees = graphQlResponse?.transferMethodTypes(countryCode: "CA", currencyCode: "CAD")?
                               .first(where: { $0.code == "BANK_ACCOUNT" })
                               .flatMap { $0.fees?.nodes }
        flatFee = fees?.first
        percentFee = fees?.last

        XCTAssertNotNil(fees)
        XCTAssertEqual(fees?.count, 2)
        XCTAssertEqual(flatFee?.value, "2.20")
        XCTAssertEqual(flatFee?.feeRateType, "FLAT")
        XCTAssertEqual(percentFee?.value, "8.9")
        XCTAssertEqual(percentFee?.feeRateType, "PERCENT")
        XCTAssertEqual(percentFee?.minimum, "0.05")
        XCTAssertEqual(percentFee?.maximum, "1.00")

        bankAccountProcessingTime = graphQlResponse?.transferMethodTypes(countryCode: "CA", currencyCode: "CAD")?
            .first(where: { $0.code == "BANK_ACCOUNT" })
            .flatMap { $0.processingTimes?.nodes?.first }
        XCTAssertNotNil(bankAccountProcessingTime, "The bankAccountProcessingTime should not be nil")
        XCTAssertEqual(bankAccountProcessingTime!.value,
                       "1 - 3 Business days",
                       "Type should be 1 - 3 Business days")
        XCTAssertEqual(bankAccountProcessingTime!.country,
                       "CA",
                       "The country should be CA")
        XCTAssertEqual(bankAccountProcessingTime!.currency,
                       "CAD",
                       "The currency should be CAD")
        XCTAssertEqual(bankAccountProcessingTime!.transferMethodType,
                       "BANK_ACCOUNT",
                       "The transferMethodType should be BANK_ACCOUNT")

        paperCheckProcessingTime = graphQlResponse?.transferMethodTypes(countryCode: "CA", currencyCode: "CAD")?
            .first(where: { $0.code == "PAPER_CHECK" })
            .flatMap { $0.processingTimes?.nodes?.first }
        XCTAssertNotNil(paperCheckProcessingTime, "The payPalAccountProcessingTime should not be nil")
        XCTAssertEqual(paperCheckProcessingTime!.value,
                       "5 - 7 Business days",
                       "The value should be 5 - 7 Business days")
        XCTAssertEqual(paperCheckProcessingTime!.country,
                       "CA",
                       "The country should be CA")
        XCTAssertEqual(paperCheckProcessingTime!.currency,
                       "CAD",
                       "The currency should be CAD")
        XCTAssertEqual(paperCheckProcessingTime!.transferMethodType,
                       "PAPER_CHECK",
                       "The transferMethodType should be PAPER_CHECK")
    }

    private func setUpTransferMethodConfigurationRequest(_ responseFile: String,
                                                         _ error: NSError? = nil) -> StubRequest {
        let data = HyperwalletTestHelper.getDataFromJson(responseFile)
        return HyperwalletTestHelper.buildPostRequest(baseUrl: HyperwalletTestHelper.graphQlURL,
                                                      HyperwalletTestHelper.setUpMockedResponse(payload: data,
                                                                                                error: error))
    }
}
