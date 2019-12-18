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

/// Representation of a `HyperwalletForeignExchange`
public struct HyperwalletForeignExchange: Codable {
    /// The destination amount
    public let destinationAmount: String?
    /// The destination currency
    public let destinationCurrency: String?
    /// The rate
    public let rate: String?
    /// The source amount
    public let sourceAmount: String?
    /// The source currency
    public let sourceCurrency: String?
}
/// Representation of a `HyperwalletTransfer`
public struct HyperwalletTransfer: Codable {
    /// A value that identifies the client transfer id.
    public let clientTransferId: String
    /// The created date
    public let createdOn: String?
    /// The destination amount
    public let destinationAmount: String?
    /// The destination currency
    public let destinationCurrency: String?
    /// The destination amount
    public let destinationFeeAmount: String?
    /// The destination token
    public let destinationToken: String
    /// The expiresOn
    public let expiresOn: String?
    /// The list of foreignExchanges
    public let foreignExchanges: [HyperwalletForeignExchange]?
    /// The memo
    public let memo: String?
    /// The notes to add
    public let notes: String?
    /// The source amount
    public let sourceAmount: String?
    /// The source currency
    public let sourceCurrency: String?
    /// The source fee
    public let sourceFeeAmount: String?
    /// The source token
    public let sourceToken: String
    /// The transfer status
    public let status: HyperwalletTransferStatus?
    /// The  token
    public let token: String?
    /// Representation of a `HyperwalletTransferStatus`
    public enum HyperwalletTransferStatus: String, Codable {
        /// The transfer status is cancelled
        case cancelled              = "CANCELLED"
        /// The transfer status is completed
        case completed              = "COMPLETED"
        /// The transfer status is expired
        case expired                = "EXPIRED"
        /// The transfer status is failed
        case failed                 = "FAILED"
        /// The transfer status is in Progress
        case inProgress             = "IN_PROGRESS"
        /// The transfer status is quoted
        case quoted                 = "QUOTED"
        /// The transfer status is returned
        case returned               = "RETURNED"
        /// The transfer status is scheduled
        case scheduled              = "SCHEDULED"
        /// The verification required
        case verificationRequired   = "VERIFICATION_REQUIRED"
    }

    private init(clientTransferId: String,
                 createdOn: String? = nil,
                 destinationAmount: String? = nil,
                 destinationCurrency: String? = nil,
                 destinationFeeAmount: String? = nil,
                 destinationToken: String,
                 expiresOn: String? = nil,
                 foreignExchanges: [HyperwalletForeignExchange]? = nil,
                 memo: String? = nil,
                 notes: String? = nil,
                 sourceAmount: String? = nil,
                 sourceCurrency: String? = nil,
                 sourceFeeAmount: String? = nil,
                 sourceToken: String,
                 status: HyperwalletTransferStatus? = nil,
                 token: String? = nil) {
        self.clientTransferId = clientTransferId
        self.createdOn = createdOn
        self.destinationAmount = destinationAmount
        self.destinationCurrency = destinationCurrency
        self.destinationFeeAmount = destinationFeeAmount
        self.destinationToken = destinationToken
        self.expiresOn = expiresOn
        self.foreignExchanges = foreignExchanges
        self.memo = memo
        self.notes = notes
        self.sourceAmount = sourceAmount
        self.sourceCurrency = sourceCurrency
        self.sourceFeeAmount = sourceFeeAmount
        self.sourceToken = sourceToken
        self.status = status
        self.token = token
    }

    /// A helper class to build the `HyperwalletTransfer` instance.
    public class Builder {
        private let clientTransferId: String
        private var destinationAmount: String?
        private var destinationCurrency: String?
        private let destinationToken: String
        private var memo: String?
        private var notes: String?
        private var sourceAmount: String?
        private var sourceCurrency: String?
        private let sourceToken: String

        /// Creates a new instance of the `HyperwalletTransfer.Builder` based on the required parameters to create
        /// a transfer.
        ///
        /// - Parameters:
        ///   - clientTransferId: A client defined transfer identifier.
        ///                       This is the unique ID assigned to the transfer on your system.
        ///                       Max 50 characters.
        ///   - sourceToken: A token identifying the source of funds.
        ///                  It can be a prepaid card token prefixed with `trm-` or user token prefixed with `usr-`.
        ///   - destinationToken: A token identifying where the funds have been sent.
        ///                       It is your merchant account token prefixed with `act-`.
        public init(clientTransferId: String, sourceToken: String, destinationToken: String) {
            self.clientTransferId = clientTransferId
            self.sourceToken = sourceToken
            self.destinationToken = destinationToken
        }

        /// Sets the transfer destination amount.
        ///
        /// - Parameter destinationAmount: The payment amount in the specified currency loaded into
        ///                                your merchant account.
        /// - Returns: a self `HyperwalletTransfer.Builder` instance.
        public func destinationAmount(_ destinationAmount: String?) -> Builder {
            self.destinationAmount = destinationAmount
            return self
        }

        /// Sets the transfer destination currency.
        ///
        /// - Parameter destinationCurrency: The currency of the payment amount loaded into your merchant
        ///                                  account in ISO 4217 format.
        /// - Returns: a self `HyperwalletTransfer.Builder` instance.
        public func destinationCurrency(_ destinationCurrency: String?) -> Builder {
            self.destinationCurrency = destinationCurrency
            return self
        }

        /// Sets the transfer memo.
        ///
        /// - Parameter memo: An internal memo for the SpendBack transfer (will not be visible to
        ///                   the user making the payment).
        /// - Returns: a self `HyperwalletTransfer.Builder` instance.
        public func memo(_ memo: String?) -> Builder {
            self.memo = memo
            return self
        }

        /// Sets the transfer notes.
        ///
        /// - Parameter notes: A description for the SpendBack transfer.
        /// - Returns: a self `HyperwalletTransfer.Builder` instance.
        public func notes(_ notes: String?) -> Builder {
            self.notes = notes
            return self
        }

        /// Sets the transfer source amount.
        ///
        /// - Parameter sourceAmount: The payment amount in the specified currency that is debited
        ///                           from the sourceToken.
        /// - Returns: a self `HyperwalletTransfer.Builder` instance.
        public func sourceAmount(_ sourceAmount: String?) -> Builder {
            self.sourceAmount = sourceAmount
            return self
        }

        /// Sets the transfer source currency.
        ///
        /// - Parameter sourceCurrency: The currency of the payment amount debited from the sourceToken
        ///                             in ISO 4217 format.
        /// - Returns: a self `HyperwalletTransfer.Builder` instance.
        public func sourceCurrency(_ sourceCurrency: String?) -> Builder {
            self.sourceCurrency = sourceCurrency
            return self
        }

        // Builds a new instance of the `HyperwalletTransfer`.
        ///
        /// - Returns: a new instance of the `HyperwalletTransfer`.
        public func build() -> HyperwalletTransfer {
            return HyperwalletTransfer(clientTransferId: clientTransferId,
                                       destinationAmount: destinationAmount,
                                       destinationCurrency: destinationCurrency,
                                       destinationToken: destinationToken,
                                       memo: memo,
                                       notes: notes,
                                       sourceAmount: sourceAmount,
                                       sourceCurrency: sourceCurrency,
                                       sourceToken: sourceToken)
        }
    }
}
