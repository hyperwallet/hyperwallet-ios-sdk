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

/// Representation of the transfer method configuration
struct TransferMethodConfiguration: Codable {
    /// The list of countries
    let countries: [String]
    /// The list of currencies
    let currencies: [String]
    /// The `Connection<HyperwalletFee>`, or nil if none exists
    let fees: Connection<HyperwalletFee>?
    /// The list of `HyperwalletField`, or nil if none exists
    let fields: [HyperwalletField]?
    /// The processing time, or nil if none exists
    let processingTime: String?
    /// The profile type
    let profile: String
    /// The transfer method type
    let transferMethodType: String
}

/// Representation of the transfer method configuration field
public struct HyperwalletField: Codable {
    /// The category, or nil if none exists
    public let category: String?
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
}

/// Representation of the transfer method configuration field data type
///
/// - text: The text field type
/// - selection: The selecion option field type
/// - boolean: The boolean field type
/// - number: The numeric field type
/// - range: The range field type
/// - date: the date field type
/// - datetime: The datetime field type
/// - expiryDate: The expiry date field type
/// - phone: The phone field type
/// - email: The email field type
/// - file: The file field type
public enum HyperwalletDataType: String, Codable {
    case text = "TEXT"
    case selection = "SELECTION"
    case boolean = "BOOLEAN"
    case number = "NUMBER"
    case range = "RANGE"
    case date = "DATE"
    case datetime = "DATETIME"
    case expiryDate = "EXPIRY_DATE"
    case phone = "PHONE"
    case email = "EMAIL"
    case file = "FILE"
}

/// Representation of the transfer method configuration field selection option
public struct HyperwalletFieldSelectionOption: Codable {
    /// The label
    public let label: String
    /// The value
    public let value: String
}

/// Representation of the fee
public struct HyperwalletFee: Codable, Hashable {
    /// The transfer method type
    public let transferMethodType: String
    /// The country
    public let country: String
    /// The currency
    public let currency: String
    /// The fee rate type (FLAT or PERCENT)
    public let feeRateType: String
    /// The fee value
    public var value: String
    /// The minimum fee, or nil if none exists
    public let minimum: String?
    /// The maximum fee, or nil if none exists
    public let maximum: String?
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
