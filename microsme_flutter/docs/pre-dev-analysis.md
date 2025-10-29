Pre-Development Analysis & Test Plan

1. Development Plan & Phasing (V1)

The V1 launch will prioritize offline stability and simplicity.

Phase 1: Core Offline Functionality (Local DB)

Goal: A usable app that works 100% offline.

Tasks:

Set up app architecture (React Native + SQLite/WatermelonDB).

Implement Module 2 (Inventory): Create, Read, Update, Delete (CRUD) for products.

Implement Module 1 (POS): Link to Inventory, create sales, and deduct stock.

All data stored only on the local device.

Phase 2: Local Accounting & CRM

Goal: Complete the offline feature set.

Tasks:

Implement Module 3 (Accounting): Build the ledger to read from local sales data. Create the "Add Expense" form. Build the "Daily Summary" report.

Implement Module 4 (CRM): CRUD for customers (stored locally). Logic for point accumulation and redemption.

Phase 3: Cloud Sync & Authentication

Goal: Add backup and basic cloud features.

Tasks:

Implement backend (Firebase Auth, Firestore).

Add user Registration/Login (Email, Google).

Develop sync logic: Push all local data (products, sales, customers) to Firestore when online.

This sync is primarily for backup and multi-device use, not real-time collaboration. The device remains the primary source of truth to avoid complex conflict resolution.

2. Key Technical Challenges

Offline-First Sync Logic: Managing data integrity and conflicts.

Strategy: We will use a "Last-Write-Wins" strategy simplified by making the device the "source of truth." Cloud data is a backup. If a user logs in on a new device, it will pull from the cloud. If an existing device syncs, it will push (overwrite) cloud data for its own sales.

Bluetooth Printer Integration: There are many cheap, generic thermal printers.

Strategy: We must test against 2-3 of the most popular unbranded models (e.g., from Shopee/Lazada) and use a robust library (e.g., react-native-thermal-receipt-printer).

UI/UX Simplicity: Resisting "feature creep."

Strategy: All new feature requests must be validated against the "Simplicity First" principle. Conduct usability testing with 1-2 actual (non-technical) shop owners before finalizing UI.

3. Initial Test Cases (V1)

Test Case ID

Module

Action

Expected Result

T-SYS-01

System

1. Turn on Airplane Mode. 
 2. Open app. 
 3. Create 3 products. 
 4. Make 5 sales. 
 5. Check inventory. 
 6. Check daily report.

All actions succeed. Inventory levels are correct. Daily report is accurate. The app never shows a "no internet" error.

T-SYS-02

System

1. Complete T-SYS-01. 
 2. Log into an account. 
 3. Turn off Airplane Mode (connect to WiFi). 
 4. Wait 1 min. 
 5. Log into the same account on a second device.

The 3 products, 5 sales, and correct inventory levels are now visible on the second device.

T-POS-01

POS

1. Create Product "A" (Price: 50, Stock: 10). 
 2. Go to POS. 
 3. Add 3 units of Product "A" to cart. 
 4. Complete sale.

The cart total correctly shows 150.

T-INV-01

Inventory

1. Complete T-POS-01. 
 2. Go to Inventory. 
 3. Check stock for Product "A".

Stock for Product "A" is now 7.

T-ACC-01

Accounting

1. Make a sale of 100. 
 2. Make another sale of 50. 
 3. Manually add an expense of 30. 
 4. View "Daily Summary".

Report correctly shows: Revenue: 150, Expenses: 30, Net Profit: 120.

T-CRM-01

CRM

1. Set point rule: 1 point per 50 spent. 
 2. Create customer "C1". 
 3. Attach "C1" to a sale of 120. 
 4. Check "C1" profile.

"C1" has 2 points. (Logic: 120 / 50 = 2.4, round down to 2).

T-CRM-02

CRM

1. Customer "C1" has 10 points. 
 2. Redemption rule: 10 points = 50 discount. 
 3. Attach "C1" to a sale of 80. 
 4. Apply point redemption.

The cart total updates from 80 to 30. The customer's profile updates to 0 points.