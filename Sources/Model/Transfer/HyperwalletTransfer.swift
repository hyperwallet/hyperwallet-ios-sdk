//
// Copyright 2018 - Present Hyperwallet
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software
// and associated documentation files (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge, publish, distribute,
// sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
// BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Foundation

public struct HyperwalletTransfer: Codable {
    public struct HyperwalletForeignExchange: Codable {
        let desgtinationAmount: String
        let destinationCurrency: String
        let rate: String
        let sourceAmount: String
        let sourceCurrency: String
    }

    public enum HyperwalletTransferStatus: String, Codable {
        case cancelled              = "CANCELLED"
        case completed              = "COMPLETED"
        case expired                = "EXPIRED"
        case failed                 = "FAILED"
        case inProgress             = "IN_PROGRESS"
        case quoted                 = "QUOTED"
        case returned               = "RETURNED"
        case scheduled              = "SCHEDULED"
        case verificationRequired   = "VERIFICATION_REQUIRED"
    }

    public let clientTransferId: String

    public let createdOn: String?

    public let destinationAmount: String

    public let destinationCurrency: String

    public let destinationToken: String

    public let expiresOn: String?

    public let foreignExchanges: [HyperwalletForeignExchange]?

    public let memo: String?

    public let notes: String?

    public let sourceAmount: String?

    public let sourceCurrency: String?

    public let sourceToken: String

    public let status: HyperwalletTransferStatus?

    public let token: String?

    /// Creates a new instance of the `HyperwalletTransfer` based on the parameters to create
    /// transfer.
    ///
    /// - Parameters:
    ///   - clientTransferId: A client defined transfer identifier.
    ///     This is the unique ID assigned to the transfer on your system. Max 50 characters.
    ///   - createdOn: The datetime the status changed in `ISO 8601` format (YYYY-MM-DDThh:mm:ss).
    ///     Note that the timezone used is UTC, therefore there is no time offset.
    ///   - destinationAmount: The payment amount in the specified currency loaded into your merchant account.
    ///   - destinationCurrency: The currency of the payment amount loaded into your merchant account
    ///     in `ISO 4217` format.
    ///   - destinationToken: A token identifying where the funds have been sent.
    ///     It is your merchant account token prefixed with `act-`.
    ///   - expiresOn: The date and time which the created transfer expires.
    ///     The REST API user (Payer) has 120 seconds from the creation time to complete the transfer,
    ///     otherwise the created transfer expires and payer needs to re-initiate the transfer. (YYYY-MMDDThh:mm:ss).
    ///   - foreignExchanges: An array of foreign exchange transactions.
    ///     A transfer could have more than one foreign exchange transaction.
    ///   - memo: An internal memo for the SpendBack transfer (will not be visible to the user making the payment).
    ///   - notes: A description for the SpendBack transfer.
    ///   - sourceAmount: The payment amount in the specified currency that is debited from the sourceToken.
    ///   - sourceCurrency: The currency of the payment amount debited from the sourceToken in in `ISO 4217` format.
    ///     Required if more than one currency option is available for partial balance transfers.
    ///   - sourceToken: A token identifying the source of funds.
    ///     It can be a prepaid card token prefixed with `trm-` or user token prefixed with `usr-`.
    ///   - status: The transfer status. The only possible value returned is: `QUOTED`.
    ///   - token: The unique, auto-generated transfer identifier. Max 64 characters, prefixed with `trf-`.
    public init(clientTransferId: String,
                createdOn: String? = nil,
                destinationAmount: String,
                destinationCurrency: String,
                destinationToken: String,
                expiresOn: String? = nil,
                foreignExchanges: [HyperwalletForeignExchange]? = nil,
                memo: String? = nil,
                notes: String? = nil,
                sourceAmount: String? = nil,
                sourceCurrency: String? = nil,
                sourceToken: String,
                status: HyperwalletTransferStatus? = nil,
                token: String? = nil) {
        self.clientTransferId = clientTransferId
        self.createdOn = createdOn
        self.destinationAmount = destinationAmount
        self.destinationCurrency = destinationCurrency
        self.destinationToken = destinationToken
        self.expiresOn = expiresOn
        self.foreignExchanges = foreignExchanges
        self.memo = memo
        self.notes = notes
        self.sourceAmount = sourceAmount
        self.sourceCurrency = sourceCurrency
        self.sourceToken = sourceToken
        self.status = status
        self.token = token
    }
}
