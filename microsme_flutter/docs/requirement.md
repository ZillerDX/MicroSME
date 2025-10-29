Product Requirements: MicroSME All-in-One

This document translates the draft spec into formal, testable requirements.

1. General (Non-Functional) Requirements

[SYS-1] The application MUST be fully functional for sales, inventory, and expense logging without an active internet connection.

[SYS-2] All locally stored data (sales, stock, expenses) MUST automatically sync to the cloud when an internet connection becomes available and the user is logged in.

[SYS-3] The UI MUST be responsive and usable on both standard smartphone and 7-10 inch tablet screen sizes.

2. Module 1: Point of Sale (POS)

[POS-1] As a shop owner, I want to add products to a sale by tapping on a grid of product icons or names.

[POS-2] As a shop owner, I want to adjust the quantity of an item in the cart before completing the sale.

[POS-3] As a shop owner, I want to record the payment method (at minimum "Cash" and "Transfer") to complete a sale.

[POS-4] As a shop owner, I want to print a simplified receipt (items, total, date) on a connected Bluetooth thermal printer.

[POS-5] As a shop owner, I want to apply a simple discount (either % or a fixed amount) to the cart total.

3. Module 2: Inventory

[INV-1] As a shop owner, I want to create a product item by defining its Name, Price, and current Stock Quantity.

[INV-2] As a shop owner, the system MUST automatically deduct the correct quantity from my stock count every time I complete a sale containing that item.

[INV-3] As a shop owner, I want to manually adjust the stock count (e.g., for new deliveries or spoilage) via a simple form.

[INV-4] As a shop owner, I want to set a "low stock threshold" (e.g., "5") for an item, so I can visually identify it when it's running low.

4. Module 3: Accounting (Ledger)

[ACC-1] As a shop owner, all completed sales from the POS MUST be automatically logged as "Revenue" in the accounting module.

[ACC-2] As a shop owner, I want a simple form to manually add "Expenses" with a title and an amount (e.g., "Rent", "5000").

[ACC-3] As a shop owner, I want to view a "Daily Summary" report that clearly shows Total Revenue, Total Expenses, and Net Profit for the selected day.

[ACC-4] As a shop owner, I want to be able to view my daily summary reports for past dates.

5. Module 4: Customer Loyalty (CRM)

[CRM-1] As a shop owner, I want to create a customer profile using only a Phone Number and (optional) Name.

[CRM-2] As a shop owner, I want to search for and attach a customer to a sale using their phone number.

[CRM-3] As a shop owner, I want to configure a simple point rule (e.g., "Spend X amount, get Y points").

[CRM-4] As a shop owner, the system MUST automatically calculate and add points to a customer's profile after a completed sale.

[CRM-5] As a shop owner, I want to be able to redeem points for a customer, which deducts the points from their balance.