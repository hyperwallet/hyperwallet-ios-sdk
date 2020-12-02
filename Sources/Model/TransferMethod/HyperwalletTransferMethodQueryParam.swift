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

/// Representation of the common transfer method's query parameters.
public class HyperwalletTransferMethodQueryParam: QueryParam {
    enum QueryParam: String {
        case status
        case type
    }

    /// Returns transfer method with this status.
    public var status: String?
    /// Returns transfer method of that type
    public var type: String?

    /// Representation of the transfer method status
    public enum QueryStatus: String {
        /// Filter by activated transfer methods
        case activated = "ACTIVATED"
        /// Filter by deActivated transfer methods
        case deActivated = "DE_ACTIVATED"
        /// Filter only invalid transfer methods
        case invalid = "INVALID"
        /// Filter only lost or stolen prepaid cards
        case lostOrStolen = "LOST_OR_STOLEN"
        /// Filter by preActivated prepaid cards
        case preActivated = "PRE_ACTIVATED"
        /// Filter only suspended prepaid cards
        case suspended = "SUSPENDED"
        /// Filter only verified transfer methods
        case verified = "VERIFIED"
    }

    /// Representation of the field's sortable
    public enum QuerySortable: String {
        /// Sort the result by ascendant created on
        case ascendantCreatedOn = "+createdOn"
        /// Sort the result by ascendant status
        case ascendantStatus = "+status"
        /// Sort the result by descendant created on
        case descendantCreatedOn = "-createdOn"
        /// Sort the result by descendant status
        case descendantStatus = "-status"
    }

    /// Representation of the transfer method's type
    public enum QueryType: String {
        /// When the transfer method is Bank Account
        case bankAccount = "BANK_ACCOUNT"
        /// When the transfer method is Bank Card
        case bankCard = "BANK_CARD"
        /// When the transfer method is PayPal Account
        case payPalAccount = "PAYPAL_ACCOUNT"
        /// When the transfer method is Wire Account
        case wireAccount = "WIRE_ACCOUNT"
        /// When the transfer method is Prepaid Card
        case prepaidCard = "PREPAID_CARD"
        /// When the transfer method is Venmo Account
        case venmoAccount = "VENMO_ACCOUNT"
        /// When the transfer method is Paper Check Account
        case paperCheckAccount = "PAPER_CHECK"
    }

    override public func toQuery() -> [String: String] {
        var query = super.toQuery()

        if let status = status {
            query[QueryParam.status.rawValue] = status
        }
        if let type = type {
            query[QueryParam.type.rawValue] = type
        }
        return query
    }
}
