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
public struct HyperwalletReceiptDetails: Decodable {
    /// - bankAccountId: The bank account number, IBAN or equivalent
    public let bankAccountId: String?
    /// - bankAccountPurpose: The bank account type, e.g. CHECKING or SAVINGS
    public let bankAccountPurpose: HyperwalletReceipt.BankAccountPurposeType?
    /// - bankId: The bank code, BIC/SWIFT or equivalent
    public let bankId: String?
    /// - bankName: The bank name
    public let bankName: String?
    /// - branchAddressLine1: The branch address, first line
    public let branchAddressLine1: String?
    /// - branchAddressLine2: The branch address, second line
    public let branchAddressLine2: String?
    /// - branchCity: The branch city
    public let branchCity: String?
    /// - branchCountry: The 2-letter country code of the branch
    public let branchCountry: String?
    /// - branchId: The branch code or equivalent
    public let branchId: String?
    /// - branchName: The branch name
    public let branchName: String?
    /// - branchPostalCode: The branch postal code
    public let branchPostalCode: String?
    /// - branchStateProvince: The branch state or province
    public let branchStateProvince: String?
    /// - cardExpiryDate: The card expiry date in YYYY-MM format
    public let cardExpiryDate: String?
    /// - cardHolderName: The card holder's full name
    public let cardHolderName: String?
    /// - cardNumber: The card number
    public let cardNumber: String?
    /// - charityName: The name of the charity that is receiving the donation
    public let charityName: String?
    /// - checkNumber: The paper check number
    public let checkNumber: String?
    /// - clientPaymentId: The client-assigned transaction identifier
    public let clientPaymentId: String?
    /// - memo: An internal note added by a client operator
    public let memo: String?
    /// - notes: A description for the receipt
    public let notes: String?
    /// - payeeAddressLine1: The payee's address first line
    public let payeeAddressLine1: String?
    /// - payeeAddressLine2: The payee's address, second line
    public let payeeAddressLine2: String?
    /// - payeeCity: The payee's city
    public let payeeCity: String?
    /// - payeeCountry: The payee's 2-letter country code
    public let payeeCountry: String?
    /// - payeeEmail: The payee's email address on record
    public let payeeEmail: String?
    /// - payeeName: The payee's full name
    public let payeeName: String?
    /// - payeePostalCode: The payee's postal code, ZIP code or equivalent
    public let payeePostalCode: String?
    /// - payeeStateProvince: The payee's state or province
    public let payeeStateProvince: String?
    /// - payerName: The payer's full name
    public let payerName: String?
    /// - paymentExpiryDate: The payment expiry date in YYYY-MM-DD format
    public let paymentExpiryDate: String?
    /// - returnOrRecallReason: The reason for returning or recalling the payment
    public let returnOrRecallReason: String?
    /// - securityAnswer: The answer to the securityQuestion
    public let securityAnswer: String?
    /// - securityQuestion: A security question
    public let securityQuestion: String?
    /// - website: The URL of the client website where the virtual incentive was accrued
    public let website: String?
}

/// Representation of the Hyperwallet's receipt.
public struct HyperwalletReceipt: Decodable, Equatable {
    /// - amount: The gross amount of the transaction.
    public let amount: String?
    /// - createdOn: The datetime the transaction was created on in ISO 8601 format 'YYYY-MM-DDThh:mm:ss' (UTC timezone)
    public let createdOn: String?
    /// - currency: The 3-letter currency code for the transaction.
    public let currency: String?
    /// - destinationToken: A token identifying where the funds were sent.
    public let destinationToken: String?
    /// - details: Details of the transaction.
    public let details: HyperwalletReceiptDetails?
    /// - entry: The type of transaction.
    public let entry: HyperwalletEntryType?
    /// - fee: The fee amount.
    public let fee: String?
    /// - foreignExchangeCurrency: The 3-letter currency code for the foreign exchange.
    public let foreignExchangeCurrency: String?
    /// - foreignExchangeRate: The foreign exchange rate.
    public let foreignExchangeRate: String?
    /// - journalId: The journal entry number for the transaction.
    public let journalId: String?
    /// - sourceToken: A token identifying the source of funds.
    public let sourceToken: String?
    /// - type: The transaction type.
    public let type: HyperwalletReceiptType?

    public static func == (lhs: HyperwalletReceipt, rhs: HyperwalletReceipt) -> Bool {
        return lhs.journalId == rhs.journalId &&
            rhs.entry == lhs.entry &&
            rhs.type == lhs.type
    }

    /// The transaction type.
    public enum HyperwalletReceiptType: String, Decodable {
        /// Generic fee types
        ///
        /// - annualFee: The annual fee
        case annualFee = "ANNUAL_FEE"
        /// - annualFeeRefund: The annual fee refund
        case annualFeeRefund = "ANNUAL_FEE_REFUND"
        /// - customerServiceFee: The customer service fee
        case customerServiceFee = "CUSTOMER_SERVICE_FEE"
        /// - customerServiceFeeRefund: The customer service fee refund
        case customerServiceFeeRefund = "CUSTOMER_SERVICE_FEE_REFUND"
        /// - expeditedShippingFee: The expedited shipping fee
        case expeditedShippingFee = "EXPEDITED_SHIPPING_FEE"
        /// - genericFeeRefund: The generic fee refund
        case genericFeeRefund = "GENERIC_FEE_REFUND"
        /// - monthlyFee: The monthly fee
        case monthlyFee = "MONTHLY_FEE"
        /// - monthlyFeeRefund: The monthly fee refund
        case monthlyFeeRefund = "MONTHLY_FEE_REFUND"
        /// - paymentExpiryFee: The payment expiry fee
        case paymentExpiryFee = "PAYMENT_EXPIRY_FEE"
        /// - paymentFee: The payment fee
        case paymentFee = "PAYMENT_FEE"
        /// - processingFee: The processing fee
        case processingFee = "PROCESSING_FEE"
        /// - standardShippingFee: The standard shipping fee
        case standardShippingFee = "STANDARD_SHIPPING_FEE"
        /// - transferFee: The transfer fee
        case transferFee = "TRANSFER_FEE"
        /// Generic payment types
        ///
        /// - adjustment: The adjustment
        case adjustment = "ADJUSTMENT"
        /// - deposit: The deposit
        case deposit = "DEPOSIT"
        /// - foreignExchange: The foreign exchange
        case foreignExchange = "FOREIGN_EXCHANGE"
        /// - manualAdjustment: The manual adjustment
        case manualAdjustment = "MANUAL_ADJUSTMENT"
        /// - paymentExpiration: The payment expiration
        case paymentExpiration = "PAYMENT_EXPIRATION"
        /// Bank account-specific types
        ///
        /// - bankAccountTransferFee: The bank account transfer fee
        case bankAccountTransferFee = "BANK_ACCOUNT_TRANSFER_FEE"
        /// - bankAccountTransferReturn: The bank account transfer return
        case bankAccountTransferReturn = "BANK_ACCOUNT_TRANSFER_RETURN"
        /// - bankAccountTransferReturnFee: The bank account transfer return fee
        case bankAccountTransferReturnFee = "BANK_ACCOUNT_TRANSFER_RETURN_FEE"
        /// - transferToBankAccount
        case transferToBankAccount = "TRANSFER_TO_BANK_ACCOUNT"
        /// Card-specific types
        ///
        /// - cardActivationFee: The card activation fee
        case cardActivationFee = "CARD_ACTIVATION_FEE"
        /// - cardActivationFeeWaiver: The card activation fee waiver
        case cardActivationFeeWaiver = "CARD_ACTIVATION_FEE_WAIVER"
        /// - cardFee: The card fee
        case cardFee = "CARD_FEE"
        /// - manualTransferToPrepaidCard
        case manualTransferToPrepaidCard = "MANUAL_TRANSFER_TO_PREPAID_CARD"
        /// - prepaidCardBalanceInquiryFee: The prepaid card balance inquiry fee
        case prepaidCardBalanceInquiryFee = "PREPAID_CARD_BALANCE_INQUIRY_FEE"
        /// - prepaidCardCashAdvance: The prepaid card cash advance
        case prepaidCardCashAdvance = "PREPAID_CARD_CASH_ADVANCE"
        /// - prepaidCardDisputedChargeRefund: The prepaid card disputed charge refund
        case prepaidCardDisputedChargeRefund = "PREPAID_CARD_DISPUTED_CHARGE_REFUND"
        /// - prepaidCardDisputeDeposit: The prepaid card dispute deposit
        case prepaidCardDisputeDeposit = "PREPAID_CARD_DISPUTE_DEPOSIT"
        /// - prepaidCardDomesticCashWithdrawalFee: The prepaid card domestic cash withdrawal fee
        case prepaidCardDomesticCashWithdrawalFee = "PREPAID_CARD_DOMESTIC_CASH_WITHDRAWAL_FEE"
        /// - prepaidCardExchangeRateDifference: The prepaid card exchange rate difference
        case prepaidCardExchangeRateDifference = "PREPAID_CARD_EXCHANGE_RATE_DIFFERENCE"
        /// - prepaidCardManualUnload
        case prepaidCardManualUnload = "PREPAID_CARD_MANUAL_UNLOAD"
        /// - prepaidCardOverseasCashWithdrawalFee: The prepaid card overseas cash withdrawal fee
        case prepaidCardOverseasCashWithdrawalFee = "PREPAID_CARD_OVERSEAS_CASH_WITHDRAWAL_FEE"
        /// - prepaidCardPinChangeFee: The prepaid card pin change fee
        case prepaidCardPinChangeFee = "PREPAID_CARD_PIN_CHANGE_FEE"
        /// - prepaidCardRefund
        case prepaidCardRefund = "PREPAID_CARD_REFUND"
        /// - prepaidCardReplacementFee: The prepaid card replacement fee
        case prepaidCardReplacementFee = "PREPAID_CARD_REPLACEMENT_FEE"
        /// - prepaidCardSaleReversal
        case prepaidCardSaleReversal = "PREPAID_CARD_SALE_REVERSAL"
        /// - prepaidCardUnload
        case prepaidCardUnload = "PREPAID_CARD_UNLOAD"
        /// - transferToDebitCard
        case transferToDebitCard = "TRANSFER_TO_DEBIT_CARD"
        /// - transferToPrepaidCard
        case transferToPrepaidCard = "TRANSFER_TO_PREPAID_CARD"
        /// Donation types
        ///
        /// - donation
        case donation = "DONATION"
        /// - donationFee
        case donationFee = "DONATION_FEE"
        /// - donationReturn
        case donationReturn = "DONATION_RETURN"
        /// Merchant payment types
        ///
        /// - merchantPayment: The merchant payment
        case merchantPayment = "MERCHANT_PAYMENT"
        /// - merchantPaymentFee: The merchant payment fee
        case merchantPaymentFee = "MERCHANT_PAYMENT_FEE"
        /// - merchantPaymentRefund: The merchant payment refund
        case merchantPaymentRefund = "MERCHANT_PAYMENT_REFUND"
        /// - merchantPaymentReturn
        case merchantPaymentReturn = "MERCHANT_PAYMENT_RETURN"
        /// MoneyGram types
        ///
        /// - moneygramTransferReturn
        case moneygramTransferReturn = "MONEYGRAM_TRANSFER_RETURN"
        /// - transferToMoneygram
        case transferToMoneygram = "TRANSFER_TO_MONEYGRAM"
        /// Paper check types
        ///
        /// - paperCheckFee: The paper check fee
        case paperCheckFee = "PAPER_CHECK_FEE"
        /// - paperCheckRefund: The paper check refund
        case paperCheckRefund = "PAPER_CHECK_REFUND"
        /// - transferToPaperCheck
        case transferToPaperCheck = "TRANSFER_TO_PAPER_CHECK"
        /// User and program account types
        ///
        /// - accountClosure: The account to be closed
        case accountClosure = "ACCOUNT_CLOSURE"
        /// - accountClosureFee: The account closure fee
        case accountClosureFee = "ACCOUNT_CLOSURE_FEE"
        /// - accountUnload
        case accountUnload = "ACCOUNT_UNLOAD"
        /// - dormantUserFee: The dormant user fee
        case dormantUserFee = "DORMANT_USER_FEE"
        /// - dormantUserFeeRefund: The dormant user fee refund
        case dormantUserFeeRefund = "DORMANT_USER_FEE_REFUND"
        /// - payment
        case payment = "PAYMENT"
        /// - paymentCancellation
        case paymentCancellation = "PAYMENT_CANCELLATION"
        /// - paymentReversal
        case paymentReversal = "PAYMENT_REVERSAL"
        /// - paymentReversalFee: The payment reversal fee
        case paymentReversalFee = "PAYMENT_REVERSAL_FEE"
        /// - paymentReturn
        case paymentReturn = "PAYMENT_RETURN"
        /// - transferToProgramAccount
        case transferToProgramAccount = "TRANSFER_TO_PROGRAM_ACCOUNT"
        /// - transferToUser
        case transferToUser = "TRANSFER_TO_USER"
        /// Virtual incentive types
        ///
        /// - virtualIncentiveCancellation
        case virtualIncentiveCancellation = "VIRTUAL_INCENTIVE_CANCELLATION"
        /// - virtualIncentiveIssuance
        case virtualIncentiveIssuance = "VIRTUAL_INCENTIVE_ISSUANCE"
        /// - virtualIncentivePurchase
        case virtualIncentivePurchase = "VIRTUAL_INCENTIVE_PURCHASE"
        /// - virtualIncentiveRefund
        case virtualIncentiveRefund = "VIRTUAL_INCENTIVE_REFUND"
        /// Western Union and WUBS types
        ///
        /// - transferToWesternUnion
        case transferToWesternUnion = "TRANSFER_TO_WESTERN_UNION"
        /// - transferToWubsWire
        case transferToWubsWire = "TRANSFER_TO_WUBS_WIRE"
        /// - westernUnionTransferReturn
        case westernUnionTransferReturn = "WESTERN_UNION_TRANSFER_RETURN"
        /// - wubsWireTransferReturn
        case wubsWireTransferReturn = "WUBS_WIRE_TRANSFER_RETURN"
        /// Wire transfer types
        ///
        /// - transferToWire
        case transferToWire = "TRANSFER_TO_WIRE"
        /// - wireTransferFee
        case wireTransferFee = "WIRE_TRANSFER_FEE"
        /// - wireTransferReturn
        case wireTransferReturn = "WIRE_TRANSFER_RETURN"
        /// - prepaidCardSale
        case prepaidCardSale = "PREPAID_CARD_SALE"
        /// PayPal transfer types
        ///
        /// - transferToPayPalAccount:
        case transferToPayPalAccount = "TRANSFER_TO_PAYPAL_ACCOUNT"
        /// Default - unknown transfer type
        case unknown = "UNKNOWN_RECEIPT_TYPE"
    }

    /// The entry type.
    public enum HyperwalletEntryType: String, Decodable {
        /// - credit: The credit entry type
        case credit = "CREDIT"
        /// - debit: The debit entry type
        case debit = "DEBIT"
    }
    /// The bank account type
    public enum BankAccountPurposeType: String, Decodable {
        /// - checking
        case checking = "CHECKING"
        /// - savings
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
