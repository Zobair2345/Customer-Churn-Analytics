-- ============================================
-- Customer Churn Analytics
-- SQL Business Analysis
-- ============================================


-- 1. Overall Customer Churn Distribution

SELECT
    churn,
    COUNT(*) AS customer_count
FROM customers
GROUP BY churn;


-- 2. Overall Customer Churn Percentage

SELECT
    churn,
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM customers
GROUP BY churn;


-- 3. Contract Type vs Churn

SELECT
    contract,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (
        WHERE churn = 'Yes'
    ) AS churned_customers,
    ROUND(
        COUNT(*) FILTER (WHERE churn = 'Yes') * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
FROM customers
GROUP BY contract
ORDER BY churn_rate DESC;

-- 4. Payment Method vs Churn

SELECT
    paymentmethod,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (
        WHERE churn = 'Yes'
    ) AS churned_customers,
    ROUND(
        COUNT(*) FILTER (WHERE churn = 'Yes') * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
FROM customers
GROUP BY paymentmethod
ORDER BY churn_rate DESC;

-- 5. Internet Service vs Churn

SELECT
    internetservice,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (
        WHERE churn = 'Yes'
    ) AS churned_customers,
    ROUND(
        COUNT(*) FILTER (WHERE churn = 'Yes') * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
FROM customers
GROUP BY internetservice
ORDER BY churn_rate DESC;

-- 6. Customer Tenure Segment vs Churn

SELECT
    CASE
        WHEN tenure <= 12 THEN '0-12 months'
        WHEN tenure <= 24 THEN '13-24 months'
        WHEN tenure <= 48 THEN '25-48 months'
        ELSE '49+ months'
    END AS tenure_segment,

    COUNT(*) AS total_customers,

    COUNT(*) FILTER (
        WHERE churn = 'Yes'
    ) AS churned_customers,

    ROUND(
        COUNT(*) FILTER (WHERE churn = 'Yes') * 100.0
        / COUNT(*),
        2
    ) AS churn_rate

FROM customers

GROUP BY tenure_segment

ORDER BY churn_rate DESC;

-- 7. High-Risk Customer Segment Analysis

SELECT
    COUNT(*) AS high_risk_customers,

    COUNT(*) FILTER (
        WHERE churn = 'Yes'
    ) AS churned_customers,

    ROUND(
        COUNT(*) FILTER (WHERE churn = 'Yes') * 100.0
        / COUNT(*),
        2
    ) AS churn_rate

FROM customers

WHERE contract = 'Month-to-month'
  AND tenure <= 12
  AND internetservice = 'Fiber optic'
  AND paymentmethod = 'Electronic check';

  -- 12. Customers Paying Above Average Monthly Charges

SELECT
    COUNT(*) AS customers_above_average
FROM customers
WHERE monthlycharges >
(
    SELECT AVG(monthlycharges)
    FROM customers
);

-- 13. Top 10 Longest-Tenure Customers

SELECT
    customerid,
    tenure,
    monthlycharges,
    contract
FROM customers
ORDER BY tenure DESC
LIMIT 10;

-- 10. Contract and Internet Service Combination vs Churn

SELECT
    contract,
    internetservice,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (
        WHERE churn = 'Yes'
    ) AS churned_customers,
    ROUND(
        COUNT(*) FILTER (WHERE churn = 'Yes') * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
FROM customers
GROUP BY contract, internetservice
ORDER BY churn_rate DESC;
-- 11. Payment Method and Contract Combination vs Churn

SELECT
    paymentmethod,
    contract,
    COUNT(*) AS total_customers,

    COUNT(*) FILTER (
        WHERE churn = 'Yes'
    ) AS churned_customers,

    ROUND(
        COUNT(*) FILTER (WHERE churn = 'Yes') * 100.0
        / COUNT(*),
        2
    ) AS churn_rate

FROM customers

GROUP BY paymentmethod, contract

ORDER BY churn_rate DESC;
-- 12. Customers Paying Above Average Monthly Charges

SELECT
    COUNT(*) AS customers_above_average
FROM customers
WHERE monthlycharges >
(
    SELECT AVG(monthlycharges)
    FROM customers
);

-- 13. Top 10 Longest-Tenure Customers

SELECT
    customerid,
    tenure,
    monthlycharges,
    contract
FROM customers
ORDER BY tenure DESC
LIMIT 10;


-- 14. Customer Summary View

CREATE VIEW customer_summary AS

SELECT
    customerid,
    contract,
    internetservice,
    paymentmethod,
    tenure,
    monthlycharges,
    churn
FROM customers;

-- ============================================
-- Key Business Insights
-- ============================================

-- Overall churn rate: 26.54%
-- Month-to-month contracts have the highest churn.
-- Fiber optic customers churn more than DSL customers.
-- Electronic check customers have the highest churn rate.
-- Customers with tenure <= 12 months are most likely to churn.
-- High-risk segment (Month-to-month + Fiber optic + Electronic check + Tenure <=12)
-- contains 631 customers with a churn rate of 71.16%.