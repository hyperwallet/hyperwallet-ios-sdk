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

/// The `HyperwalletTransferMethodUpdateConfigurationFieldQuery`
/// struct defines and builds a query to retrieve the fields
/// required to update a transfer method (Bank Account, Bank Card, PayPal Account, Prepaid Card, Paper Check and Venmo)
/// with the Hyperwallet platform.
public struct HyperwalletTransferMethodUpdateConfigurationFieldQuery: GraphQlQuery, Hashable {
    private var transferMethodToken: String
    private var query = """
        query QueryUpdateTransferMethod(
            $trmToken: String =  "%@"
        ){
            transferMethodUpdateUIConfigurations (
                trmToken: $trmToken
            ) {
                nodes {
                    country
                    currency
                    transferMethodType
                    profile
                    fieldGroups {
                        nodes {
                            group
                            isEditable
                            fields {
                                category
                                value
                                dataType
                                isRequired
                                isEditable
                                label
                                maxLength
                                minLength
                                name
                                placeholder
                                regularExpression
                                fieldSelectionOptions {
                                    label
                                    value
                                }
                                validationMessage {
                                    length
                                    pattern
                                    empty
                                }
                                fieldValueMasked
                                mask {
                                    conditionalPatterns {
                                        pattern
                                        regex
                                    }
                                    defaultPattern
                                    scrubRegex
                                }
                            }
                        }
                    }
                }
            }
        }
    """

    /// Create a new `HyperwalletTransferMethodUpdateConfigurationFieldQuery` from the transferMethodToken
    ///
    /// - Parameters:
    ///   - transferMethodToken: token from the transfer method
    public init(transferMethodToken: String) {
        self.transferMethodToken = transferMethodToken
    }

    public func toGraphQl(userToken: String) -> String {
        String(format: query, transferMethodToken)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(transferMethodToken)
    }
}
