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

/// Representation of a `HyperwalletCountry` node
public struct HyperwalletCountry: Codable {
    /// The 2 letter ISO 3166-1 country code
    public let code: String?
    /// The country name
    public let name: String?
    /// The `HyperwalletCurrency` nodes that connect to this country node
    public let currencies: Connection<HyperwalletCurrency>?
}

/// Representation of a `HyperwalletCurrency` node
public struct HyperwalletCurrency: Codable {
    /// The 3 letter ISO 4217-1 currency code
    public let code: String?
    /// The currency name
    public let name: String?
    /// The `HyperwalletTransferMethodType` nodes that connect to this currency node
    public let transferMethodTypes: Connection<HyperwalletTransferMethodType>?
}

/// Representation of the transfer method configuration field data type
public enum HyperwalletDataType: String, Codable {
    /// The text field type
    case text = "TEXT"
    /// The selecion option field type
    case selection = "SELECTION"
    /// The boolean field type
    case boolean = "BOOLEAN"
    /// The numeric field type
    case number = "NUMBER"
    /// The range field type
    case range = "RANGE"
    /// The date field type
    case date = "DATE"
    /// The datetime field type
    case datetime = "DATETIME"
    /// The expiry date field type
    case expiryDate = "EXPIRY_DATE"
    /// The phone field type
    case phone = "PHONE"
    /// The email field type
    case email = "EMAIL"
    /// The file field type
    case file = "FILE"
}

/// Representation of the fee
public struct HyperwalletFee: Codable, Hashable {
    /// The fee rate type (FLAT or PERCENT)
    public let feeRateType: String?
    /// The fee value
    public var value: String?
    /// The fee currency
    public var currency: String?
    /// The minimum fee, or nil if none exists
    public let minimum: String?
    /// The maximum fee, or nil if none exists
    public let maximum: String?
}

/// Representation of the transfer method configuration field
public struct HyperwalletField: Codable {
    /// The field data type, or nil if none exists
    public let dataType: HyperwalletDataType.RawValue?
    /// The list of selection option, or nil if none exists
    public let fieldSelectionOptions: [HyperwalletFieldSelectionOption]?
    /// Indicate if the field is mandatory, or nil if none exists
    public let isRequired: Bool?
    /// Indicate if the field is editable, or nil if none exists
    public let isEditable: Bool?
    /// The field label
    public let label: String?
    /// The field maximum length, or nil if none exists
    public let maxLength: Int?
    /// The field minimum length, or nil if none exists
    public let minLength: Int?
    /// The field name, or nil if none exists
    public let name: String?
    /// The field placeholder, or nil if none exists
    public let placeholder: String?
    /// The regular expression to validate the field value, or nil if none exists
    public let regularExpression: String?
    /// The validation message
    public let validationMessage: HyperwalletValidationMessage?
    /// The field value
    public let value: String?
    /// The mask, or nil if none exists
    public let mask: HyperwalletMask?
    /// Indicate if the field is masked, or nil if none exists
    public let fieldValueMasked: Bool?
}

/// Representation of list of HyperwalletField and the group to which it belongs
public struct HyperwalletFieldGroup: Codable {
    /// The group
    public let group: String?
    /// The list of HyperwalletField
    public let fields: [HyperwalletField]?
}

/// Representation of the transfer method configuration field selection option
public struct HyperwalletFieldSelectionOption: Codable {
    /// The label
    public let label: String?
    /// The value
    public let value: String?
}

/// Representation of the transfer method configuration field processing times
public struct HyperwalletProcessingTime: Codable {
    /// The country to process
    public let country: String?
    /// The currency to process
    public let currency: String?
    /// The transfer method type
    public let transferMethodType: String?
    /// The value to process
    public let value: String?
}
/// Representation of transfer method type
public struct HyperwalletTransferMethodType: Codable {
    /// The country code
    public let code: String?
    /// The country name
    public let name: String?
    /// The fees for transfer
    public let fees: Connection<HyperwalletFee>?
    /// The processing time for transfer
    public let processingTimes: Connection<HyperwalletProcessingTime>?
}

/// Representation of the transfer method configuration field validation message
public struct HyperwalletValidationMessage: Codable {
    /// The validation message length, or nil if none exists
    public let length: String?
    /// The validation message pattern, or nil if none exists
    public let pattern: String?
    /// The validation message empty, or nil if none exists
    public let empty: String?
}

struct TransferMethodConfigurationField: Codable {
    var countries: Connection<HyperwalletCountry>?
    var transferMethodUIConfigurations: Connection<HyperwalletTransferMethodConfiguration>?
}

struct TransferMethodUpdateConfigurationField: Codable {
    var transferMethodUpdateUIConfigurations: Connection<HyperwalletTransferMethodConfiguration>?
}

struct TransferMethodConfigurationKey: Codable {
    let countries: Connection<HyperwalletCountry>?
}

/// Representation of the transfer method configuration
public struct HyperwalletTransferMethodConfiguration: Codable {
    /// The country
    public let country: String?
    /// The currency
    public let currency: String?
    /// The transfer method type
    public let transferMethodType: String?
    /// The profile type
    public let profile: String?
    /// The `HyperwalletFieldGroup`, or nil if none exists
    public let fieldGroups: Connection<HyperwalletFieldGroup>?
}

/// Representation of the transfer method configuration field mask
public struct HyperwalletMask: Codable {
    /// The conditional pattern, or nil if none exists
    public let conditionalPatterns: [HyperwalletConditionalPattern]?
    /// The default pattern
    public let defaultPattern: String
    /// The scrub regex, or nil if none exists
    public let scrubRegex: String?
}

/// Representation of the transfer method configuration field conditionalPatterns
public struct HyperwalletConditionalPattern: Codable {
    /// The pattern
    public let pattern: String
    /// The regex
    public let regex: String
}
