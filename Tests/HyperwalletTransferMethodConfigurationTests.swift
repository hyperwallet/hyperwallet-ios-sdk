//TODO fix tests
//import Hippolyte
//@testable import HyperwalletSDK
//import XCTest
//
////swiftlint:disable multiline_arguments
//class HyperwalletTransferMethodConfigurationTests: XCTestCase {
//    override func setUp() {
//        Hyperwallet.setup(HyperwalletTestHelper.authenticationProvider)
//    }
//
//    override func tearDown() {
//        if Hippolyte.shared.isStarted {
//            Hippolyte.shared.stop()
//        }
//    }
//
//   func testRetrieveTransferMethodConfigurationKeys_success() {
//        // Given
//        let request = setUpTransferMethodConfigurationKeysRequest("TransferMethodConfigurationKeysResponse")
//        HyperwalletTestHelper.setUpMockServer(request: request)
//
//        let expectation = self.expectation(description: "Retrieve transfer method configuration keys")
//
//        var graphQlResponse: HyperwalletTransferMethodConfigurationKeyResult?
//        var errorResponse: HyperwalletErrorType?
//        var processingTime: String?
//        var fees: [HyperwalletFee]?
//        var percentFees: [HyperwalletFee]?
//        // When
//        let keysQuery = HyperwalletTransferMethodConfigurationKeysQuery()
//
//        Hyperwallet.shared.retrieveTransferMethodConfigurationKeys(request: keysQuery,
//                                                                   completion: { (result, error) in
//                                                                    graphQlResponse = result
//                                                                    errorResponse = error
//                                                                    expectation.fulfill()
//        })
//        wait(for: [expectation], timeout: 1)
//
//        // Then
//        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
//        XCTAssertEqual(graphQlResponse?.countries().count, 5, "countries()` should be 5")
//        XCTAssertEqual(graphQlResponse?.currencies(from: "US").count, 2, "currencies(...)` should be 2")
//        XCTAssertEqual(graphQlResponse?.transferMethodTypes(country: "US", currency: "USD", profileType: "INDIVIDUAL")
//            .count, 3, "transferMethodTypes(...)` should be 3")
//        processingTime = graphQlResponse?.processingTime(country: "US",
//                                                         currency: "USD",
//                                                         profileType: "INDIVIDUAL",
//                                                         transferMethodType: "BANK_ACCOUNT")
//        XCTAssertNotNil(processingTime)
//        XCTAssertEqual(processingTime, "1-3 Business days", "processingTime should be 1-3 Business days")
//
//        fees = graphQlResponse?.fees(country: "US",
//                                     currency: "USD",
//                                     profileType: "INDIVIDUAL",
//                                     transferMethodType: "BANK_ACCOUNT")
//        XCTAssertNotNil(fees)
//        percentFees = graphQlResponse?.fees(country: "US",
//                                            currency: "USD",
//                                            profileType: "BUSINESS",
//                                            transferMethodType: "BANK_CARD")
//        XCTAssertNotNil(percentFees)
//    }
//
//    func testRetrieveTransferMethodConfigurationKeys_withoutFees() {
//        // Given
//        let request = setUpTransferMethodConfigurationKeysRequest("TransferMethodConfigurationKeysWithoutFeeResponse")
//        HyperwalletTestHelper.setUpMockServer(request: request)
//
//        let expectation = self.expectation(description: "Retrieve transfer method configuration keys")
//        var errorResponse: HyperwalletErrorType?
//        var fees: [HyperwalletFee]?
//        var graphQlResponse: HyperwalletTransferMethodConfigurationKeyResult?
//        // When
//        let keysQuery = HyperwalletTransferMethodConfigurationKeysQuery(limit: 10)
//
//        Hyperwallet.shared.retrieveTransferMethodConfigurationKeys(request: keysQuery,
//                                                                   completion: { (result, error) in
//                                                                    graphQlResponse = result
//                                                                    errorResponse = error
//                                                                    expectation.fulfill()
//        })
//
//        wait(for: [expectation], timeout: 1)
//
//        // Then
//        XCTAssertNil(errorResponse, "Error response should be nil" )
//        fees = graphQlResponse?.fees(country: "CA",
//                                     currency: "USD",
//                                     profileType: "INDIVIDUAL",
//                                     transferMethodType: "BANK_ACCOUNT")
//        XCTAssertNil(fees, "Fees should be nil" )
//        XCTAssertEqual(graphQlResponse?.countries().count, 1, "countries()` should be 1")
//        XCTAssertEqual(graphQlResponse?.currencies(from: "CA").count, 1, "currencies(...)` should be 1")
//        XCTAssertEqual(graphQlResponse?.transferMethodTypes(country: "CA", currency: "USD", profileType: "INDIVIDUAL")
//            .count, 1, "transferMethodTypes(...)` should be 1")
//    }
//
//    func testRetrieveTransferMethodConfigurationFields_success() {
//        // Given
//        let request = setUpTransferMethodConfigurationKeysRequest("TransferMethodConfigurationFieldsResponse")
//        HyperwalletTestHelper.setUpMockServer(request: request)
//
//        let expectation = self.expectation(description: "Retrieve transfer method configuration fields")
//
//        var graphQlResponse: HyperwalletTransferMethodConfigurationFieldResult?
//        var errorResponse: HyperwalletErrorType?
//        // When
//        let fieldQuery = HyperwalletTransferMethodConfigurationFieldQuery(country: "AR",
//                                                                          currency: "ARS",
//                                                                          transferMethodType: "BANK_ACCOUNT",
//                                                                          profile: "INDIVIDUAL")
//
//        Hyperwallet.shared.retrieveTransferMethodConfigurationFields(request: fieldQuery,
//                                                                     completion: { (result, error) in
//                                                                     graphQlResponse = result
//                                                                     errorResponse = error
//                                                                     expectation.fulfill()
//        })
//
//        wait(for: [expectation], timeout: 1)
//
//        // Then
//        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
//        XCTAssertNotNil(graphQlResponse)
//        XCTAssertEqual(graphQlResponse?.fields().count, 3, "fields()` should be 3")
//        let processingTime = graphQlResponse?.processingTime(country: "US",
//                                                             currency: "USD",
//                                                             profileType: "INDIVIDUAL",
//                                                             transferMethodType: "BANK_ACCOUNT")
//        XCTAssertNotNil(processingTime)
//        let fees = graphQlResponse?.fees(country: "US",
//                                         currency: "USD",
//                                         profileType: "INDIVIDUAL",
//                                         transferMethodType: "BANK_ACCOUNT")
//        XCTAssertNotNil(fees)
//    }
//
//    private func setUpTransferMethodConfigurationKeysRequest(_ responseFile: String,
//                                                             _ error: NSError? = nil) -> StubRequest {
//        let data = HyperwalletTestHelper.getDataFromJson(responseFile)
//        return HyperwalletTestHelper
//            .buildPostResquest(baseUrl: HyperwalletTestHelper.graphQlURL,
//                               HyperwalletTestHelper.setUpMockedResponse(payload: data, error: error))
//    }
//}
