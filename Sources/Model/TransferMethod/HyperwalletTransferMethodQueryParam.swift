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
    /// Returns transfer method with this status.
    public var status: QueryStatus?

    enum QueryParam: String {
        case status
    }

    /// Representation of the transfer method status
    ///
    /// - activated: Filter by activated bank accounts
    /// - deActivated: Filter by deActivated transfer methods
    /// - invalid: Filter only invalid bank accounts
    /// - lostOrStolen: Filter only lostOrStolen prepaid cards
    /// - preActivated: Filter by preActivated prepaid cards
    /// - suspended: Filter only suspended prepaid cards
    /// - verified: Filter only verified bank accounts
    public enum QueryStatus: String {
        case activated = "ACTIVATED"
        case deActivated = "DE_ACTIVATED"
        case invalid = "INVALID"
        case lostOrStolen = "LOST_OR_STOLEN"
        case preActivated = "PRE_ACTIVATED"
        case suspended = "SUSPENDED"
        case verified = "VERIFIED"
    }

    /// Representation of the field's sortable
    ///
    /// - ascendantCreatedOn: Sort the result by ascendant the field create on
    /// - ascendantStatus: Sort the result by ascendant the field status
    /// - descendantCreatedOn: Sort the result by descendant the create on
    /// - descendantStatus: Sort the result by descendant the field status
    public enum QuerySortable: String {
        case ascendantCreatedOn = "+createdOn"
        case ascendantStatus = "+status"
        case descendantCreatedOn = "-createdOn"
        case descendantStatus = "-status"
    }

    override public func toQuery() -> [String: String] {
        var query = super.toQuery()
        if let date = createdAfter {
            query[QueryParam.createdAfter.rawValue] = ISO8601DateFormatter.ignoreTimeZone.string(from: date)
        }

        if let date = createdBefore {
            query[QueryParam.createdBefore.rawValue] = ISO8601DateFormatter.ignoreTimeZone.string(from: date)
        }

        if let status = status {
            query[QueryParam.status.rawValue] = status.rawValue
        }

        if let sortBy = sortBy {
            query[QueryParam.sortBy.rawValue] = sortBy
        }
        return query
    }
}
