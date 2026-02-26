# dbt marketing warehouse (Snowflake)

This dbt project builds a marketing function warehouse from your existing Snowflake-loaded tables.

## 1) Configure profile (`~/.dbt/profiles.yml`)

```yaml
consulting_marketing_wh:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: <account_identifier>
      user: <username>
      role: ACCOUNTADMIN
      authenticator: externalbrowser
      warehouse: <warehouse_name>
      database: <analytics_database>
      schema: <analytics_schema>
      threads: 4
```

## 2) Run

```bash
cd dbt_marketing
dbt deps
# Optional vars if your raw tables are in a different DB/schema:
# dbt run --vars '{raw_database: RAW_DB, raw_schema: PUBLIC}'
dbt run
dbt test
```

## 3) Produced marts

- `dim_marketing_client`
- `fct_marketing_project_pipeline`
- `fct_marketing_client_feedback`
