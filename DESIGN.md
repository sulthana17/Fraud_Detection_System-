# Design Document

Project Title: Fraud_Detection

By Rasviya Sulthana Noor Mohamed

Video overview: https://youtu.be/O_5fnOg1oD8

Entity Relationship Diagram:
    /workspaces/109508868/project/Fraud_detection_diagram.jpg

## Scope

This database is designed to focus on advanced analytics for financial systems. The primary aim is to capture, manage, and analyze data related to user accounts, transactions, flagged activities, and risk scores.
**Users*: Detailed user information.
**Accounts*: User-linked financial accounts.
**Transactions*: Records of all financial activities.
**Flags*: Indicators of suspicious or anomalous transactions.
**Risk Scores*: Assigned values to evaluate transaction and account risks.
**Processing*: Real-time processing and external system integrations.

## Functional Requirements

-Enable tracking and analysis of transactions.
-Highlight flagged activities for review.
-Assign and store risk scores for analytics.
-Generate summary views of user, account, and transaction activities.

## Representation

### Entities

1. Users
-id (INTEGER, PRIMARY KEY, ): Unique user identifier.
-name (TEXT, NOT NULL): User's name.
-email (TEXT, UNIQUE, NOT NULL): User's email.
-phone_number (TEXT, UNIQUE, NOT NULL): User's contact number.
-created_at (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP): User registration date.

2. Accounts
-id (INTEGER, PRIMARY KEY, ): Unique account identifier.
-user_id (INTEGER, FOREIGN KEY REFERENCES Users(id)): Owner of the account.
-account_type (TEXT, CHECK(account_type IN ('savings', 'checking', 'credit'))): Type of account.
-balance (NUMERIC, NOT NULL, CHECK(balance >= 0)): Account balance.
-created_at (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP): Account creation date.

3. Transactions
-id (INTEGER, PRIMARY KEY, ): Unique transaction identifier.
-account_id (INTEGER, FOREIGN KEY REFERENCES Accounts(id)): Linked account.
-amount (NUMERIC, NOT NULL, CHECK(amount > 0)): Transaction amount.
-transaction_type (TEXT, CHECK(transaction_type IN ('Deposit', 'Withdrawal', 'Transfer'))): Type of transaction.
-timestamp (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP): Transaction timestamp.
-location (TEXT): Transaction location.

4. Flags
-id (INTEGER, PRIMARY KEY, ): Unique flag identifier.
-transaction_id (INTEGER, FOREIGN KEY REFERENCES Transactions(id)): Associated transaction.
-flag_type (TEXT, NOT NULL): Reason for flagging.
-description (TEXT, NOT NULL): Details of the flagged activity.
-flagged_at (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP): Timestamp of flag creation.

5. Risk Scores
-id (INTEGER, PRIMARY KEY, ): Unique risk score identifier.
-account_id (INTEGER, FOREIGN KEY REFERENCES Accounts(id)): Associated account.
-transaction_id (INTEGER, FOREIGN KEY REFERENCES Transactions(id)): Associated transaction.
-score (REAL, NOT NULL): Calculated risk score.
-reason (TEXT): Reason for the score.
-calculated_at (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP): Time of calculation.

### Relationships

-**Users to Accounts*: One-to-Many relationship. Each user can own multiple accounts.
-**Accounts to Transactions*: One-to-Many relationship. Each account can have multiple transactions.
-**Transactions to Flags*: One-to-Many relationship. A transaction can be flagged multiple times.
-**Accounts and Transactions to Risk Scores*: Risk scores are associated with specific accounts and transactions.

## Optimizations

*Indexes*
-Index on email and phone_number for user lookups.
-Index on account_id and transaction_type for efficient transaction filtering.
-Composite index on account_id, timestamp for time-based transaction queries.

*Views*
-Flagged Transactions: Summarizes flagged transactions with details.
-High-Risk Accounts: Lists accounts with high average risk scores.
-Transaction Summary: Aggregates transaction types and amounts.
-User Activity: Combines user information with account and transaction activity.

*Triggers*
-Flag Suspicious Transactions: Automatically flags transactions exceeding a predefined threshold.
-Adjust Account Balances: Updates account balances after transactions.
-Calculate Risk Scores: Generates risk scores for transactions dynamically.
-Log Flags: Records flagging details for further analysis.

## Limitations

-Real-time processing capabilities are not supported.
-Analytics are dependent on predefined flagging and scoring rules.

## HELP
For sample_data creation, debugging & brainstorming AI(chatgpt) was used.

