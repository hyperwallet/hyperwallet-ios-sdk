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

/// Details of the transaction.
///
/// - bankAccountId: The bank account number, IBAN or equivalent
/// - bankAccountPurpose: The bank account type, e.g. CHECKING or SAVINGS
/// - bankId: The bank code, BIC/SWIFT or equivalent
/// - bankName: The bank name
/// - branchAddressLine1: The branch address, first line
/// - branchAddressLine2: The branch address, second line
/// - branchCity: The branch city
/// - branchCountry: The 2-letter country code of the branch
/// - branchId: The branch code or equivalent
/// - branchName: The branch name
/// - branchPostalCode: The branch postal code
/// - branchStateProvince: The branch state or province
/// - cardExpiryDate: The card expiry date in YYYY-MM format
/// - cardHolderName: The card holder's full name
/// - cardNumber: The card number
/// - charityName: The name of the charity that is receiving the donation
/// - checkNumber: The paper check number
/// - clientPaymentId: The client-assigned transaction identifier
/// - memo: An internal note added by a client operator
/// - notes: A description for the receipt
/// - payeeAddressLine1: The payee's address first line
/// - payeeAddressLine2: The payee's address, second line
/// - payeeCity: The payee's city
/// - payeeCountry: The payee's 2-letter country code
/// - payeeEmail: The payee's email address on record
/// - payeeName: The payee's full name
/// - payeePostalCode: The payee's postal code, ZIP code or equivalent
/// - payeeStateProvince: The payee's state or province
/// - payerName: The payer's full name
/// - paymentExpiryDate: The payment expiry date in YYYY-MM-DD format
/// - returnOrRecallReason: The reason for returning or recalling the payment
/// - securityAnswer: The answer to the securityQuestion
/// - securityQuestion: A security question
/// - website: The URL of the client website where the virtual incentive was accrued
public struct HyperwalletReceiptDetails: Decodable {
    public let bankAccountId: String?
    public let bankAccountPurpose: HyperwalletReceipt.BankAccountPurposeType?
    public let bankId: String?
    public let bankName: String?
    public let branchAddressLine1: String?
    public let branchAddressLine2: String?
    public let branchCity: String?
    public let branchCountry: String?
    public let branchId: String?
    public let branchName: String?
    public let branchPostalCode: String?
    public let branchStateProvince: String?
    public let cardExpiryDate: String?
    public let cardHolderName: String?
    public let cardNumber: String?
    public let charityName: String?
    public let checkNumber: String?
    public let clientPaymentId: String?
    public let memo: String?
    public let notes: String?
    public let payeeAddressLine1: String?
    public let payeeAddressLine2: String?
    public let payeeCity: String?
    public let payeeCountry: String?
    public let payeeEmail: String?
    public let payeeName: String?
    public let payeePostalCode: String?
    public let payeeStateProvince: String?
    public let payerName: String?
    public let paymentExpiryDate: String?
    public let returnOrRecallReason: String?
    public let securityAnswer: String?
    public let securityQuestion: String?
    public let website: String?
}

/// Representation of the Hyperwallet's receipt.
///
/// - amount: The gross amount of the transaction.
/// - createdOn: The datetime the transaction was created on in ISO 8601 format 'YYYY-MM-DDThh:mm:ss' (UTC timezone)
/// - currency: The 3-letter currency code for the transaction.
/// - destinationToken: A token identifying where the funds were sent.
/// - details: Details of the transaction.
/// - entry: The type of transaction.
/// - fee: The fee amount.
/// - foreignExchangeCurrency: The 3-letter currency code for the foreign exchange.
/// - foreignExchangeRate: The foreign exchange rate.
/// - journalId: The journal entry number for the transaction.
/// - sourceToken: A token identifying the source of funds.
/// - type: The transaction type.
public struct HyperwalletReceipt: Decodable, Equatable {
    public let amount: String
    public let createdOn: String
    public let currency: String
    public let destinationToken: String?
    public let details: HyperwalletReceiptDetails?
    public let entry: HyperwalletEntryType
    public let fee: String?
    public let foreignExchangeCurrency: String?
    public let foreignExchangeRate: String?
    public let journalId: String
    public let sourceToken: String?
    public let type: HyperwalletReceiptType

    public static func == (lhs: HyperwalletReceipt, rhs: HyperwalletReceipt) -> Bool {
        return lhs.journalId == rhs.journalId &&
            rhs.entry == lhs.entry &&
            rhs.type == lhs.type
    }

    /// The transaction type.
    public enum HyperwalletReceiptType: String, Decodable {
        // Generic fee types
        case annualFee = "ANNUAL_FEE"
        case annualFeeRefund = "ANNUAL_FEE_REFUND"
        case customerServiceFee = "CUSTOMER_SERVICE_FEE"
        case customerServiceFeeRefund = "CUSTOMER_SERVICE_FEE_REFUND"
        case expeditedShippingFee = "EXPEDITED_SHIPPING_FEE"
        case genericFeeRefund = "GENERIC_FEE_REFUND"
        case monthlyFee = "MONTHLY_FEE"
        case monthlyFeeRefund = "MONTHLY_FEE_REFUND"
        case paymentExpiryFee = "PAYMENT_EXPIRY_FEE"
        case paymentFee = "PAYMENT_FEE"
        case processingFee = "PROCESSING_FEE"
        case standardShippingFee = "STANDARD_SHIPPING_FEE"
        case transferFee = "TRANSFER_FEE"
        // Generic payment types
        case adjustment = "ADJUSTMENT"
        case deposit = "DEPOSIT"
        case foreignExchange = "FOREIGN_EXCHANGE"
        case manualAdjustment = "MANUAL_ADJUSTMENT"
        case paymentExpiration = "PAYMENT_EXPIRATION"
        // Bank account-specific types
        case bankAccountTransferFee = "BANK_ACCOUNT_TRANSFER_FEE"
        case bankAccountTransferReturn = "BANK_ACCOUNT_TRANSFER_RETURN"
        case bankAccountTransferReturnFee = "BANK_ACCOUNT_TRANSFER_RETURN_FEE"
        case transferToBankAccount = "TRANSFER_TO_BANK_ACCOUNT"
        // Card-specific types
        case cardActivationFee = "CARD_ACTIVATION_FEE"
        case cardActivationFeeWaiver = "CARD_ACTIVATION_FEE_WAIVER"
        case cardFee = "CARD_FEE"
        case manualTransferToPrepaidCard = "MANUAL_TRANSFER_TO_PREPAID_CARD"
        case prepaidCardBalanceInquiryFee = "PREPAID_CARD_BALANCE_INQUIRY_FEE"
        case prepaidCardCashAdvance = "PREPAID_CARD_CASH_ADVANCE"
        case prepaidCardDisputedChargeRefund = "PREPAID_CARD_DISPUTED_CHARGE_REFUND"
        case prepaidCardDisputeDeposit = "PREPAID_CARD_DISPUTE_DEPOSIT"
        case prepaidCardDomesticCashWithdrawalFee = "PREPAID_CARD_DOMESTIC_CASH_WITHDRAWAL_FEE"
        case prepaidCardExchangeRateDifference = "PREPAID_CARD_EXCHANGE_RATE_DIFFERENCE"
        case prepaidCardManualUnload = "PREPAID_CARD_MANUAL_UNLOAD"
        case prepaidCardOverseasCashWithdrawalFee = "PREPAID_CARD_OVERSEAS_CASH_WITHDRAWAL_FEE"
        case prepaidCardPinChangeFee = "PREPAID_CARD_PIN_CHANGE_FEE"
        case prepaidCardRefund = "PREPAID_CARD_REFUND"
        case prepaidCardReplacementFee = "PREPAID_CARD_REPLACEMENT_FEE"
        case pPrepaidCardSale = "PREPAID_CARD_SALE"
        case prepaidCardSaleReversal = "PREPAID_CARD_SALE_REVERSAL"
        case prepaidCardUnload = "PREPAID_CARD_UNLOAD"
        case transferToPrepaidCard = "TRANSFER_TO_PREPAID_CARD"
        // Donation types
        case donation = "DONATION"
        case donationFee = "DONATION_FEE"
        case donationReturn = "DONATION_RETURN"
        // Merchant payment types
        case merchantPayment = "MERCHANT_PAYMENT"
        case merchantPaymentFee = "MERCHANT_PAYMENT_FEE"
        case merchantPaymentRefund = "MERCHANT_PAYMENT_REFUND"
        case merchantPaymentReturn = "MERCHANT_PAYMENT_RETURN"
        // MoneyGram types
        case moneygramTransferReturn = "MONEYGRAM_TRANSFER_RETURN"
        case transferToMoneygram = "TRANSFER_TO_MONEYGRAM"
        // Paper check types
        case paperCheckFee = "PAPER_CHECK_FEE"
        case paperCheckRefund = "PAPER_CHECK_REFUND"
        case transferToPaperCheck = "TRANSFER_TO_PAPER_CHECK"
        // User and program account types
        case accountClosure = "ACCOUNT_CLOSURE"
        case accountClosureFee = "ACCOUNT_CLOSURE_FEE"
        case accountUnload = "ACCOUNT_UNLOAD"
        case dormantUserFee = "DORMANT_USER_FEE"
        case dormantUserFeeRefund = "DORMANT_USER_FEE_REFUND"
        case payment = "PAYMENT"
        case paymentCancellation = "PAYMENT_CANCELLATION"
        case paymentReversal = "PAYMENT_REVERSAL"
        case paymentReversalFee = "PAYMENT_REVERSAL_FEE"
        case paymentReturn = "PAYMENT_RETURN"
        case transferToProgramAccount = "TRANSFER_TO_PROGRAM_ACCOUNT"
        case transferToUser = "TRANSFER_TO_USER"
        // Virtual incentive types
        case virtualIncentiveCancellation = "VIRTUAL_INCENTIVE_CANCELLATION"
        case virtualIncentiveIssuance = "VIRTUAL_INCENTIVE_ISSUANCE"
        case virtualIncentivePurchase = "VIRTUAL_INCENTIVE_PURCHASE"
        case virtualIncentiveRefund = "VIRTUAL_INCENTIVE_REFUND"
        // Western Union and WUBS types
        case transferToWesternUnion = "TRANSFER_TO_WESTERN_UNION"
        case transferToWubsWire = "TRANSFER_TO_WUBS_WIRE"
        case westernUnionTransferReturn = "WESTERN_UNION_TRANSFER_RETURN"
        case wubsWireTransferReturn = "WUBS_WIRE_TRANSFER_RETURN"
        // Wire transfer types
        case transferToWire = "TRANSFER_TO_WIRE"
        case wireTransferFee = "WIRE_TRANSFER_FEE"
        case wireTransferReturn = "WIRE_TRANSFER_RETURN"
        case unknown = "UNKNOWN_RECEIPT_TYPE"
    }

    /// The entry type.
    public enum HyperwalletEntryType: String, Decodable {
        case credit = "CREDIT"
        case debit = "DEBIT"
    }

    public enum BankAccountPurposeType: String, Decodable {
        case checking = "CHECKING"
        case savings = "SAVINGS"
    }
}

extension HyperwalletReceipt.HyperwalletReceiptType {
    /// A safe initializer for creating a HyperwalletReceiptType object
    ///
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: Decoder) throws {
        self = try HyperwalletReceipt.HyperwalletReceiptType(rawValue: decoder
            .singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
