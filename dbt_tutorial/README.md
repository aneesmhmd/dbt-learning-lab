# dbt Learning Lab

A hands-on learning project for building data transformation pipelines using [dbt (data build tool)](https://docs.getdbt.com/docs/introduction). This project is designed to grow across multiple database connections — starting with PostgreSQL, with BigQuery and others planned.

---

## Project Structure

```
dbt_tutorial/
├── models/
│   ├── staging/          # Raw source cleaning and standardization
│   │   ├── sources.yml
│   │   ├── stg_customers.sql
│   │   ├── stg_orders.sql
│   │   ├── stg_order_items.sql
│   │   └── stg_products.sql
│   └── marts/            # Business-level aggregations
│       ├── mart_customer_orders.sql
│       └── mart_product_revenue.sql
├── seeds/                # Static CSV data loaded into the database
├── snapshots/            # SCD (slowly changing dimension) tracking
├── macros/               # Reusable Jinja/SQL macros
├── analyses/             # Ad-hoc SQL analyses (not materialized)
├── tests/                # Custom data tests
├── packages.yml          # dbt package dependencies
├── dbt_project.yml       # Project configuration
└── profiles.yml          # Connection profiles (not committed with secrets)
```

---

## Connections Supported

| Target | Status |
|---|---|
| PostgreSQL | Active |
| BigQuery | Planned |

---

## Prerequisites

- Python 3.12+
- A running PostgreSQL instance (for the default target)
- dbt-core and dbt-postgres installed (see setup below)

---

## Setup

**1. Clone the repo and create a virtual environment**

```bash
python -m venv .venv
source .venv/bin/activate
```

**2. Install dependencies**

```bash
pip install -r requirements.txt
dbt deps
```

**3. Set environment variables**

Create a `.env` file in the `dbt_tutorial/` directory (never commit this):

```bash
DB_HOST=localhost
DB_PORT=5432
DB_USER=your_user
DB_PASSWORD=your_password
DB_NAME=your_database
DB_SCHEMA=your_schema
```

Load them before running dbt:

```bash
source .env
```

**4. Verify connection**

```bash
dbt debug
```

---

## Common Commands

```bash
dbt run          # Build all models
dbt test         # Run all data tests
dbt run --select staging   # Run only staging models
dbt run --select marts     # Run only mart models
dbt docs generate          # Generate documentation
dbt docs serve             # View docs in browser
dbt source freshness       # Check source data staleness
```

---

## Packages Used

| Package | Version | Purpose |
|---|---|---|
| [dbt_utils](https://github.com/dbt-labs/dbt-utils) | 1.3.3 | Utility macros (surrogate keys, tests, etc.) |

---

## Resources

- [dbt Documentation](https://docs.getdbt.com/docs/introduction)
- [dbt Discourse](https://discourse.getdbt.com/)
- [dbt Community Slack](https://community.getdbt.com/)
- [dbt Best Practices](https://docs.getdbt.com/guides/best-practices)
