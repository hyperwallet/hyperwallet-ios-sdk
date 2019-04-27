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

/// Representation of the common pagination fields
public class HyperwalletPagination {
    /// The maximum number of records that will be returned per page
    public var limit: Int
    /// The number of records to skip. If no filters are applied, records will be skipped from the beginning
    /// (based on default sort criteria). Default value is 0. Range is from 0 to {n-1} where n = number of
    /// matching records for the query.
    public var offset: Int

    /// Creates a new instance of `HyperwalletPagination`]
    public init() {
        limit = 10
        offset = 0
    }

    /// Builds the `HyperwalletTransferMethodPagination`'s URL Queries
    ///
    /// - Returns: Returns the URL Query's dictionary.
    public func toQuery() -> [String: String] {
        return ["offset": "\(offset)", "limit": "\(limit)"]
    }
}
