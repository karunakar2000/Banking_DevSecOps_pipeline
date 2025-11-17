package com.dtb.bankingonline.model;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

public class AccountSummary {

    private String accountNumber;
    private String accountType;      // SAVINGS, CURRENT, CREDIT_CARD, etc.
    private String currency;         // e.g. ZAR, USD
    private BigDecimal balance;
    private OffsetDateTime lastUpdated;

    public AccountSummary() {
    }

    public AccountSummary(String accountNumber,
                          String accountType,
                          String currency,
                          BigDecimal balance,
                          OffsetDateTime lastUpdated) {
        this.accountNumber = accountNumber;
        this.accountType = accountType;
        this.currency = currency;
        this.balance = balance;
        this.lastUpdated = lastUpdated;
    }

    public String getAccountNumber() {
        return accountNumber;
    }

    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }

    public String getAccountType() {
        return accountType;
    }

    public void setAccountType(String accountType) {
        this.accountType = accountType;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public BigDecimal getBalance() {
        return balance;
    }

    public void setBalance(BigDecimal balance) {
        this.balance = balance;
    }

    public OffsetDateTime getLastUpdated() {
        return lastUpdated;
    }

    public void setLastUpdated(OffsetDateTime lastUpdated) {
        this.lastUpdated = lastUpdated;
    }
}

