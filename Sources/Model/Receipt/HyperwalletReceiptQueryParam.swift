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
public class HyperwalletReceiptQueryParam: QueryParam {
    /// A value that identifies the user receipts currency.
    public var currency: String?

    enum QueryParam: String {
        case currency
    }

    /// Representation of the field's sortable
    public enum QuerySortable: String {
        /// Sort the result by ascendant  amount
        case ascendantAmount = "+amount"
        /// Sort the result by ascendant created on
        case ascendantCreatedOn = "+createdOn"
        /// Sort the result by ascendant  currency
        case ascendantCurrency = "+currency"
        /// Sort the result by ascendant  type
        case ascendantType = "+type"
        /// Sort the result by descendant  amount
        case descendantAmount = "-amount"
        /// Sort the result by descendant created on
        case descendantCreatedOn = "-createdOn"
        /// Sort the result by descendant currency
        case descendantCurrency = "-currency"
        /// Sort the result by descendant  type
        case descendantType = "-type"
    }

    override func toQuery() -> [String: String] {
        var query = super.toQuery()
        if let currency = currency {
            query[QueryParam.currency.rawValue] = currency
        }
        return query
    }
}
