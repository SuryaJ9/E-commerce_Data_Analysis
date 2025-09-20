
# 📊 Zepto EDA & Analytics Workflow Documentation

## 1. Project Overview

The **Zepto EDA Project** aims to analyze product data from the `zepto` table stored in PostgreSQL, extract business insights, and deliver them in a **client-friendly Google Sheets dashboard**.

The workflow ensures that decision-makers can track **inventory, pricing, discounts, and revenue potential** in real time.

## ⚙️ Architecture / Workflow Overview  

```text
PostgreSQL (Data Source)
      |
      |  [SQL Queries: EDA, aggregations, KPIs]
      v
Python (Data Processing + Metrics Calculation)
      |
      |  [pandas, numpy for KPI calculation, formatting]
      v
Google Sheets (Client Dashboard / Report)
      |
      |  [gspread / pygsheets: write KPIs, charts, insights]
      v
Client Access (Interactive & Shareable)
```text

## 2. Data Source & Schema

### **Database: PostgreSQL**

Table: `zepto`

| Column                 | Type         | Description                  |
| ---------------------- | ------------ | ---------------------------- |
| category               | VARCHAR(120) | Product category             |
| name                   | VARCHAR(150) | Product name                 |
| mrp                    | NUMERIC(8,2) | Maximum retail price         |
| discountPercent        | NUMERIC(5,2) | Discount applied (%)         |
| availableQuantity      | INTEGER      | Units available              |
| discountedSellingPrice | NUMERIC(8,2) | Final selling price          |
| weightInGms            | INTEGER      | Product weight               |
| outOfStock             | BOOLEAN      | Stock status                 |
| quantity               | INTEGER      | Purchase quantity (for cart) |

---

## 3. EDA Process

### **Step 1. Data Understanding**

* Checked schema, row count, sample data
* Verified null values, duplicates

### **Step 2. Descriptive Statistics**

* MRP, discount %, selling price ranges
* Out-of-stock vs available stock

### **Step 3. Category Analysis**

* Items per category
* Average discount % per category
* Out-of-stock ratio per category

### **Step 4. Business Insights**

* Top discounted products
* High-revenue potential categories
* Low-stock risk products
* Price per gram (value-for-money metric)

---

## 4. Key SQL Queries

### Example: Average Discount per Category

```sql
SELECT 
    category,
    ROUND(AVG(discountPercent), 2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC;
```

### Example: Potential Revenue per Category

```sql
SELECT 
    category,
    SUM(discountedSellingPrice * availableQuantity) AS potential_revenue
FROM zepto
GROUP BY category
ORDER BY potential_revenue DESC;
```

---

## 5. Data Workflow (PostgreSQL → Python → Google Sheets)

### **Step 1: PostgreSQL (Data Storage)**

* Raw product data stored in PostgreSQL.
* SQL queries extract category-level KPIs.

### **Step 2: Python (Data Processing)**

* Libraries: `psycopg2`, `pandas`, `gspread`.
* Compute KPIs:

  * `num_items` → Number of items per category
  * `avg_discount` → Average discount % per category
  * `potential_revenue` → Inventory value based on discounted prices
  * `out_of_stock_pct` → Stockout ratio
  * `top_discount_items` → Top 5 discounted products
  * `low_stock_items` → Products with <5 stock

### **Step 3: Google Sheets (Dashboard Delivery)**

* Data pushed to **Google Sheets** using `gspread`.
* Multiple tabs for clarity:

  * **Category KPIs**
  * **Top Discount Items**
  * **Low Stock Items**
* Clients access insights directly in Google Sheets.

---

## 6. Automation(Optional)

* Python script scheduled via **cron job (Linux)** or **Task Scheduler (Windows)**.
* Automatically updates Google Sheets daily/weekly.
* Clients always see **fresh insights**.

---

## 7. Example Dashboard Metrics

| Category      | Num Items | Avg Discount | Potential Revenue | Out of Stock % |
| ------------- | --------- | ------------ | ----------------- | -------------- |
| Beverages     | 120       | 18.5%        | ₹8,50,000         | 5.2%           |
| Snacks        | 95        | 25.4%        | ₹6,20,000         | 8.7%           |
| Personal Care | 65        | 12.7%        | ₹3,10,000         | 12.3%          |

---

## 8. Benefits to Client

✅ Real-time visibility into **pricing, inventory, and discounts**
✅ Identify **high-revenue categories**
✅ Prevent losses from **overstocking or stockouts**
✅ Deliver insights in **familiar format (Google Sheets)**
✅ Scalable & automatable pipeline


📌 **Final Deliverable**:
A **Google Sheets dashboard** powered by PostgreSQL + Python pipeline, updating automatically with KPIs & insights for Zepto-like e-commerce data.


