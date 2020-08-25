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

/// The `HyperwalletTransferMethodConfigurationFieldQuery` struct defines and builds a query to retrieve the fields
/// required to create a transfer method (Bank Account, Bank Card, PayPal Account, Prepaid Card, Paper Check)
/// with the Hyperwallet platform.
public struct HyperwalletTransferMethodConfigurationFieldQuery: GraphQlQuery, Hashable {
    private var country: String
    private var currency: String
    private var transferMethodType: String
    private var profile: String
    private var query = """
        query QueryCreateTransferMethod(
            $idToken: String =  "%@",
            $profileType: Profile = %@
            $country: Country = %@
            $currency: Currency = %@
            $transferMethodType: TransferMethodType = %@

        ){
            transferMethodUIConfigurations (idToken: $idToken,
                profileType: $profileType
                country: $country,
                currency: $currency,
                transferMethodType: $transferMethodType) {
                    nodes {
                        country
                        currency
                        transferMethodType
                        profile
                        fieldGroups {
                            nodes {
                                group
                                fields {
                                    dataType
                                    isRequired
                                    isEditable
                                    name
                                    label
                                    placeholder
                                    value
                                    maxLength
                                    minLength
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
                },
          countries (idToken: $idToken,
                     code: $country){
              nodes {
                code
                name
                iso3
                currencies (code:$currency){
                  nodes {
                    code
                    name
                    transferMethodTypes (code:$transferMethodType){
                      nodes {
                        code
                        name
                        processingTimes {
                          nodes {
                            country
                            currency
                            transferMethodType
                            value
                          }
                        }
                        fees {
                          nodes {
                            currency
                            feeRateType
                            value
                            minimum
                            maximum
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
         }
    """

    /// Create a new `HyperwalletTransferMethodConfigurationQuery` from the country, currency, transferMethodType
    /// and profile
    ///
    /// - Parameters:
    ///   - country: the 2 letter ISO 3166-1 country code
    ///   - currency: the 3 letter ISO 4217-1 currency code
    ///   - transferMethodType: the `TransferMethodType`
    ///   - profile: `INDIVIDUAL` or `BUSINESS`
    public init(country: String,
                currency: String,
                transferMethodType: String,
                profile: String) {
        self.country = country
        self.currency = currency
        self.transferMethodType = transferMethodType
        self.profile = profile
    }

    public func toGraphQl(userToken: String) -> String {
        String(format: query, userToken, profile, country, currency, transferMethodType)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(country)
        hasher.combine(currency)
        hasher.combine(transferMethodType)
        hasher.combine(profile)
    }
}

/// The 'HyperwalletTransferMethodConfigurationKeysQuery' struct defines and builds a query to retrieve the key set
/// that is required to construct a `HyperwalletTransferMethodConfigurationFieldQuery`.
///
/// In addition to the key set, the query will also retrieve the processing time and fees associated with each
/// country, currency and transfer method type tuple.
public struct HyperwalletTransferMethodConfigurationKeysQuery: GraphQlQuery {
    private var limit: Int = 0
    private var query = """
    query {
        countries (idToken: "%@") {
            nodes {
                code
                name
                currencies {
                    nodes {
                        code
                        name
                        transferMethodTypes {
                            nodes {
                                code
                                name
                                processingTimes {
                                  nodes {
                                    country
                                    currency
                                    transferMethodType
                                    value
                                  }
                                }
                                fees {
                                    nodes {
                                      currency
                                      value
                                      feeRateType
                                      maximum
                                      minimum
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    """

    //// Create a new `HyperwalletTransferMethodConfigurationKeysQuery` instance
    ///
    /// - Parameter limit: The maximum number of records that will be returned per page.
    public init(limit: Int = 0) {
        self.limit = limit
    }

    public func toGraphQl(userToken: String) -> String {
        String(format: query, userToken, limit)
    }
}
