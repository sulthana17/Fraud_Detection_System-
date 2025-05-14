-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

--Insert data from csv files into tables

--insert data from csv file into Users
.mode csv
.import --skip 1 /workspaces/109508868/project/project_CSV/users.csv Users

--insert data from csv file into accounts
.mode csv
.import --skip 1 /workspaces/109508868/project/project_CSV/accounts.csv Accounts

--insert data from csv file into transaction limit
.mode csv
.import --skip 1 /workspaces/109508868/project/project_CSV/transaction_limits.csv Transaction_Limits

--insert data from csv file into trans_categories
.mode csv
.import --skip 1 /workspaces/109508868/project/project_CSV/trans_categories.csv Trans_Categories

--insert data from csv file into transaction
.mode csv
.import --skip 1 /workspaces/109508868/project/project_CSV/transactions.csv Transactions

--insert data from csv file into User_Credential
.mode csv
.import --skip 1 /workspaces/109508868/project/project_CSV/user_credentials.csv User_Credential

--insert data from csv file into User_Logs
.mode csv
.import --skip 1 /workspaces/109508868/project/project_CSV/user_logs.csv User_Logs

--insert data from csv file into User_Changes_Log
.mode csv
.import --skip 1 /workspaces/109508868/project/project_CSV/user_changes_log.csv User_Changes_Log

--insert data from csv file into Suspicious_ip
.mode csv
.import --skip 1 /workspaces/109508868/project/project_CSV/suspicious_ips.csv Suspicious_ip

--insert data from csv file into Alert_Category
.mode csv
.import --skip 1 /workspaces/109508868/project/project_CSV/alert_categories.csv Alert_Category

--insert data from csv file into Alert_Notification
.mode csv
.import --skip 1 /workspaces/109508868/project/project_CSV/alert_notifications.csv Alert_Notification

--insert data from csv file into Flags
.mode csv
.import --skip 1 /workspaces/109508868/project/project_CSV/flags.csv Flags

--insert data from csv file into Card_Details
.mode csv
.import --skip 1 /workspaces/109508868/project/project_CSV/card_details.csv Card_Details

--insert data from csv file into Fraudulent_account
.mode csv
.import --skip 1 /workspaces/109508868/project/project_CSV/fraudulent_accounts.csv Fraudulent_account

--insert data from csv file into Risk_Scores
.mode csv
.import --skip 1 /workspaces/109508868/project/project_CSV/risk_scores.csv Risk_Scores

-- 2. Sample Queries
-- Retrieve a list of all users
SELECT id, first_name, last_name, dob, email, phone_number
FROM Users
ORDER BY last_name, first_name;

--Find users older than 50 years
SELECT first_name, last_name, dob, email
FROM Users
WHERE DATE('now') - dob > 50 * 365;

--Count the total number of users
SELECT COUNT(*) AS total_users
FROM Users;

--List all accounts with their owners
SELECT a.id AS account_id, u.first_name, u.last_name, a.account_type, a.balance
FROM Accounts a
JOIN Users u ON a.user_id = u.id
ORDER BY a.created_timestamp DESC;

--Find accounts with a balance exceeding $50,000
SELECT id AS account_id, account_type, balance
FROM Accounts
WHERE balance > 50000
ORDER BY balance DESC;

--Count the total number of accounts by account type
SELECT account_type, COUNT(*) AS total_accounts
FROM Accounts
GROUP BY account_type
ORDER BY total_accounts DESC;

--List the top 10 highest-value transactions
SELECT transaction_id, account_id, amount, transaction_type, timestamp
FROM Transactions
ORDER BY amount DESC
LIMIT 10;

--Find all transactions for a specific account
SELECT transaction_id, amount, transaction_type, timestamp, location, description
FROM Transactions
WHERE account_id = 1
ORDER BY timestamp DESC;

--Calculate the total value of transactions by type
SELECT transaction_type, SUM(amount) AS total_amount
FROM Transactions
GROUP BY transaction_type
ORDER BY total_amount DESC;

--List all transaction categories
SELECT category_id, category_name
FROM Trans_Categories;

--Find the number of transactions per category
SELECT tc.category_name, COUNT(t.transaction_id) AS total_transactions
FROM Trans_Categories tc
LEFT JOIN Transactions t ON tc.category_id = t.category_id
GROUP BY tc.category_name
ORDER BY total_transactions DESC;

--Retrieve all pending alerts
SELECT an.alert_id, u.first_name, u.last_name, t.amount, an.status, an.alert_timestamp
FROM Alert_Notification an
JOIN Users u ON an.user_id = u.id
JOIN Transactions t ON an.transaction_id = t.transaction_id
WHERE an.status = 'Pending'
ORDER BY an.alert_timestamp DESC;

--Find the most common alert types
SELECT ac.alert_name, COUNT(an.alert_id) AS total_alerts
FROM Alert_Category ac
LEFT JOIN Alert_Notification an ON ac.alert_type_id = an.alert_type_id
GROUP BY ac.alert_name
ORDER BY total_alerts DESC;

--Retrieve flagged transactions with reasons
SELECT f.flag_id, t.transaction_id, t.amount, f.flag_type, f.description, f.flag_timestamp
FROM Flags f
JOIN Transactions t ON f.transaction_id = t.transaction_id
ORDER BY f.flag_timestamp DESC;

--Count the number of flags by type
SELECT flag_type, COUNT(flag_id) AS total_flags
FROM Flags
GROUP BY flag_type
ORDER BY total_flags DESC;

--List all suspicious IP addresses and reasons
SELECT ip_id, ip_address, flag_reason, last_seen_timestamp
FROM Suspicious_ip
ORDER BY last_seen_timestamp DESC;

--Find users who logged in from suspicious IP addresses
SELECT u.first_name, u.last_name, ul.ip_address, ul.login_timestamp
FROM User_Logs ul
JOIN Users u ON ul.user_credential_id = u.id
WHERE ul.ip_address IN (SELECT ip_address FROM Suspicious_ip);

--Calculate the average risk score by account
SELECT account_id, AVG(risk_score) AS avg_risk_score
FROM Risk_Scores
GROUP BY account_id
ORDER BY avg_risk_score DESC;

--Find accounts involved in fraud with user details
SELECT u.first_name, u.last_name, fa.reason, fa.flagged_timestamp
FROM Fraudulent_account fa
JOIN Accounts a ON fa.account_id = a.id
JOIN Users u ON a.user_id = u.id;

--Detect accounts exceeding their daily transaction limit
SELECT t.account_id, SUM(t.amount) AS daily_total, tl.max_daily_limit
FROM Transactions t
JOIN Accounts a ON t.account_id = a.id
JOIN Transaction_Limits tl ON a.limit_id = tl.limit_id
WHERE DATE(t.timestamp) = DATE('now')
GROUP BY t.account_id
HAVING daily_total > tl.max_daily_limit;

--Identify high-risk accounts
SELECT a.id AS account_id, u.first_name, u.last_name, AVG(rs.risk_score) AS avg_risk_score
FROM Accounts a
JOIN Users u ON a.user_id = u.id
JOIN Risk_Scores rs ON a.id = rs.account_id
GROUP BY a.id
HAVING avg_risk_score > 7.0
ORDER BY avg_risk_score DESC;

--Identify users with the most recent logins
SELECT u.first_name, u.last_name, ul.login_timestamp
FROM User_Logs ul
JOIN Users u ON ul.user_credential_id = u.id
ORDER BY ul.login_timestamp DESC
LIMIT 10;

--Detect multiple logins from the same IP address
SELECT ul.ip_address, COUNT(ul.log_id) AS login_count
FROM User_Logs ul
GROUP BY ul.ip_address
HAVING login_count > 1
ORDER BY login_count DESC;

--List users who changed their password more than once
SELECT u.first_name, u.last_name, COUNT(uc.change_id) AS password_changes
FROM User_Changes_Log uc
JOIN Users u ON uc.user_id = u.id
WHERE uc.change_type = 'Password_Change'
GROUP BY u.id
HAVING password_changes > 1;

--Find accounts flagged for fraud and their reasons
SELECT fa.account_id, u.first_name, u.last_name, fa.reason
FROM Fraudulent_account fa
JOIN Accounts a ON fa.account_id = a.id
JOIN Users u ON a.user_id = u.id;
