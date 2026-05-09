# Monday Coffee Expansion Analysis 

## Project Overview

This project focuses on conducting a **Data-Driven Market Expansion Analysis** for "Monday Coffee," a premium coffee brand looking to scale its operations across major Indian cities. By leveraging SQL for complex data retrieval and analysis, this project identifies the top 3 cities for the brand's next expansion phase based on consumer demographics, sales performance, and operational cost-efficiency.

## Business Objective

The primary goal is to analyze internal sales data and external demographic metrics to determine which cities offer the most sustainable growth. The analysis seeks to optimize the balance between **high revenue**, **large potential market size**, and **low operational overhead (rent)**.

---

## Dataset Architecture

The project utilizes a relational database consisting of four primary datasets:

### 1. `city`

Contains demographic and geographic details for potential expansion markets.

* `city_id`: Unique identifier for each city.
* `city_name`: Name of the city.
* `population`: Total population count.
* `estimated_rent`: Average monthly cost for store operations.
* `city_rank`: National rank based on specific demographic metrics.

### 2. `customers`

Profiles of the existing customer base.

* `customer_id`: Unique identifier for each customer.
* `customer_name`: Full name of the customer.
* `city_id`: Foreign key linking to the `city` table.

### 3. `products`

The product catalog offered by Monday Coffee.

* `product_id`: Unique identifier for each product.
* `product_name`: Name of the coffee product or accessory.
* `price`: Unit price.

### 4. `sales`

Granular transactional data for all historical sales.

* `sale_id`: Unique transaction identifier.
* `sale_date`: Timestamp of the purchase.
* `product_id`: Foreign key linking to the `products` table.
* `customer_id`: Foreign key linking to the `customers` table.
* `total`: Total sale value.
* `rating`: Customer satisfaction score (1-5).

---

##  Key Analytical Queries & Insights

The SQL analysis (contained in `Monday_Coffee_Expansion_Analysis.sql`) addresses the following business questions:

1. **Market Sizing**: Estimating the total coffee consumer base in each city (assumed at 25% of the total population).
2. **Revenue Performance**: Identifying high-performing cities based on total sales revenue during the critical Q4 2023 period.
3. **Product Analytics**: Determining the most popular items to optimize inventory for new locations.
4. **Customer Value**: Calculating the average transaction value per unique customer per city.
5. **Operational Efficiency**: Evaluating the **Rent-to-Customer Ratio** to ensure that high-rent cities are supported by a sufficient customer base.
6. **Sales Velocity**: Using **Window Functions** (`LAG`) to calculate month-over-month growth rates across different regions.

---

## Strategic Recommendations

Based on the final **Market Potential Analysis**, the following three cities are recommended for immediate expansion:

### **1. Pune**

* **Highest Efficiency**: Features the lowest average rent per customer in the dataset.
* **Performance**: Recorded the highest total revenue with a consistently high average sale price per customer.

### **2. Delhi**

* **Unmatched Scale**: Offers the largest potential market with **7.7 million** estimated coffee consumers.
* **Stability**: Highest current customer count (68) and a healthy rent-to-customer ratio of 330.

### **3. Jaipur**

* **Market Leader**: Boasts the highest number of unique active customers (69).
* **Strong ROI**: Extremely low rent-to-customer overhead (156) combined with an impressive average sales figure of 11.6k per customer.

---

## Tech Stack & Skills Demonstrated

* **Database**: SQL (MySQL)
* **Advanced SQL Techniques**:
* **Common Table Expressions (CTEs)** for modular code structure.
* **Window Functions** (`DENSE_RANK`, `LAG`) for growth and ranking analysis.
* **Complex Joins** and Multi-level Aggregations.
* **Date/Time Extraction** for seasonal trend analysis.



##  How to Use

1. **Clone the Repository**:
```bash
git clone https://github.com/your-username/monday-coffee-analysis.git

```


2. **Database Setup**:
* Create a database named `monday_coffee`.
* Import the provided `.csv` files into their respective tables.


3. **Run Analysis**:
* Execute the `Monday_Coffee_Expansion_Analysis.sql` script in your SQL editor of choice to view the results and generated reports.



---

### Future Scope

* **Sentiment Analysis**: Integrating the `rating` column from the `sales` table to perform customer sentiment analysis.
* **Predictive Modeling**: Using historical sales growth to forecast future revenue in potential expansion cities.

---

*Developed as a strategic business intelligence project for Monday Coffee Expansion.*
