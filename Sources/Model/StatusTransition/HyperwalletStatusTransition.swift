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
public final class HyperwalletStatusTransition: Codable {
    /// The datetime the status changed in ISO 8601 format (YYYY-MM-DDThh:mm:ss). Note that the timezone used is UTC,
    /// therefore there is no time offset.
    public var createdOn: String!
    /// The status before the transition.
    public var fromStatus: Status!
    /// Comments regarding the status change.
    public var notes: String?
    /// The unique, auto-generated status transition identifier.
    public var token: String!
    /// The status after the transition.
    public var toStatus: Status!
    /// The new status of the resource.
    public var transition: Status

    public init(transition: Status) {
        self.transition = transition
    }

    /// Representation of the status.
    ///
    /// - activated: The status is activate.
    /// - cancelled: The status is cancel.
    /// - completed: The status is complete.
    /// - deactivated: The status is deactivate.
    /// - expired: The status is expire.
    /// - failed: The status is fail.
    /// - inProgress: The status is in progress.
    /// - invalid: The status is invalid.
    /// - lostOrStolen: The status is lost or stolen.
    /// - pendingAccountActivation: The status is pending account activation.
    /// - pendingIdVerification: The status is pending identity verification.
    /// - pendingTaxVerification: The status is pending tax verification.
    /// - pendingTransactionVerification: The status is pending transaction verification.
    /// - pendingTransferMethodAction: The status is pending transfer method action.
    /// - quoted: The status is quoted
    /// - recalled: The status is recall.
    /// - returned: The status is return.
    /// - scheduled: The status is schedule.
    /// - suspended: The status is suspend.
    /// - unsuspended: The status is not suspended.
    /// - verified: The status is verified.
    /// - verificationRequired: The status is verification required
    public enum Status: String, Codable {
        case activated                          = "ACTIVATED"
        case cancelled                          = "CANCELLED"
        case completed                          = "COMPLETED"
        case deactivated                        = "DE_ACTIVATED"
        case expired                            = "EXPIRED"
        case failed                             = "FAILED"
        case inProgress                         = "IN_PROGRESS"
        case invalid                            = "INVALID"
        case lostOrStolen                       = "LOST_OR_STOLEN"
        case pendingAccountActivation           = "PENDING_ACCOUNT_ACTIVATION"
        case pendingIdVerification              = "PENDING_ID_VERIFICATION"
        case pendingTaxVerification             = "PENDING_TAX_VERIFICATION"
        case pendingTransactionVerification     = "PENDING_TRANSACTION_VERIFICATION"
        case pendingTransferMethodAction        = "PENDING_TRANSACTION_METHOD_ACTION"
        case quoted                             = "QUOTED"
        case recalled                           = "RECALLED"
        case returned                           = "RETURNED"
        case scheduled                          = "SCHEDULED"
        case suspended                          = "SUSPENDED"
        case unsuspended                        = "UNSUSPENDED"
        case verificationRequired               = "VERIFICATION_REQUIRED"
        case verified                           = "VERIFIED"
    }
}
