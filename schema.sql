-- SQL script for fraud detection database

-- 1. Creating the Tables

-- Represents users in the database
CREATE TABLE "Users" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "dob" DATE NOT NULL,
    "email" TEXT UNIQUE NOT NULL,
    "address" TEXT NOT NULL,
    "phone_number" INTEGER NOT NULL,
    PRIMARY KEY ("id")
);

-- Represents accounts in database
CREATE TABLE "Accounts" (
    "id" INTEGER,
    "user_id" INTEGER,
    "limit_id" INTEGER,
    "account_type" TEXT NOT NULL CHECK("account_type" IN ('checking','savings','credit','business','joint','fixed deposit','investment','retirement','virtual')),
    "balance" NUMERIC NOT NULL CHECK("balance" > 0),
    "created_timestamp" TIMESTAMP NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY ("user_id") REFERENCES "Users"("id"),
    FOREIGN KEY ("limit_id") REFERENCES "Transaction_Limits"("limit_id")
);

-- Represents transactions recorded
CREATE TABLE "Transactions" (
    "transaction_id" INTEGER,
    "account_id" INTEGER,
    "category_id" INTEGER,
    "amount" NUMERIC NOT NULL CHECK ("amount" > 0),
    "transaction_type" TEXT NOT NULL CHECK("transaction_type" IN ('Deposit','Withdrawal','Transfer','Bill Payment','Loan Payment','Refund','Fee','Interest','Foreign Exchange','Cashback')),
    "timestamp" TIMESTAMP NOT NULL,
    "location" TEXT NOT NULL,
    "description" TEXT,
    PRIMARY KEY("transaction_id"),
    FOREIGN KEY ("account_id") REFERENCES "Accounts"("id"),
    FOREIGN KEY ("category_id") REFERENCES "Trans_Categories"("category_id")
);

-- Represents categories of transactions done
CREATE TABLE "Trans_Categories" (
    "category_id" INTEGER,
    "category_name" TEXT NOT NULL,
    PRIMARY KEY ("category_id")
);

-- Represents internet login of user
CREATE TABLE "User_Credential" (
    "id" INTEGER,
    "user_id" INTEGER,
    "username" TEXT NOT NULL UNIQUE,
    "password_hash" TEXT NOT NULL,
    "created_at" TIMESTAMP NOT NULL,
    "last_updated_at" TIMESTAMP,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("user_id") REFERENCES "Users"("id")
);

-- Represents login information
CREATE TABLE "User_Logs" (
    "log_id" INTEGER,
    "user_credential_id" INTEGER,
    "login_timestamp" TIMESTAMP NOT NULL,
    "device_info" TEXT NOT NULL,
    "ip_address" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    PRIMARY KEY ("log_id"),
    FOREIGN KEY ("user_credential_id") REFERENCES "User_Credential"("id")
);

-- Represents records when user changes their password or username
CREATE TABLE "User_Changes_Log" (
    "change_id" INTEGER,
    "user_id" INTEGER,
    "user_credential_id" INTEGER,
    "change_type" TEXT NOT NULL CHECK("change_type" IN ('Password_Change', 'Username_Change')),
    "old_value" TEXT NOT NULL,
    "new_value" TEXT NOT NULL,
    "change_timestamp" TIMESTAMP NOT NULL,
    PRIMARY KEY ("change_id"),
    FOREIGN KEY ("user_id") REFERENCES "Users"("id"),
    FOREIGN KEY ("user_credential_id") REFERENCES "User_Credential"("id")
);

-- Represents the IP address of suspicious activity
CREATE TABLE "Suspicious_ip" (
    "ip_id" INTEGER,
    "ip_address" TEXT NOT NULL UNIQUE,
    "flag_reason" TEXT NOT NULL,
    "last_seen_timestamp" TIMESTAMP NOT NULL,
    PRIMARY KEY ("ip_id")
);

-- Represents alerts of transactions sent to users
CREATE TABLE "Alert_Notification" (
    "alert_id" INTEGER,
    "user_id" INTEGER,
    "transaction_id" INTEGER,
    "alert_type_id" INTEGER,
    "alert_timestamp" TIMESTAMP NOT NULL,
    "status" TEXT NOT NULL,
    PRIMARY KEY ("alert_id"),
    FOREIGN KEY ("user_id") REFERENCES "Users"("id"),
    FOREIGN KEY ("transaction_id") REFERENCES "Transactions"("transaction_id"),
    FOREIGN KEY ("alert_type_id") REFERENCES "Alert_Category"("alert_type_id")
);

-- Represents categories of alerts
CREATE TABLE "Alert_Category" (
    "alert_type_id" INTEGER,
    "alert_name" TEXT NOT NULL,
    PRIMARY KEY ("alert_type_id")
);

-- Represents odd transactions flagged for human correction
CREATE TABLE "Flags" (
    "flag_id" INTEGER,
    "transaction_id" INTEGER,
    "flag_type" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "flag_timestamp" TIMESTAMP NOT NULL,
    PRIMARY KEY ("flag_id"),
    FOREIGN KEY ("transaction_id") REFERENCES "Transactions"("transaction_id")
);

-- Represents details of cards issued to accounts
CREATE TABLE "Card_Details" (
    "card_id" INTEGER,
    "account_id" INTEGER,
    "card_number" TEXT NOT NULL UNIQUE,
    "expiry_date" DATE NOT NULL,
    "card_type" TEXT NOT NULL CHECK("card_type" IN ('Debit','Credit','Prepaid','Charge','Virtual')),
    "cvv_number" NUMERIC NOT NULL,
    "pin_hash" TEXT NOT NULL,
    PRIMARY KEY ("card_id"),
    FOREIGN KEY ("account_id") REFERENCES "Accounts"("id")
);

-- Represents max transaction limits set
CREATE TABLE "Transaction_Limits" (
    "limit_id" INTEGER,
    "account_type" TEXT NOT NULL CHECK("account_type" IN ('checking','savings','credit','business','joint','fixed deposit','investment','retirement','virtual')),
    "max_daily_limit" REAL NOT NULL,
    "max_transaction_amount" REAL NOT NULL,
    PRIMARY KEY ("limit_id")
);

-- Represents accounts repeatedly used for fraud activities
CREATE TABLE "Fraudulent_account" (
    "fraud_id" INTEGER,
    "account_id" INTEGER,
    "reason" TEXT NOT NULL,
    "flagged_timestamp" TIMESTAMP NOT NULL,
    PRIMARY KEY ("fraud_id"),
    FOREIGN KEY ("account_id") REFERENCES "Accounts"("id")
);

-- Represents a score given to accounts based on risk
CREATE TABLE "Risk_Scores" (
    "score_id" INTEGER,
    "transaction_id" INTEGER,
    "account_id" INTEGER,
    "risk_score" REAL NOT NULL,
    "score_reason" TEXT,
    "timestamp" TIMESTAMP NOT NULL,
    PRIMARY KEY ("score_id"),
    FOREIGN KEY ("transaction_id") REFERENCES "Transactions"("transaction_id"),
    FOREIGN KEY ("account_id") REFERENCES "Accounts"("id")
);

-- 2. Indexes
-- Index on email in Users table for quick lookup
CREATE INDEX idx_users_email ON Users(email);

-- Index on account_id in Transactions for fast account-specific queries
CREATE INDEX idx_transactions_account_id ON Transactions(account_id);

-- Index on transaction_type in Transactions to optimize queries by type
CREATE INDEX idx_transactions_type ON Transactions(transaction_type);

-- Index on ip_address in Suspicious_ip for quick lookups
CREATE INDEX idx_suspicious_ip_address ON Suspicious_ip(ip_address);

-- Index on phone number in Users table for quick user lookup
CREATE INDEX idx_users_phone_number ON Users(phone_number);

-- Index on dob in Users table for fast filtering by date of birth
CREATE INDEX idx_users_dob ON Users(dob);

-- Index on account_type in Accounts table for faster searches by account type
CREATE INDEX idx_accounts_account_type ON Accounts(account_type);

-- Index on created_timestamp in Accounts for efficient sorting or filtering by account creation date
CREATE INDEX idx_accounts_created_timestamp ON Accounts(created_timestamp);

-- Composite index on (account_id, timestamp) in Transactions for faster account-specific transaction history queries
CREATE INDEX idx_transactions_account_id_timestamp ON Transactions(account_id, timestamp);

-- Index on category_name in Trans_Categories table for faster filtering by category
CREATE INDEX idx_trans_categories_name ON Trans_Categories(category_name);

-- Composite index on (user_id, login_timestamp) in User_Logs for quick retrieval of login history per user
CREATE INDEX idx_user_logs_user_id_timestamp ON User_Logs(user_id, login_timestamp);

-- Index on location in User_Logs for identifying activity from specific locations
CREATE INDEX idx_user_logs_location ON User_Logs(location);

-- Composite index on (ip_address, last_seen_timestamp) in Suspicious_ip for quick identification of recent suspicious IPs
CREATE INDEX idx_suspicious_ip_last_seen ON Suspicious_ip(ip_address, last_seen_timestamp);

-- Composite index on (user_id, transaction_id) in Alert_Notification for fast lookups of alerts by user and transaction
CREATE INDEX idx_alert_notification_user_transaction ON Alert_Notification(user_id, transaction_id);

-- Index on card_number in Card_Details for quick searches for specific cards
CREATE INDEX idx_card_details_card_number ON Card_Details(card_number);

-- Composite index on (account_id, card_type) in Card_Details for efficient filtering of card types per account
CREATE INDEX idx_card_details_account_card_type ON Card_Details(account_id, card_type);

-- Composite index on (account_type, max_transaction_amount) in Transaction_Limits for quick limit lookups by account type
CREATE INDEX idx_transaction_limits_type_amount ON Transaction_Limits(account_type, max_transaction_amount);

-- Index on reason in Fraudulent_account for faster filtering by fraud reasons
CREATE INDEX idx_fraudulent_account_reason ON Fraudulent_account(reason);

-- Composite index on (account_id, risk_score) in Risk_Scores for quick retrieval of high-risk accounts
CREATE INDEX idx_risk_scores_account_score ON Risk_Scores(account_id, risk_score);

-- Composite index on (transaction_id, timestamp) in Risk_Scores for efficient scoring history lookups
CREATE INDEX idx_risk_scores_transaction_timestamp ON Risk_Scores(transaction_id, timestamp);

-- Composite index on (change_type, change_timestamp) in User_Changes_Log for quicker filtering of user changes
CREATE INDEX idx_user_changes_log_type_timestamp ON User_Changes_Log(change_type, change_timestamp);

-- Composite index on (flag_type, flag_timestamp) in Flags for fast filtering of recent flagged transactions
CREATE INDEX idx_flags_type_timestamp ON Flags(flag_type, flag_timestamp);


-- 3. Trigger
-- for logging changes in the User_Changes_Log table
CREATE TRIGGER trigger_user_password_change
AFTER UPDATE ON User_Credential
FOR EACH ROW
WHEN OLD.password_hash != NEW.password_hash
BEGIN
    INSERT INTO User_Changes_Log(user_id, user_credential_id, change_type, old_value, new_value, change_timestamp)
    VALUES (NEW.user_id, NEW.id, 'Password_Change', OLD.password_hash, NEW.password_hash, DATETIME('now'));
END;

-- Trigger to flag suspicious transactions automatically
CREATE TRIGGER trigger_suspicious_transaction
AFTER INSERT ON Transactions
FOR EACH ROW
WHEN NEW.amount > 10000 -- Example threshold for a high-value transaction
BEGIN
    INSERT INTO Flags(transaction_id, flag_type, description, flag_timestamp)
    VALUES (NEW.transaction_id, 'High Value', 'Transaction amount exceeds $10,000', DATETIME('now'));
END;

-- Trigger to add suspicious IPs automatically based on specific IP addresses
CREATE TRIGGER trigger_suspicious_ip_login
AFTER INSERT ON User_Logs
FOR EACH ROW
WHEN NEW.ip_address = '192.168.1.1' -- Example suspicious IP
BEGIN
    INSERT INTO Suspicious_ip(ip_address, flag_reason, last_seen_timestamp)
    VALUES (NEW.ip_address, 'Suspicious activity detected', DATETIME('now'));
END;

-- Trigger: Log failed login attempts based on suspicious IPs
CREATE TRIGGER trigger_failed_login_suspicious_ip
AFTER INSERT ON User_Logs
FOR EACH ROW
WHEN NEW.ip_address IN ('192.168.1.1', '10.0.0.1', '172.16.0.1') -- Add suspicious IPs here
BEGIN
    INSERT INTO Suspicious_ip(ip_address, flag_reason, last_seen_timestamp)
    VALUES (NEW.ip_address, 'Failed login attempt from suspicious IP', DATETIME('now'));
END;

-- Trigger: Flag large withdrawals
CREATE TRIGGER trigger_large_withdrawals
AFTER INSERT ON Transactions
FOR EACH ROW
WHEN NEW.transaction_type = 'Withdrawal' AND NEW.amount > 5000 -- Example threshold
BEGIN
    INSERT INTO Flags(transaction_id, flag_type, description, flag_timestamp)
    VALUES (NEW.transaction_id, 'Large Withdrawal', 'Withdrawal amount exceeds $5,000', DATETIME('now'));
END;

-- Trigger: Notify users when transaction limits are exceeded
CREATE TRIGGER trigger_transaction_limit_exceeded
AFTER INSERT ON Transactions
FOR EACH ROW
WHEN NEW.amount > (SELECT max_transaction_amount FROM Transaction_Limits WHERE account_type = (SELECT account_type FROM Accounts WHERE id = NEW.account_id))
BEGIN
    INSERT INTO Alert_Notification(user_id, transaction_id, alert_type_id, alert_timestamp, status)
    VALUES (
        (SELECT user_id FROM Accounts WHERE id = NEW.account_id), -- User associated with the account
        NEW.transaction_id,
        1, -- Alert type ID for limit exceeded (adjust as per Alert_Category)
        DATETIME('now'),
        'Pending'
    );
END;

-- Trigger: Block transactions from accounts marked as fraudulent
CREATE TRIGGER trigger_block_fraudulent_account
BEFORE INSERT ON Transactions
FOR EACH ROW
WHEN NEW.account_id IN (SELECT account_id FROM Fraudulent_account)
BEGIN
    SELECT RAISE(ABORT, 'Transaction blocked: Account marked as fraudulent');
END;

--Trigger: Monitor account balance and prevent overdrafts
CREATE TRIGGER trigger_prevent_overdrafts
BEFORE INSERT ON Transactions
FOR EACH ROW
WHEN NEW.transaction_type = 'Withdrawal' AND
     (SELECT balance FROM Accounts WHERE id = NEW.account_id) - NEW.amount < 0
BEGIN
    SELECT RAISE(ABORT, 'Transaction blocked: Insufficient balance');
END;

-- Trigger: Notify users when their balance drops below a threshold
CREATE TRIGGER trigger_low_balance_alert
AFTER INSERT ON Transactions
FOR EACH ROW
WHEN (SELECT balance FROM Accounts WHERE id = NEW.account_id) < 100 -- Example low balance threshold
BEGIN
    INSERT INTO Alert_Notification(user_id, transaction_id, alert_type_id, alert_timestamp, status)
    VALUES (
        (SELECT user_id FROM Accounts WHERE id = NEW.account_id), -- User associated with the account
        NEW.transaction_id,
        2, -- Alert type ID for low balance (adjust as per Alert_Category)
        DATETIME('now'),
        'Pending'
    );
END;

-- Trigger: Detect multiple failed logins within a short period
CREATE TRIGGER trigger_multiple_failed_logins
AFTER INSERT ON User_Logs
FOR EACH ROW
WHEN (
    SELECT COUNT(*)
    FROM User_Logs
    WHERE user_credential_id = NEW.user_credential_id
      AND login_timestamp >= DATETIME('now', '-5 minutes')
) > 3 -- More than 3 failed login attempts in 5 minutes
BEGIN
    INSERT INTO Suspicious_ip(ip_address, flag_reason, last_seen_timestamp)
    VALUES (NEW.ip_address, 'Multiple failed login attempts', DATETIME('now'));
END;

--Trigger: Automatically flag foreign transactions above a threshold
CREATE TRIGGER trigger_foreign_transaction_flag
AFTER INSERT ON Transactions
FOR EACH ROW
WHEN NEW.transaction_type = 'Foreign Exchange' AND NEW.amount > 3000 -- Example threshold for foreign transactions
BEGIN
    INSERT INTO Flags(transaction_id, flag_type, description, flag_timestamp)
    VALUES (NEW.transaction_id, 'Foreign Transaction', 'High-value foreign transaction detected', DATETIME('now'));
END;

--Trigger: Track transactions from a flagged Suspicious IP
CREATE TRIGGER trigger_transaction_from_suspicious_ip
AFTER INSERT ON Transactions
FOR EACH ROW
WHEN NEW.location IN (SELECT location FROM Suspicious_ip WHERE flag_reason LIKE '%suspicious%')
BEGIN
    INSERT INTO Flags(transaction_id, flag_type, description, flag_timestamp)
    VALUES (NEW.transaction_id, 'Suspicious IP Transaction', 'Transaction originates from a suspicious IP', DATETIME('now'));
END;

--Trigger: Track changes to transaction limits for audit
CREATE TRIGGER trigger_track_transaction_limit_changes
AFTER UPDATE ON Transaction_Limits
FOR EACH ROW
BEGIN
    INSERT INTO User_Changes_Log(
        user_id, user_credential_id, change_type, old_value, new_value, change_timestamp
    )
    VALUES (
        NULL, -- No specific user involved
        NULL, -- No credential involved
        'Transaction Limit Change',
        OLD.max_transaction_amount || ' (Old Limit)',
        NEW.max_transaction_amount || ' (New Limit)',
        DATETIME('now')
    );
END;

--Trigger: Automatically block duplicate transactions within a short time
CREATE TRIGGER trigger_block_duplicate_transactions
BEFORE INSERT ON Transactions
FOR EACH ROW
WHEN EXISTS (
    SELECT 1
    FROM Transactions
    WHERE account_id = NEW.account_id
      AND amount = NEW.amount
      AND timestamp >= DATETIME('now', '-1 minute')
)
BEGIN
    SELECT RAISE(ABORT, 'Transaction blocked: Possible duplicate detected within 1 minute');
END;

--Trigger: Detect unusually high transaction volume in a day
CREATE TRIGGER trigger_high_daily_transaction_volume
AFTER INSERT ON Transactions
FOR EACH ROW
WHEN (
    SELECT SUM(amount)
    FROM Transactions
    WHERE account_id = NEW.account_id
      AND DATE(timestamp) = DATE('now')
) > (SELECT max_daily_limit FROM Transaction_Limits WHERE account_type = (SELECT account_type FROM Accounts WHERE id = NEW.account_id))
BEGIN
    INSERT INTO Flags(transaction_id, flag_type, description, flag_timestamp)
    VALUES (NEW.transaction_id, 'High Daily Volume', 'Exceeded daily transaction volume limit', DATETIME('now'));
END;

--Trigger: Notify users when a new card is issued
CREATE TRIGGER trigger_new_card_issued
AFTER INSERT ON Card_Details
FOR EACH ROW
BEGIN
    INSERT INTO Alert_Notification(user_id, transaction_id, alert_type_id, alert_timestamp, status)
    VALUES (
        (SELECT user_id FROM Accounts WHERE id = NEW.account_id), -- Get the user associated with the card
        NULL, -- No specific transaction
        3, -- Alert type ID for card issuance
        DATETIME('now'),
        'Pending'
    );
END;

--Trigger: Flag rapid account balance depletion
CREATE TRIGGER trigger_rapid_balance_depletion
AFTER INSERT ON Transactions
FOR EACH ROW
WHEN NEW.transaction_type = 'Withdrawal'
      AND (SELECT balance FROM Accounts WHERE id = NEW.account_id) < 0.2 * (SELECT MAX(balance) FROM Accounts WHERE id = NEW.account_id)
BEGIN
    INSERT INTO Flags(transaction_id, flag_type, description, flag_timestamp)
    VALUES (NEW.transaction_id, 'Balance Depletion', 'Account balance rapidly depleted', DATETIME('now'));
END;

--Trigger: Notify users of successful login from new devices
CREATE TRIGGER trigger_new_device_login
AFTER INSERT ON User_Logs
FOR EACH ROW
WHEN NEW.device_info NOT IN (
    SELECT device_info
    FROM User_Logs
    WHERE user_credential_id = NEW.user_credential_id
)
BEGIN
    INSERT INTO Alert_Notification(user_id, transaction_id, alert_type_id, alert_timestamp, status)
    VALUES (
        (SELECT user_id FROM User_Credential WHERE id = NEW.user_credential_id), -- User who logged in
        NULL, -- No specific transaction
        4, -- Alert type ID for new device login
        DATETIME('now'),
        'Pending'
    );
END;

--Detect Account Creation from Blacklisted IPs
CREATE TRIGGER trigger_account_creation_blacklisted_ip
AFTER INSERT ON Users
FOR EACH ROW
WHEN NEW.id IN (
    SELECT user_id
    FROM User_Logs
    WHERE ip_address IN (SELECT ip_address FROM Suspicious_ip)
)
BEGIN
    INSERT INTO Flags(flag_type, description, flag_timestamp)
    VALUES ('Account Blacklisted IP', 'Account created from a blacklisted IP address', DATETIME('now'));
END;

--Monitor High Number of Login Attempts from Different Locations
CREATE TRIGGER trigger_multiple_login_locations
AFTER INSERT ON User_Logs
FOR EACH ROW
WHEN (
    SELECT COUNT(DISTINCT location)
    FROM User_Logs
    WHERE user_credential_id = NEW.user_credential_id
      AND login_timestamp >= DATETIME('now', '-1 day')
) > 3 -- More than 3 distinct locations in a day
BEGIN
    INSERT INTO Alert_Notification(user_id, transaction_id, alert_type_id, alert_timestamp, status)
    VALUES (
        (SELECT user_id FROM User_Credential WHERE id = NEW.user_credential_id),
        NULL,
        6, -- Alert type ID for multiple login locations
        DATETIME('now'),
        'Pending'
    );
END;

--Auto-Block Transactions from Flagged Accounts
CREATE TRIGGER trigger_block_flagged_account_transaction
BEFORE INSERT ON Transactions
FOR EACH ROW
WHEN NEW.account_id IN (SELECT account_id FROM Fraudulent_account)
BEGIN
    SELECT RAISE(ABORT, 'Transaction blocked: Account flagged for fraud');
END;

--Flag Multiple Small Transactions in Quick Succession
CREATE TRIGGER trigger_multiple_small_transactions
AFTER INSERT ON Transactions
FOR EACH ROW
WHEN (
    SELECT COUNT(*)
    FROM Transactions
    WHERE account_id = NEW.account_id
      AND amount < 1000 -- Example small amount threshold
      AND timestamp >= DATETIME('now', '-5 minutes')
) > 5 -- More than 5 small transactions in 5 minutes
BEGIN
    INSERT INTO Flags(transaction_id, flag_type, description, flag_timestamp)
    VALUES (NEW.transaction_id, 'Smurfing', 'Multiple small transactions in quick succession', DATETIME('now'));
END;

--4.VIEWS
--Shows recent login activity for all users
CREATE VIEW UserLoginActivity AS
SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    ul.login_timestamp,
    ul.device_info,
    ul.ip_address
FROM Users u
JOIN User_Logs ul ON u.user_id = ul.user_credential_id;

--Lists transactions flagged as high risk
CREATE VIEW HighRiskTransactions AS
SELECT
    t.transaction_id,
    t.account_id,
    t.amount,
    t.timestamp,
    rs.risk_score,
    rs.score_reason
FROM Transactions t
JOIN Risk_Scores rs ON t.transaction_id = rs.transaction_id
WHERE rs.risk_score > 8.0;

--Displays accounts flagged for fraudulent activity
CREATE VIEW FraudulentAccounts AS
SELECT
    fa.fraud_id,
    a.account_id,
    a.user_id,
    u.first_name,
    u.last_name,
    fa.reason,
    fa.flagged_timestamp
FROM Fraudulent_Account fa
JOIN Accounts a ON fa.account_id = a.account_id
JOIN Users u ON a.user_id = u.user_id;

--Summarizes transactions for each user
CREATE VIEW UserTransactionSummary AS
SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    COUNT(t.transaction_id) AS total_transactions,
    SUM(t.amount) AS total_spent
FROM Users u
JOIN Accounts a ON u.user_id = a.user_id
JOIN Transactions t ON a.account_id = t.account_id
GROUP BY u.user_id;

--Lists users associated with suspicious IP addresses
CREATE VIEW SuspiciousIPActivity AS
SELECT
    si.ip_id,
    si.ip_address,
    si.flag_reason,
    u.user_id,
    u.first_name,
    u.last_name
FROM Suspicious_IP si
JOIN User_Logs ul ON si.ip_address = ul.ip_address
JOIN Users u ON ul.user_credential_id = u.user_id;

--Shows alerts triggered for transactions
CREATE VIEW TransactionAlerts AS
SELECT
    an.alert_id,
    an.user_id,
    an.transaction_id,
    ac.alert_name,
    an.status,
    an.alert_timestamp
FROM Alert_Notification an
JOIN Alert_Categories ac ON an.alert_type_id = ac.alert_type_id;

--Aggregates daily spending for each account
CREATE VIEW DailySpendingPerAccount AS
SELECT
    t.account_id,
    DATE(t.timestamp) AS transaction_date,
    SUM(t.amount) AS daily_spent
FROM Transactions t
GROUP BY t.account_id, DATE(t.timestamp);

--Provides a summary of card activity
CREATE VIEW CardUsageSummary AS
SELECT
    c.card_id,
    c.card_type,
    c.expiry_date,
    COUNT(t.transaction_id) AS total_transactions,
    SUM(t.amount) AS total_amount
FROM Card_Details c
JOIN Accounts a ON c.account_id = a.account_id
JOIN Transactions t ON a.account_id = t.account_id
GROUP BY c.card_id;

--Details transactions flagged for manual review
CREATE VIEW FlaggedTransactions AS
SELECT
    f.flag_id,
    f.transaction_id,
    t.account_id,
    t.amount,
    f.flag_reason,
    f.flag_timestamp
FROM Flags f
JOIN Transactions t ON f.transaction_id = t.transaction_id;

--Summarizes risk scores for accounts
CREATE VIEW AccountRiskScores AS
SELECT
    a.account_id,
    u.first_name,
    u.last_name,
    AVG(rs.risk_score) AS avg_risk_score
FROM Accounts a
JOIN Users u ON a.user_id = u.user_id
JOIN Transactions t ON a.account_id = t.account_id
JOIN Risk_Scores rs ON t.transaction_id = rs.transaction_id
GROUP BY a.account_id;
