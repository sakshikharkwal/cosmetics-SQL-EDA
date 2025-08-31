# Cosmetics SQL EDA

This project analyzes cosmetics product safety using SQL.  
The dataset contains information about products, their chemical composition, and whether they include harmful chemicals.  
The goal is to derive insights relevant to business and data analyst roles, focusing on safety trends and brand analysis.

## Features

- **Database schema design** with normalization for products, brands, and chemicals.  
- **Data cleaning & structuring** for consistent analysis.  
- **SQL analysis queries** answering key business questions:
  - Which categories do most products belong to?
  - Which brand do most products belong to?
  - Which brands have highest percentage of harmful chemicals?
  - Did harmful chemicals increase or decrease over time?
  - Which products with harmful chemicals have been fixed or discontinued?
  - Which are the most common harmful chemicals?
  - What is the percentage of harmful vs. safe products?

## Tech Stack

- SQL (MySQL)  
- Git & GitHub for version control  

## Repository Structure

```

.
├── schema/              # Database schema creation scripts
├── data/                # Raw dataset
├── queries/             # SQL analysis queries
├── README.md            # Project documentation
└── LICENSE              # License file (MIT)

````

## How to Use

1. Clone this repository:
   ```bash
   git clone https://github.com/sakshikharkwal/cosmetics-SQL-EDA.git
   cd cosmetics-SQL-EDA
````

2. Set up the database using scripts in the `schema/` folder.
3. Run queries from the `queries/` folder to replicate the analysis.

## License

This project is licensed under the [MIT License](./LICENSE).

```