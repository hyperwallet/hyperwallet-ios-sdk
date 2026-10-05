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

/// The `GraphQlQuery` protocol for creating a GraphQL query with the Hyperwallet platform.
protocol GraphQlQuery: Encodable {
    /// Returns a formatted query string that can be posted to the Hyperwallet platforms GraphQL schema.
    ///
    /// - Parameter userToken: the unique identifier for the User that the query pertains to
    /// - Returns: a formatted query string that can be posted to the Hyperwallet platforms GraphQL schema
    func toGraphQl(userToken: String) -> String
}

extension GraphQlQuery {
    /// The set of characters allowed in a value interpolated as an unquoted GraphQL enum/scalar
    /// literal (e.g. `Country`, `Currency`, `Profile`, `TransferMethodType`). Restricted to valid
    /// GraphQL name characters so that no syntax character (quote, brace, parenthesis, whitespace,
    /// comment marker) can break out of the intended query field.
    private static var graphQlLiteralAllowedCharacters: CharacterSet {
        CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_")
    }

    /// Sanitizes a value that is interpolated into the query as an **unquoted** GraphQL literal by
    /// removing any character that is not a valid GraphQL name character. Legitimate values (ISO
    /// country/currency codes, known transfer method types, `INDIVIDUAL`/`BUSINESS`) pass through
    /// unchanged; injection payloads are stripped of the syntax characters they rely on.
    ///
    /// - Parameter value: the raw value supplied by the host application
    /// - Returns: the value with every non GraphQL-name character removed
    func sanitizeGraphQlLiteral(_ value: String) -> String {
        let allowed = Self.graphQlLiteralAllowedCharacters
        return String(String.UnicodeScalarView(value.unicodeScalars.filter { allowed.contains($0) }))
    }

    /// Escapes a value that is interpolated into the query **inside a double-quoted** GraphQL string
    /// (e.g. a user or transfer method token). Backslashes and double quotes are escaped so the
    /// value cannot terminate the string literal and append arbitrary GraphQL.
    ///
    /// - Parameter value: the raw value supplied by the host application
    /// - Returns: the value safe to embed between double quotes in a GraphQL document
    func escapeGraphQlString(_ value: String) -> String {
        value
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
    }
}
