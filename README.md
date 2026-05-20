# 🛍️ ShopInsight — Customer Shopping Behaviour Analytics

An end-to-end data analytics project using **Python**, **MySQL** and **Power BI** to analyse customer shopping behaviour and build an interactive dashboard.

---

## 🛠️ Tools Used
- **Python** — Data cleaning, EDA, feature engineering, KMeans clustering
- **MySQL** — 20 KPI queries using CTEs and window functions
- **Power BI** — 4-page interactive dashboard with DAX measures

---

## 📊 Dataset
- 3,900 customers · 28 features
- Total Revenue: **$233,081** · Avg Spend: **$59.76** · Avg Rating: **3.75**

---

## 🐍 Python — Feature Engineering
- RFM scoring → `rfm_segment` (Champions, Loyal, At Risk, Lost)
- Loyalty staging → `loyalty_stage` (New → Returning → Established → Loyal)
- KMeans clustering → `cluster` (Budget · Mid Range · High Value)
- Spend tier, age group, purchase frequency days

---

## 📊 Power BI Dashboard

### Page 1 — Executive Overview
![Overview](overview.png)

### Page 2 — Customer Segmentation
![Segments](segments.png)

### Page 3 — Product & Category Analysis
![Products](products.png)

### Page 4 — Purchase Behaviour & Loyalty
![Behaviour](behaviour.png)

---

## 💡 Key Insights
- 🏆 **Loyal Customers** generate the most revenue at **$89,057**
- 🍂 **Fall** is the top revenue season at **$60,018**
- 👕 **Clothing** dominates with **44.7%** of total revenue
- 💜 **Champions** have the highest discount usage at **44.2%**
- 📍 **Montana** is the top state by revenue at **$5,784**
- ⚖️ Near equal gender split — Male **67.74%** vs Female **32.26%**

---

## 🚀 How to Run

**Python**

pip install pandas numpy matplotlib seaborn scikit-learn
jupyter notebook customer_shopping_behaviour_analytics.ipynb

**MySQL**

source customer_shopping_behavior_analytics.sql;

**Power BI**

Open customer_shopping_behaviour_analytics.pbix → update MySQL credentials → Refresh

---

## 📁 Files

| File | Description |
|---|---|
| customer_shopping_behaviour_analytics.ipynb | Python EDA and feature engineering |
| customer_shopping_behavior_analytics.sql | 20 SQL KPI queries |
| customer_shopping_behaviour_analytics.pbix | Power BI dashboard |
| customer_shopping_behaviour_analytics.csv | Cleaned dataset |

---
