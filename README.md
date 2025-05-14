# Fraud Detection Database Project

**Author:** Rasviya Sulthana Noor Mohamed  
**Video Overview:** [YouTube Presentation](https://youtu.be/O_5fnOg1oD8)

---

## 📘 Overview

This project implements a relational database system designed for detecting fraudulent financial activities. It tracks users, accounts, transactions, suspicious behaviors, and computes risk scores. The system includes schema definitions, views, triggers, and sample data.

---

## 🗂️ Repository Structure

| File/Folder                   | Description                                                  |
|------------------------------|--------------------------------------------------------------|
| `DESIGN.md`                  | Full project design document                                 |
| `schema.sql`                 | SQL schema with all table definitions                        |
| `queries.sql`                | SQL queries for views, triggers, and testing                 |
| `fraud_detection.db`         | SQLite database file with schema and sample data             |
| `Fraud_detection_diagram.jpg`| Entity Relationship Diagram (ERD)                            |
| `*.csv`                      | CSV files with mock data for all tables                      |

---

## 🧾 Objectives

- Design normalized schema for financial fraud detection.
- Track and flag suspicious transactions.
- Assign risk scores to accounts and transactions.
- Optimize queries using indexes and views.
- Log all user and transaction-related activity.

---

## 🧱 Database Schema

### Tables

- **users**
  - `id` INTEGER PRIMARY KEY
  - `name` TEXT NOT NULL
  - `email` TEXT UNIQUE NOT NULL
  - `phone_number` TEXT UNIQUE NOT NULL
  - `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP

- **accounts**
  - `id` INTEGER PRIMARY KEY
  - `user_id` INTEGER REFERENCES users(id)
  - `account_type` TEXT CHECK (IN ['savings', 'checking', 'credit'])
  - `balance` NUMERIC CHECK (balance >= 0)
  - `created_at` TIMESTAMP

- **transactions**
  - `id` INTEGER PRIMARY KEY
  - `account_id` INTEGER REFERENCES accounts(id)
  - `amount` NUMERIC CHECK (amount > 0)
  - `transaction_type` TEXT CHECK (IN ['Deposit', 'Withdrawal', 'Transfer'])
  - `timestamp` TIMESTAMP
  - `location` TEXT

- **flags**
  - `id` INTEGER PRIMARY KEY
  - `transaction_id` INTEGER REFERENCES transactions(id)
  - `flag_type` TEXT NOT NULL
  - `description` TEXT NOT NULL
  - `flagged_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP

- **risk_scores**
  - `id` INTEGER PRIMARY KEY
  - `account_id` INTEGER REFERENCES accounts(id)
  - `transaction_id` INTEGER REFERENCES transactions(id)
  - `score` REAL NOT NULL
  - `reason` TEXT
  - `calculated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP

---

## 🔗 Relationships

- One-to-many: `users` → `accounts`
- One-to-many: `accounts` → `transactions`
- One-to-many: `transactions` → `flags`
- Many-to-one: `risk_scores` → `accounts`, `transactions`

Refer to the ER diagram (`Fraud_detection_diagram.jpg`) for visual representation.

---

## 🚀 Features

### Triggers

- Automatically flag suspicious transactions.
- Update account balances after each transaction.
- Compute and log risk scores.
- Record flagging audit logs.

### Views

- `flagged_transactions`: All flagged records with reasons.
- `high_risk_accounts`: Accounts with risk scores above threshold.
- `transaction_summary`: Aggregated data by transaction type.
- `user_activity_log`: User-wise transaction and account summary.

---

## 🧠 Optimization

- Indexes on:
  - `users.email`, `users.phone_number`
  - `transactions.account_id`, `transactions.transaction_type`
  - Composite index on `transactions(account_id, timestamp)`

- Normalized schema for efficient querying and integrity
- Lightweight design for SQLite or PostgreSQL compatibility

---

## 📂 Sample CSV Files

You can find the following CSV files for mock data import:

- `users.csv`, `accounts.csv`, `transactions.csv`, `flags.csv`, `risk_scores.csv`
- `card_details.csv`, `fraudulent_accounts.csv`, `suspicious_ips.csv`
- `user_logs.csv`, `user_changes_log.csv`, `user_credentials.csv`
- `transaction_limits.csv`, `alert_notifications.csv`, `alert_categories.csv`
- `trans_categories.csv`

---

## 🧪 How to Use

1. Run `schema.sql` to create tables.
2. Import data from CSV files (manually or using SQLite CLI).
3. Execute `queries.sql` to create views, triggers, and test logic.
4. Open and browse `fraud_detection.db` using DB Browser for SQLite.

---

## 📌 Limitations

- No real-time fraud detection (only batch processing).
- Fixed rule-based logic; no machine learning included.
- External service integration (like alerting systems) not implemented.

---

## 🔧 Tools Used

- SQLite (CLI & DB Browser)
- VS Code, Git & GitHub
- Markdown for documentation
- ER Diagram via dbdiagram.io

---

## 🧑‍💼 Contact

Rasviya Sulthana Noor Mohamed  
📧 Email: rasviyasulthana.n@gmail.com  
🔗 LinkedIn: [linkedin.com/in/rasviya-sulthana](https://www.linkedin.com/in/rasviya-sulthana)

---

## 📄 License

This project is for educational and demonstration purposes only.
