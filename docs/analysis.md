# Analysis Notes

This document outlines the motivation and insights behind the SQL analysis queries performed on the **cosmetics** dataset.

---

## 1. Which categories do most products belong to?

**Purpose:** Identify the dominant product categories in the dataset.
**Insight expected:** Highlights where the cosmetic industry focuses most (e.g., skincare, makeup, haircare). Useful for market analysis and detecting trends in consumer market.

---

## 2. Which brand do most products belong to?

**Purpose:** Reveal the brands with the largest product portfolios.
**Insight expected:** Helps identify market leaders and which companies dominate the cosmetics market by breadth of offerings.

---

## 3. Which brands have the highest percentage of harmful chemicals?

**Purpose:** Evaluate brand safety reputations.
**Insight expected:** Surfaces companies whose products disproportionately contain harmful chemicals, providing a consumer risk perspective.

---

## 4. Did harmful chemicals increase or decrease over time?

**Purpose:** Detect long-term safety trends.
**Insight expected:** Shows whether harmful chemical usage is declining (due to stricter regulations and awareness) or persisting/increasing over time.

---

## 5. Which products with harmful chemicals have been fixed or discontinued?

**Purpose:** Measure corrective actions taken by brands.
**Insight expected:** Identifies whether companies reformulate or remove unsafe products, reflecting responsibility and regulatory compliance.

---

## 6. Which are the most common harmful chemicals?

**Purpose:** Pinpoint chemicals that pose the most frequent safety risks.
**Insight expected:** Helps understand recurring safety concerns and which harmful substances require consumer awareness and stricter control.

---

## 7. What is the percentage of harmful vs. safe products?

**Purpose:** Provide a high-level overview of dataset safety.
**Insight expected:** A quick summary ratio of safe vs. harmful products, useful for communicating overall industry safety at a glance.

---

# Next Steps in Python Analysis

While SQL provides precise answers to the above questions, Python can be used to **extend analysis with visualization and statistical insights**:

* **Bar plots / Pie charts** for product categories and brand dominance.
* **Stacked bar charts** to compare harmful vs. safe product counts per brand.
* **Time series plots** showing harmful chemical usage trends over years.
* **Word clouds or frequency charts** for most common harmful chemicals.
* **Distribution plots** to show the proportion of harmful vs. safe products at a glance.

These steps will make the results easier to **interpret, communicate, and present visually** to non-technical stakeholders.

---