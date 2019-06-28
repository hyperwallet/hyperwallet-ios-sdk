import Hippolyte
@testable import HyperwalletSDK
import XCTest

class HyperwalletTransferTests: XCTestCase {
    override func setUp() {
        Hyperwallet.setup(HyperwalletTestHelper.authenticationProvider)
    }

    override func tearDown() {
        if Hippolyte.shared.isStarted {
            Hippolyte.shared.stop()
        }
    }

    func testCreateTransfer_success() {
        // Given
        let expectation = self.expectation(description: "Create transfer completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "CreateTransferResponse")
        let url = String(format: "%@/transfers", HyperwalletTestHelper.restURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var transferResponse: HyperwalletTransfer?
        var errorResponse: HyperwalletErrorType?

        // When
        let transferRequest = HyperwalletTransfer(clientTransferId: "6712348070812",
                                                  destinationAmount: "62.29",
                                                  destinationCurrency: "USD",
                                                  destinationToken: "trm-123456",
                                                  sourceToken: "usr-123456")

        Hyperwallet.shared.createTransfer(transfer: transferRequest, completion: { (result, error) in
            transferResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(transferResponse, "The `transferResponse` should not be nil")
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")

        verifyTransferResponse(transferResponse)
    }

    func testCreateTransfer_invalidDestinationToken_returnBadRequest() {
        // Given
        let expectation = self.expectation(description: "Create transfer failed")
        let response = HyperwalletTestHelper
            .badRequestHTTPResponse(for: "CreateTransferResponseInvalidDestinationToken")
        let url = String(format: "%@/transfers", HyperwalletTestHelper.restURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var transferResponse: HyperwalletTransfer?
        var errorResponse: HyperwalletErrorType?

        // When
        let transferRequest = HyperwalletTransfer(clientTransferId: "6712348070812",
                                                  destinationAmount: "62.29",
                                                  destinationCurrency: "USD",
                                                  destinationToken: "trm-invaqlid-token",
                                                  sourceToken: "usr-123456")

        Hyperwallet.shared.createTransfer(transfer: transferRequest, completion: { (result, error) in
            transferResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(transferResponse, "The `transferResponse` should be nil")
        XCTAssertNotNil(errorResponse, "The `errorResponse` should not be nil")
        XCTAssertEqual(errorResponse?.getHttpCode(), 400, "The `httpCode` should be 400")
        XCTAssertEqual(errorResponse?.getHyperwalletErrors()?.errorList?.first?.code,
                       "INVALID_DESTINATION_TOKEN",
                       "The `errorCode` should be `INVALID_DESTINATION_TOKEN`")
    }

    func testGetTransfer_success() {
        // Given
        let expectation = self.expectation(description: "Get transfer completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "CreateTransferResponse")
        let url = String(format: "%@/transfers/trf-123456", HyperwalletTestHelper.restURL)
        let request = HyperwalletTestHelper.buildGetRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var transferResponse: HyperwalletTransfer?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.getTransfer(transferToken: "trf-123456", completion: { (result, error) in
            transferResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(transferResponse, "The `transferResponse` should not be nil")
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        verifyTransferResponse(transferResponse)
        XCTAssertEqual(transferResponse?.token, "trf-123456")
    }

    func testScheduleTransfer_success() {
        //Given
        let expectation = self.expectation(description: "Schedule transfer completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "ScheduleTransferResponse")
        let url = String(format: "%@/transfers/trf-123456/status-transitions", HyperwalletTestHelper.restURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var statusTransitionResponse: HyperwalletStatusTransition?
        var errorResponse: HyperwalletErrorType?

        //When
        Hyperwallet.shared.scheduleTransfer(transferToken: "trf-123456", completion: { (result, error) in
            statusTransitionResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        //Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(statusTransitionResponse, "The `statusTransitionResponse` should not be nil")
        verifyStatusTransitionResponse(statusTransitionResponse)
    }
}

private extension HyperwalletTransferTests {
    func verifyTransferResponse(_ response: HyperwalletTransfer?) {
        XCTAssertNotNil(response, "The `response` should be not nil")
        //Mandatory fields
        XCTAssertEqual(response?.clientTransferId, "6712348070812", "The `clientTransferId` should be 6712348070812")
        XCTAssertEqual(response?.destinationAmount, "62.29", "The `destinationAmount` should be 62.29")
        XCTAssertEqual(response?.destinationCurrency, "USD", "The `destinationCurrency` should be USD")
        XCTAssertEqual(response?.destinationToken, "trm-123456", "The `destinationToken` should be trm-123456")
        XCTAssertEqual(response?.sourceToken, "usr-123456", "The `sourceToken` should be usr-123456")
        //Optional fields
        XCTAssertEqual(response?.sourceAmount, "80", "The `sourceAmount` should be 80")
        XCTAssertEqual(response?.sourceCurrency, "CAD", "The `sourceCurrency` should be CAD")

        let foreignExchange = response?.foreignExchanges?.first

        XCTAssertNotNil(foreignExchange, "The `foreignExchange` should be not nil")
        XCTAssertEqual(foreignExchange?.sourceCurrency, "CAD", "The `sourceCurrency` should be CAD")
        XCTAssertEqual(foreignExchange?.sourceAmount, "100.00", "The `sourceAmount` should be 100.00")
        XCTAssertEqual(foreignExchange?.destinationAmount, "63.49", "The `destinationAmount` should be 63.49")
        XCTAssertEqual(foreignExchange?.destinationCurrency, "USD", "The `destinationCurrency` should be USD")
        XCTAssertEqual(foreignExchange?.rate, "0.79", "The `rate` should be 0.79")
    }

    func verifyStatusTransitionResponse(_ response: HyperwalletStatusTransition?) {
        XCTAssertEqual(response?.token, "sts-123456", "The `token` should be sts-123456")
        XCTAssertEqual(response?.transition.rawValue,
                       HyperwalletStatusTransition.Status.scheduled.rawValue,
                       "The `transition` should be SCHEDULED")
        XCTAssertEqual(response?.fromStatus.rawValue,
                       HyperwalletStatusTransition.Status.quoted.rawValue,
                       "The `fromStatus` should be QUOTED")
        XCTAssertEqual(response?.toStatus.rawValue,
                       HyperwalletStatusTransition.Status.scheduled.rawValue,
                       "The `toStatus` should be SCHEDULED")
    }
}
