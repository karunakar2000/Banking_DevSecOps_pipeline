package com.dtb.bankingonline.controller;

import com.dtb.bankingonline.model.AccountSummary;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/accounts")
public class AccountController {

    @GetMapping("/summary")
    public ResponseEntity<List<AccountSummary>> getAccountSummaries() {

        // Static sample data for portfolio/demo purposes
        List<AccountSummary> accounts = Arrays.asList(
                new AccountSummary(
                        "1002345678",
                        "CURRENT",
                        "ZAR",
                        new BigDecimal("12500.75"),
                        OffsetDateTime.now().minusHours(1)
                ),
                new AccountSummary(
                        "2009876543",
                        "SAVINGS",
                        "ZAR",
                        new BigDecimal("78500.00"),
                        OffsetDateTime.now().minusDays(1)
                ),
                new AccountSummary(
                        "3001112223",
                        "CREDIT_CARD",
                        "ZAR",
                        new BigDecimal("-4500.20"),
                        OffsetDateTime.now().minusMinutes(30)
                )
        );

        return ResponseEntity.ok(accounts);
    }

    @GetMapping("/{accountNumber}/limits")
    public ResponseEntity<Map<String, Object>> getAccountLimits(@PathVariable String accountNumber) {
        // Simple mocked response
        Map<String, Object> limits = Map.of(
                "accountNumber", accountNumber,
                "dailyTransferLimit", "25000.00",
                "onlinePurchaseLimit", "15000.00",
                "atmWithdrawalLimit", "5000.00",
                "currency", "ZAR"
        );
        return ResponseEntity.ok(limits);
    }

    @PostMapping("/{accountNumber}/simulate-transfer")
    public ResponseEntity<Map<String, Object>> simulateTransfer(
            @PathVariable String accountNumber,
            @RequestBody Map<String, Object> request) {

        Map<String, Object> response = Map.of(
                "accountNumber", accountNumber,
                "amount", request.getOrDefault("amount", "0.00"),
                "currency", request.getOrDefault("currency", "ZAR"),
                "targetIban", request.getOrDefault("targetIban", "N/A"),
                "status", "SIMULATED_ONLY",
                "message", "This endpoint simulates a transfer for demo/portfolio purposes."
        );

        return ResponseEntity.ok(response);
    }
}
