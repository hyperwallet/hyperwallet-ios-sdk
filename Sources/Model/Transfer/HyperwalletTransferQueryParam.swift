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

/// Representation of the user transfers QueryParams fields.
public class HyperwalletTransferQueryParam: QueryParam {
    /// A value that identifies the client transfer id.
    var clientTransferId: String?
    /// A value that identifies the destination token.
    var destinationToken: String?
    /// A value that identifies the source token.
    var sourceToken: String?

    enum QueryParam: String {
        case clientTransferId
        case destinationToken
        case sourceToken
    }

    override func toQuery() -> [String: String] {
        var query = super.toQuery()
        if let clientTransferId = clientTransferId {
            query[QueryParam.clientTransferId.rawValue] = clientTransferId
        }
        if let destinationToken = destinationToken {
            query[QueryParam.destinationToken.rawValue] = destinationToken
        }
        if let sourceToken = sourceToken {
            query[QueryParam.sourceToken.rawValue] = sourceToken
        }
        return query
    }
}
