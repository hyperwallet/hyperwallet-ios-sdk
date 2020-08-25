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

/// Representation of the status transition.
///
/// The status transition describes a status change for an existing bank account, bank card, PayPal account,
/// prepaid card, paper check or payment.
public struct HyperwalletStatusTransition: Codable {
    /// The datetime the status changed in ISO 8601 format (YYYY-MM-DDThh:mm:ss). Note that the timezone used is UTC,
    /// therefore there is no time offset.
    public let createdOn: String?
    /// The status before the transition.
    public let fromStatus: Status?
    /// Comments regarding the status change.
    public let notes: String?
    /// The unique, auto-generated status transition identifier.
    public let token: String?
    /// The status after the transition.
    public let toStatus: Status?
    /// The new status of the resource.
    public let transition: Status?

    private init(createdOn: String? = nil,
                 fromStatus: Status? = nil,
                 notes: String? = nil,
                 token: String? = nil,
                 toStatus: Status? = nil,
                 transition: Status) {
        self.createdOn = createdOn
        self.fromStatus = fromStatus
        self.notes = notes
        self.token = token
        self.toStatus = toStatus
        self.transition = transition
    }

    /// Representation of the status.
    public enum Status: String, Codable {
        /// The status is activate.
        case activated                          = "ACTIVATED"
        /// The status is cancel.
        case cancelled                          = "CANCELLED"
        /// The status is complete.
        case completed                          = "COMPLETED"
        /// The status is deactivate.
        case deactivated                        = "DE_ACTIVATED"
        /// The status is expire.
        case expired                            = "EXPIRED"
        /// The status is fail.
        case failed                             = "FAILED"
        /// The status is in progress.
        case inProgress                         = "IN_PROGRESS"
        /// The status is invalid.
        case invalid                            = "INVALID"
        /// The status is lost or stolen.
        case lostOrStolen                       = "LOST_OR_STOLEN"
        /// The status is pending account activation.
        case pendingAccountActivation           = "PENDING_ACCOUNT_ACTIVATION"
        /// The status is pending identity verification.
        case pendingIdVerification              = "PENDING_ID_VERIFICATION"
        /// The status is pending tax verification.
        case pendingTaxVerification             = "PENDING_TAX_VERIFICATION"
        /// The status is pending transaction verification.
        case pendingTransactionVerification     = "PENDING_TRANSACTION_VERIFICATION"
        /// The status is pending transfer method action.
        case pendingTransferMethodAction        = "PENDING_TRANSACTION_METHOD_ACTION"
        /// The status is quoted
        case quoted                             = "QUOTED"
        /// The status is recall.
        case recalled                           = "RECALLED"
        /// The status is return.
        case returned                           = "RETURNED"
        /// The status is schedule.
        case scheduled                          = "SCHEDULED"
        /// The status is suspend.
        case suspended                          = "SUSPENDED"
        /// The status is not suspended.
        case unsuspended                        = "UNSUSPENDED"
        /// The status is verification required
        case verificationRequired               = "VERIFICATION_REQUIRED"
        /// The status is verified.
        case verified                           = "VERIFIED"
    }

    /// A helper class to build the `HyperwalletStatusTransition` instance.
    public class Builder {
        private let notes: String?
        private let transition: Status
        /// Initialization of Builder
        ///
        /// - Parameters:
        ///   - notes: Comments regarding the status change
        ///   - transition: The new status of the resource
        public init(notes: String? = nil, transition: Status) {
            self.notes = notes
            self.transition = transition
        }

        // Builds a new instance of the `HyperwalletTransfer`.
        ///
        /// - Returns: a new instance of the `HyperwalletTransfer`.
        public func build() -> HyperwalletStatusTransition {
            HyperwalletStatusTransition(notes: notes, transition: transition)
        }
    }
}
