# Marketing Campaign Performance dbt Project

## Overview
This dbt project consolidates and processes marketing campaign performance data from multiple advertising platforms—Facebook Ads, LinkedIn Ads, and Google Ads. The goal is to create a unified dataset that provides key insights into campaign metrics, enabling data-driven marketing decisions.

## Project Structure
The project is organized into the following main layers:

- **Staging Models (`staging/`)**
  - Load and prepare raw data from each advertising platform.

- **Intermediate Models (`intermediate/`)**
  - Transform and standardize data across platforms.

- **Mart Models (`marts/`)**
  - Aggregate and calculate final metrics for reporting.

- **Exposures (`exposures/`)**
  - Document how models are used externally.

- **Tests**
  - Ensure data quality and integrity through singular and generic tests.


# Model Summaries

## Staging Models (`staging/`)
**Purpose:** Load raw data from each platform and perform initial cleaning and preparation.
**Actions:**
- Standardize field names and data types.
- Handle missing or inconsistent data.
- Prepare data for transformation in the intermediate layer.

## Intermediate Models (`intermediate/`)
**Purpose:** Transform and standardize data to a common format across all platforms.
**Actions:**
- Map platform-specific fields to common field names.
- Compute preliminary metrics.
- Filter and clean data to ensure consistency.

## Mart Models (`marts/`)
**Purpose:** Aggregate data and calculate final metrics for analysis and reporting.
**Actions:**
- Combine data from all platforms into a unified dataset.
- Calculate key performance indicators (KPIs) like CPC, CPM, ROAS, and CPA.
- Enforce data contracts and apply final validations.

## Exposures (`exposures/`)
**Purpose:** Document how the final datasets are used in external tools or reports.
**Actions:**
- Provide metadata for data lineage and impact analysis.
- Enhance transparency for data consumers.

# Configuring `profiles.yml`
To run this project, configure your `profiles.yml` to connect dbt to your data warehouse.

### Sample `profiles.yml`

dbt_ads_channels:
  target: dev
  outputs:
    dev:
      type: bigquery
      method: service-account
      project: wired-ripsaw-390718
      dataset: dev_dbt_ads_channels
      keyfile: ./dbt_ads_channels.json  # Ensure this path is correct
      threads: 1

    prod:
      type: bigquery
      method: oauth
      project: wired-ripsaw-390718
      dataset: dbt_cloudrun_test
      threads: 2

# Configuration Steps

1. **Create `profiles.yml`** at `~/.dbt/profiles.yml`.
2. **Set the Target Environment** by changing `target` to `dev` or `prod`.
3. **Configure Credentials** for each environment:

   - **Development (`dev`):**
     - Use `service-account` method with a JSON key file.
     - Ensure the `keyfile` path is correct and the service account has necessary permissions.
   - **Production (`prod`):**
     - Use `oauth` method for authentication.
     - Ensure your user account has access to the BigQuery project.
