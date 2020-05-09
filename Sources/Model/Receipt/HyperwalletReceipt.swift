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
    /// The bank account number, IBAN or equivalent
    public let bankAccountId: String?
    /// The bank account type, e.g. CHECKING or SAVINGS
    public let bankAccountPurpose: HyperwalletReceipt.BankAccountPurposeType?
    /// The bank code, BIC/SWIFT or equivalent
    public let bankId: String?
    /// The bank name
    public let bankName: String?
    /// The branch address, first line
    public let branchAddressLine1: String?
    /// The branch address, second line
    public let branchAddressLine2: String?
    /// The branch city
    public let branchCity: String?
    /// The 2-letter country code of the branch
    public let branchCountry: String?
    /// The branch code or equivalent
    public let branchId: String?
    /// The branch name
    public let branchName: String?
    /// The branch postal code
    public let branchPostalCode: String?
    /// The branch state or province
    public let branchStateProvince: String?
    /// The card expiry date in YYYY-MM format
    public let cardExpiryDate: String?
    /// The card holder's full name
    public let cardHolderName: String?
    /// The card number
    public let cardNumber: String?
    /// The name of the charity that is receiving the donation
    public let charityName: String?
    /// The paper check number
    public let checkNumber: String?
    /// The client-assigned transaction identifier
    public let clientPaymentId: String?
    /// An internal note added by a client operator
    public let memo: String?
    /// A description for the receipt
    public let notes: String?
    /// The payee's address first line
    public let payeeAddressLine1: String?
    /// The payee's address, second line
    public let payeeAddressLine2: String?
    /// The payee's city
    public let payeeCity: String?
    /// The payee's 2-letter country code
    public let payeeCountry: String?
    /// The payee's email address on record
    public let payeeEmail: String?
    /// The payee's full name
    public let payeeName: String?
    /// The payee's postal code, ZIP code or equivalent
    public let payeePostalCode: String?
    /// The payee's state or province
    public let payeeStateProvince: String?
    /// The payer's full name
    public let payerName: String?
    /// The payment expiry date in YYYY-MM-DD format
    public let paymentExpiryDate: String?
    /// The reason for returning or recalling the payment
    public let returnOrRecallReason: String?
    /// The answer to the securityQuestion
    public let securityAnswer: String?
    /// A security question
    public let securityQuestion: String?
    /// The URL of the client website where the virtual incentive was accrued
    public let website: String?
}

/// Representation of the Hyperwallet's receipt.
public struct HyperwalletReceipt: Decodable, Equatable {
    /// The gross amount of the transaction.
    public let amount: String?
    /// The datetime the transaction was created on in ISO 8601 format 'YYYY-MM-DDThh:mm:ss' (UTC timezone)
    public let createdOn: String?
    /// The 3-letter currency code for the transaction.
    public let currency: String?
    /// A token identifying where the funds were sent.
    public let destinationToken: String?
    /// Details of the transaction.
    public let details: HyperwalletReceiptDetails?
    /// The type of transaction.
    public let entry: HyperwalletEntryType?
    /// The fee amount.
    public let fee: String?
    /// The 3-letter currency code for the foreign exchange.
    public let foreignExchangeCurrency: String?
    /// The foreign exchange rate.
    public let foreignExchangeRate: String?
    /// The journal entry number for the transaction.
    public let journalId: String?
    /// A token identifying the source of funds.
    public let sourceToken: String?
    /// The transaction type.
    public let type: HyperwalletReceiptType?

    public static func == (lhs: HyperwalletReceipt, rhs: HyperwalletReceipt) -> Bool {
        return lhs.journalId == rhs.journalId &&
            rhs.entry == lhs.entry &&
            rhs.type == lhs.type
    }

    /// The transaction type.
    public enum HyperwalletReceiptType: String, Decodable {
        // Generic fee types
        ///
        /// The annual fee
        case annualFee = "ANNUAL_FEE"
        /// The annual fee refund
        case annualFeeRefund = "ANNUAL_FEE_REFUND"
        /// The customer service fee
        case customerServiceFee = "CUSTOMER_SERVICE_FEE"
        /// The customer service fee refund
        case customerServiceFeeRefund = "CUSTOMER_SERVICE_FEE_REFUND"
        /// The expedited shipping fee
        case expeditedShippingFee = "EXPEDITED_SHIPPING_FEE"
        /// The generic fee refund
        case genericFeeRefund = "GENERIC_FEE_REFUND"
        /// The monthly fee
        case monthlyFee = "MONTHLY_FEE"
        /// The monthly fee refund
        case monthlyFeeRefund = "MONTHLY_FEE_REFUND"
        /// The payment expiry fee
        case paymentExpiryFee = "PAYMENT_EXPIRY_FEE"
        /// The payment fee
        case paymentFee = "PAYMENT_FEE"
        /// The processing fee
        case processingFee = "PROCESSING_FEE"
        /// The standard shipping fee
        case standardShippingFee = "STANDARD_SHIPPING_FEE"
        /// The transfer fee
        case transferFee = "TRANSFER_FEE"
        // Generic payment types
        ///
        /// The adjustment
        case adjustment = "ADJUSTMENT"
        /// The deposit
        case deposit = "DEPOSIT"
        /// The foreign exchange
        case foreignExchange = "FOREIGN_EXCHANGE"
        /// The manual adjustment
        case manualAdjustment = "MANUAL_ADJUSTMENT"
        /// The payment expiration
        case paymentExpiration = "PAYMENT_EXPIRATION"
        // Bank account-specific types
        ///
        /// The bank account transfer fee
        case bankAccountTransferFee = "BANK_ACCOUNT_TRANSFER_FEE"
        /// The bank account transfer return
        case bankAccountTransferReturn = "BANK_ACCOUNT_TRANSFER_RETURN"
        /// The bank account transfer return fee
        case bankAccountTransferReturnFee = "BANK_ACCOUNT_TRANSFER_RETURN_FEE"
        ///
        case transferToBankAccount = "TRANSFER_TO_BANK_ACCOUNT"
        // Card-specific types
        ///
        /// The card activation fee
        case cardActivationFee = "CARD_ACTIVATION_FEE"
        /// The card activation fee waiver
        case cardActivationFeeWaiver = "CARD_ACTIVATION_FEE_WAIVER"
        /// The card fee
        case cardFee = "CARD_FEE"
        /// The manual transfer to prepaid card
        case manualTransferToPrepaidCard = "MANUAL_TRANSFER_TO_PREPAID_CARD"
        /// The prepaid card balance inquiry fee
        case prepaidCardBalanceInquiryFee = "PREPAID_CARD_BALANCE_INQUIRY_FEE"
        /// The prepaid card cash advance
        case prepaidCardCashAdvance = "PREPAID_CARD_CASH_ADVANCE"
        /// The prepaid card disputed charge refund
        case prepaidCardDisputedChargeRefund = "PREPAID_CARD_DISPUTED_CHARGE_REFUND"
        /// The prepaid card dispute deposit
        case prepaidCardDisputeDeposit = "PREPAID_CARD_DISPUTE_DEPOSIT"
        /// The prepaid card domestic cash withdrawal fee
        case prepaidCardDomesticCashWithdrawalFee = "PREPAID_CARD_DOMESTIC_CASH_WITHDRAWAL_FEE"
        /// The prepaid card exchange rate difference
        case prepaidCardExchangeRateDifference = "PREPAID_CARD_EXCHANGE_RATE_DIFFERENCE"
        /// The prepaid card manual unload
        case prepaidCardManualUnload = "PREPAID_CARD_MANUAL_UNLOAD"
        /// The prepaid card overseas cash withdrawal fee
        case prepaidCardOverseasCashWithdrawalFee = "PREPAID_CARD_OVERSEAS_CASH_WITHDRAWAL_FEE"
        /// The prepaid card pin change fee
        case prepaidCardPinChangeFee = "PREPAID_CARD_PIN_CHANGE_FEE"
        /// The prepaid card refund
        case prepaidCardRefund = "PREPAID_CARD_REFUND"
        /// The prepaid card replacement fee
        case prepaidCardReplacementFee = "PREPAID_CARD_REPLACEMENT_FEE"
        /// The prepaid card sale reversal
        case prepaidCardSaleReversal = "PREPAID_CARD_SALE_REVERSAL"
        /// The prepaid card unload
        case prepaidCardUnload = "PREPAID_CARD_UNLOAD"
        /// The transfer to debitcard
        case transferToDebitCard = "TRANSFER_TO_DEBIT_CARD"
        /// The transfer to prepaid card
        case transferToPrepaidCard = "TRANSFER_TO_PREPAID_CARD"
        // Donation types
        ///
        /// The donation
        case donation = "DONATION"
        /// The donation fee
        case donationFee = "DONATION_FEE"
        /// The donation return
        case donationReturn = "DONATION_RETURN"
        // Merchant payment types
        ///
        /// The merchant payment
        case merchantPayment = "MERCHANT_PAYMENT"
        /// The merchant payment fee
        case merchantPaymentFee = "MERCHANT_PAYMENT_FEE"
        /// The merchant payment refund
        case merchantPaymentRefund = "MERCHANT_PAYMENT_REFUND"
        /// The merchant payment return
        case merchantPaymentReturn = "MERCHANT_PAYMENT_RETURN"
        // MoneyGram types
        ///
        /// The money gram transfer return
        case moneygramTransferReturn = "MONEYGRAM_TRANSFER_RETURN"
        /// The transfer to money gram
        case transferToMoneygram = "TRANSFER_TO_MONEYGRAM"
        // Paper check types
        ///
        /// The paper check fee
        case paperCheckFee = "PAPER_CHECK_FEE"
        /// The paper check refund
        case paperCheckRefund = "PAPER_CHECK_REFUND"
        /// The transfer to paper check
        case transferToPaperCheck = "TRANSFER_TO_PAPER_CHECK"
        // User and program account types
        ///
        /// The account to be closed
        case accountClosure = "ACCOUNT_CLOSURE"
        /// The account closure fee
        case accountClosureFee = "ACCOUNT_CLOSURE_FEE"
        /// The account unload
        case accountUnload = "ACCOUNT_UNLOAD"
        /// The dormant user fee
        case dormantUserFee = "DORMANT_USER_FEE"
        /// The dormant user fee refund
        case dormantUserFeeRefund = "DORMANT_USER_FEE_REFUND"
        /// The payment
        case payment = "PAYMENT"
        /// The payment cancellation
        case paymentCancellation = "PAYMENT_CANCELLATION"
        /// The payment reversal
        case paymentReversal = "PAYMENT_REVERSAL"
        /// The payment reversal fee
        case paymentReversalFee = "PAYMENT_REVERSAL_FEE"
        /// The payment return
        case paymentReturn = "PAYMENT_RETURN"
        /// The transfer to program account
        case transferToProgramAccount = "TRANSFER_TO_PROGRAM_ACCOUNT"
        /// The transfer to user
        case transferToUser = "TRANSFER_TO_USER"
        // Virtual incentive types
        ///
        /// The virtual incentive cancellation
        case virtualIncentiveCancellation = "VIRTUAL_INCENTIVE_CANCELLATION"
        /// The virtual incentive issuance
        case virtualIncentiveIssuance = "VIRTUAL_INCENTIVE_ISSUANCE"
        /// The virtual incentive purchase
        case virtualIncentivePurchase = "VIRTUAL_INCENTIVE_PURCHASE"
        /// The virtual incentive refund
        case virtualIncentiveRefund = "VIRTUAL_INCENTIVE_REFUND"
        // Western Union and WUBS types
        ///
        /// The transfer to western union
        case transferToWesternUnion = "TRANSFER_TO_WESTERN_UNION"
        /// The transfer to wubs wire
        case transferToWubsWire = "TRANSFER_TO_WUBS_WIRE"
        /// The western union transfer return
        case westernUnionTransferReturn = "WESTERN_UNION_TRANSFER_RETURN"
        /// The wubs wire transfer return
        case wubsWireTransferReturn = "WUBS_WIRE_TRANSFER_RETURN"
        // Wire transfer types
        ///
        /// The transfer to Wire
        case transferToWire = "TRANSFER_TO_WIRE"
        /// The wire transfer fee
        case wireTransferFee = "WIRE_TRANSFER_FEE"
        /// The wire transfer return
        case wireTransferReturn = "WIRE_TRANSFER_RETURN"
        /// The prepaid card sale
        case prepaidCardSale = "PREPAID_CARD_SALE"
        // PayPal transfer types
        ///
        /// Transfer to PayPalAccount
        case transferToPayPalAccount = "TRANSFER_TO_PAYPAL_ACCOUNT"
        /// Default - unknown transfer type
        case unknown = "UNKNOWN_RECEIPT_TYPE"
    }

    /// The entry type.
    public enum HyperwalletEntryType: String, Decodable {
        /// The credit entry type
        case credit = "CREDIT"
        /// The debit entry type
        case debit = "DEBIT"
    }
    /// The bank account purpose type
    public enum BankAccountPurposeType: String, Decodable {
        /// The bank account checking type
        case checking = "CHECKING"
        /// The bank account savings type
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
