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
├── README.md                   # Project description, workflow, instructions
├── LICENSE                     # MIT license
├── .gitignore                  # Ignore venv, cache, notebooks checkpoints, etc.
│ 
├── sql_scripts/                # All SQL scripts organized
│   ├── 1_data_cleaning.sql
│   ├── 2_create_new_schema.sql
│   └── 3_data_analysis.sql
│ 
├── er_diagram/                 # ER diagrams and schema design
│   └── cosmetics_clean_ER.png
│ 
├── docs/                       # Documentation and analysis notes
│   └── analysis_notes.md
│ 
└── data/                       # Sample CSV extracts (hidden)
    ├── cosmetics_raw.csv       # Original raw data
    └── cosmetics_clean.csv     # Cleaned but not normalized data


````

## How to Use

1. Clone this repository:
   ```bash
   git clone https://github.com/sakshikharkwal/cosmetics-SQL-EDA.git
   cd cosmetics-SQL-EDA   
```

2. Set up the database using scripts in the `schema/` folder.
3. Run queries from the `queries/` folder to replicate the analysis.

## License

This project is licensed under the [MIT License](./LICENSE).