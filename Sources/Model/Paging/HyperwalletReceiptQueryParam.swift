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

/// Representation of the user receipts QueryParam fields.
public class HyperwalletReceiptQueryParam: HyperwalletQueryParam {
    /// Returns user receipts created after this datetime.
    public var createdAfter: Date?
    /// Returns user receipts created before this datetime.
    public var createdBefore: Date?
    /// A value that identifies the user receipts currency.
    public var currency: String?
    /// The user receipts attribute to sort the result set by.
    public var sortBy: QuerySortable?

    enum QueryParam: String {
        case createdAfter
        case createdBefore
        case currency
        case sortBy
    }

    /// Representation of the field's sortable
    ///
    /// - ascendantAmount: Sort the result by ascendant the field amount
    /// - ascendantCreatedOn: Sort the result by ascendant the field create on
    /// - ascendantCurrency: Sort the result by ascendant the field currency
    /// - ascendantType: Sort the result by ascendant the field type
    /// - descendantAmount: Sort the result by descendant the create amount
    /// - descendantCreatedOn: Sort the result by descendant the field created on
    /// - descendantCurrency: Sort the result by descendant the field currency
    /// - descendantType: Sort the result by descendant the field type
    public enum QuerySortable: String {
        case ascendantAmount = "+amount"
        case ascendantCreatedOn = "+createdOn"
        case ascendantCurrency = "+currency"
        case ascendantType = "+type"

        case descendantAmount = "-amount"
        case descendantCreatedOn = "-createdOn"
        case descendantCurrency = "-currency"
        case descendantType = "-type"
    }

    override func toQuery() -> [String: String] {
        var query = super.toQuery()
        if let date = createdAfter {
            query[QueryParam.createdAfter.rawValue] = Date.iso8601.string(from: date)
        }
        if let date = createdBefore {
            query[QueryParam.createdBefore.rawValue] = Date.iso8601.string(from: date)
        }
        if let currency = currency {
            query[QueryParam.currency.rawValue] = currency
        }
        if let sortBy = sortBy {
            query[QueryParam.sortBy.rawValue] = sortBy.rawValue
        }
        return query
    }
}
