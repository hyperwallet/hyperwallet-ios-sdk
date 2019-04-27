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

/// Representation of the common transfer method's pagination fields.
public class HyperwalletTransferMethodPagination: HyperwalletPagination {
    /// Returns transfer methods created after this datetime.
    public var createdAfter: Date?
    /// Returns transfer methods created before this datetime.
    public var createdBefore: Date?
    /// The transfer methods attribute to sort the result set by.
    public var sortBy: QuerySortable?
    /// Returns transfer methods with this account status.
    public var status: QueryStatus?

    /// Representation of the transfer method status
    ///
    /// - activated: Filter by activated transfer methods
    /// - deActivated: Filter by deActivated transfer methods
    /// - invalid: Filter only invalid transfer methods
    /// - verified: Filter only verified transfer methods
    public enum QueryStatus: String {
        case activated = "ACTIVATED"
        case deActivated = "DE_ACTIVATED"
        case invalid = "INVALID"
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

    /// Builds the `HyperwalletTransferMethodPagination`'s URL Queries
    ///
    /// - Returns: Returns a dictionary of URL Query
    override public func toQuery() -> [String: String] {
        var query = super.toQuery()

        if let date = createdAfter {
            query["createdAfter"] = HyperwalletTransferMethodPagination.iso8601.string(from: date)
        }

        if let date = createdBefore {
            query["createdBefore"] = HyperwalletTransferMethodPagination.iso8601.string(from: date)
        }

        if status != nil {
            query["status"] = status?.rawValue
        }

        if sortBy != nil {
            query["sortBy"] = sortBy?.rawValue
        }

        return query
    }

    /// Returns DateFormatter based at ISO860-1
    ///
    /// Example to convert Date to String:
    ///     let date = Date()
    ///     let dateFormatted = iso8601.string(from: date)
    ///     print(dateFormatted) // 2019-01-23T03:04:13.959Z
    ///
    /// Example to convert Date to String:
    ///     let value = "2019-01-23T03:04:13.959Z"
    ///     let date = iso8601.date(from: value)
    public static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}
