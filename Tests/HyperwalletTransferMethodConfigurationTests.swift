import Hippolyte
@testable import HyperwalletSDK
import XCTest

//swiftlint:disable multiline_arguments
class HyperwalletTransferMethodConfigurationTests: XCTestCase {
    override func setUp() {
        Hyperwallet.setup(HyperwalletTestHelper.authenticationProvider)
    }

    override func tearDown() {
        if Hippolyte.shared.isStarted {
            Hippolyte.shared.stop()
        }
    }

    func testRetrieveTransferMethodConfigurationKeys_success() {
        // Given
        let request = setUpTransferMethodConfigurationKeysRequest("TransferMethodConfigurationKeysResponse")
        HyperwalletTestHelper.setUpMockServer(request: request)

        let expectation = self.expectation(description: "Retrieve transfer method configuration keys")

        var graphQlResponse: HyperwalletTransferMethodConfigurationKey?
        var errorResponse: HyperwalletErrorType?
        var fees: [HyperwalletFee]?
        var flatFee: HyperwalletFee?
        var percentFee: HyperwalletFee?
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
        XCTAssertEqual(graphQlResponse?.transferMethodTypes(country: "CA", currency: "CAD")?
            .count, 2, "transferMethodTypes(...)` should be 2")
        fees = graphQlResponse?.transferMethodTypes(country: "CA", currency: "CAD")?
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
    }

    func testRetrieveTransferMethodConfigurationKeys_withoutFees() {
        // Given
        let request = setUpTransferMethodConfigurationKeysRequest("TransferMethodConfigurationKeysWithoutFeeResponse")
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
        fees = graphQlResponse?.transferMethodTypes(country: "HR", currency: "HRK")?
            .first(where: { $0.code == "BANK_ACCOUNT" })
            .flatMap { $0.fees?.nodes }

        XCTAssertNil(fees, "Fees should be nil" )
        XCTAssertEqual(graphQlResponse?.countries()?.count, 1, "countries()` should be 1")
        XCTAssertEqual(graphQlResponse?.currencies(from: "HR")?.count, 1, "currencies(...)` should be 1")
        XCTAssertEqual(graphQlResponse?.transferMethodTypes(country: "HR", currency: "HRK")?
            .count, 1, "transferMethodTypes(...)` should be 1")
    }

        func testRetrieveTransferMethodConfigurationFields_success() {
            // Given
            let request = setUpTransferMethodConfigurationKeysRequest("TransferMethodConfigurationFieldsResponse")
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
        }

    private func setUpTransferMethodConfigurationKeysRequest(_ responseFile: String,
                                                             _ error: NSError? = nil) -> StubRequest {
        let data = HyperwalletTestHelper.getDataFromJson(responseFile)
        return HyperwalletTestHelper
            .buildPostResquest(baseUrl: HyperwalletTestHelper.graphQlURL,
                               HyperwalletTestHelper.setUpMockedResponse(payload: data, error: error))
    }
}
