# 🛒 Ecommerce Platform – Billing System

A full-featured ecommerce and billing system with separate **Admin** and **User** dashboards, built using **Node.js**, **HTML/CSS**, and **SQL Server**. This platform supports product management, invoice generation, user purchases, and billing history.

---

## 🚀 Features

### 👩‍💼 Admin Dashboard
- Add, update, and delete products (Full CRUD)
- Create manual invoices
- View billing history
- Manage staff and salaries

### 🧑‍💻 User Dashboard
- Browse and purchase products online
- Generate invoices for orders
- View past billing history
- Manage user profile

---

## 🛠️ Tech Stack

- **Frontend:** HTML, CSS, JavaScript
- **Backend:** Node.js (`server.js`)
- **Database:** SQL Server (via `script.sql`)
- **Package Management:** npm (`package.json`)
- **Environment Config:** `.env` (not pushed for security)

---

## 📁 Folder Structure

BillingSystem/
│
├── server.js # Node.js backend
├── script.sql # SQL database schema
├── package.json # npm dependencies
├── .env # Environment variables (ignored in Git)
├── .gitignore # Git ignored files
│
├── admin.html # Admin login/dashboard
├── adminInvoice.html # Manual invoice form
├── productManagement.html # Admin product control
├── reports.html # Admin billing reports
├── staffSalary.html # Staff management
│
├── user.html # User main interface
├── shop.html # Shopping page
├── cart.html # Cart and checkout
├── invoice.html # Invoice display
├── userProfile.html # User profile page
├── viewOrders.html # Order history
│
├── login2.html # Login page
├── signup.html # Signup page
├── home.html # Landing page
