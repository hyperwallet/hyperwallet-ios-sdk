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

/// Representation of the common query parameters.
public class QueryParam {
    /// Returns user receipts created after this datetime.
    public var createdAfter: Date?
    /// Returns user receipts created before this datetime.
    public var createdBefore: Date?
    /// The maximum number of records that will be returned per page
    public var limit: Int?
    /// The number of records to skip. If no filters are applied, records will be skipped from the beginning
    /// (based on default sort criteria). Default value is 0. Range is from 0 to {n-1} where n = number of
    /// matching records for the query.
    public var offset: Int?
    /// The user receipts attribute to sort the result set by.
    public var sortBy: String?

    enum QueryParam: String {
        case createdAfter
        case createdBefore
        case limit
        case offset
        case sortBy
    }

    /// Creates a new instance of `QueryParam`]
    public init() {
        limit = 10
        offset = 0
    }

    /// Builds the URL Queries
    ///
    /// - Returns: Returns the URL Query's dictionary.
    func toQuery() -> [String: String] {
        var query = [String: String]()

        if let offset = offset {
            query[QueryParam.offset.rawValue] = String(offset)
        }
        if let limit = limit {
            query[QueryParam.limit.rawValue] = String(limit)
        }
        if let date = createdAfter {
            query[QueryParam.createdAfter.rawValue] = ISO8601DateFormatter.ignoreTimeZone.string(from: date)
        }
        if let date = createdBefore {
            query[QueryParam.createdBefore.rawValue] = ISO8601DateFormatter.ignoreTimeZone.string(from: date)
        }
        if let sortBy = sortBy {
            query[QueryParam.sortBy.rawValue] = sortBy
        }
        return query
    }
}
