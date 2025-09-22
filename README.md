# Fraud Detection SQL Database Project

**Author:** Rasviya Sulthana N  
**Video Overview:** [YouTube Presentation](https://youtu.be/O_5fnOg1oD8)

---

## 📘 Project Overview

This project implements a **relational database system for detecting fraudulent financial activities**, tracking users, accounts, transactions, and computing risk scores. It demonstrates **SQL skills, database design, anomaly detection, and risk reporting**.

---

## 🗂️ Repository Structure

| File/Folder                   | Description                                                  |
|-------------------------------|--------------------------------------------------------------|
| `DESIGN.md`                   | Full project design document                                 |
| `schema.sql`                  | SQL schema with table definitions                             |
| `queries.sql`                 | SQL queries for views, triggers, and testing                 |
| `fraud_detection.db`          | SQLite database file with schema and sample data             |
| `Fraud_detection_diagram.jpg` | Entity Relationship Diagram (ERD)                            |
| `*.csv`                       | Mock data for all tables                                      |

---

## 🎯 Objectives

- Design a **normalized relational schema** for fraud detection.  
- Track and flag **suspicious transactions**.  
- Assign **risk scores** to accounts and transactions.  
- Optimize queries with **indexes and views**.  
- Provide **structured reporting and actionable insights**.

---

## 🧱 Database Schema

### Key Tables

- **users** – user info, unique emails and phone numbers  
- **accounts** – links users to accounts with types and balances  
- **transactions** – logs deposits, withdrawals, transfers, timestamps, and locations  
- **flags** – records suspicious transactions with descriptions and timestamps  
- **risk_scores** – stores calculated risk scores per account/transaction  

Refer to the ER diagram (`Fraud_detection_diagram.jpg`) for relationships.

---

## 🚀 Features

### Triggers
- Automatically **flag suspicious transactions**.  
- Update **account balances** post-transaction.  
- Compute and log **risk scores** for analysis.  
- Maintain **audit logs** of flagged activities.  

### Views
- `flagged_transactions` – all flagged transactions with reasons  
- `high_risk_accounts` – accounts exceeding risk thresholds  
- `transaction_summary` – aggregated transaction data  
- `user_activity_log` – summary per user

---

## 🧠 Optimization
- Indexes on `users.email`, `users.phone_number`, `transactions.account_id`  
- Composite index on `transactions(account_id, timestamp)`  
- **Normalized schema** ensures efficiency and integrity  
- Lightweight design compatible with SQLite or PostgreSQL

---

## 🧪 Sample Data
CSV files include:  
`users.csv`, `accounts.csv`, `transactions.csv`, `flags.csv`, `risk_scores.csv`, `card_details.csv`, `suspicious_ips.csv`, `user_logs.csv`, etc.

---

## 🛠️ Tools Used
- **Database:** SQLite (CLI & DB Browser)  
- **IDE & Version Control:** VS Code, Git & GitHub  
- **Documentation:** Markdown, ER Diagram via dbdiagram.io  

---

## 🧑‍💼 Contact
**Rasviya Sulthana N**  
📧 rasviyasulthana.n@gmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/rasviya-sulthana)

## 📄 License

This project is for educational and demonstration purposes only.
