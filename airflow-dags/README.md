# Airflow DAG for Fivetran Syncs and Cloud Run Jobs in Cloud Composer

## Overview

This part of the project provides an Airflow DAG setup in Google Cloud Composer that:

- Initiates data synchronization for Facebook Ads, Google Ads, and LinkedIn Ads using Fivetran connectors.
- Waits for each synchronization to complete.
- Executes a Cloud Run job after all synchronizations are complete.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Setup Instructions](#setup-instructions)
  - [1. Update the DAG Code](#1-update-the-dag-code)
  - [2. Configure Airflow](#2-configure-airflow)
  - [3. Deploy the DAG to Cloud Composer](#3-deploy-the-dag-to-cloud-composer)
  - [4. Verify and Trigger the DAG](#4-verify-and-trigger-the-dag)
- [Monitoring and Troubleshooting](#monitoring-and-troubleshooting)
- [DAG Structure Overview](#dag-structure-overview)
  - [Task Dependencies](#task-dependencies)

## Prerequisites

- A Google Cloud Platform (GCP) project with Cloud Composer enabled.
- Fivetran connectors set up for Facebook Ads, Google Ads, and LinkedIn Ads.
- A Cloud Run job configured and deployed.
- Necessary permissions to manage Airflow DAGs and connections in Cloud Composer.

## Setup Instructions

### 1. Update the DAG Code

Copy the provided DAG code into a Python file (e.g., `fivetran_cloud_run_dag.py`).

#### Replace Placeholder Values

Update the placeholders in the DAG code with your actual configuration details:

- **GCP_PROJECT_ID**: Your GCP project ID.
- **REGION**: Your GCP region (e.g., `europe-west2`).
- **CLOUD_RUN_JOB_ID**: The ID of your Cloud Run job.
- **FIVETRAN_FACEBOOK_CONNECTOR_ID**: Your Fivetran Facebook Ads connector ID.
- **FIVETRAN_GOOGLE_CONNECTOR_ID**: Your Fivetran Google Ads connector ID.
- **FIVETRAN_LINKEDIN_CONNECTOR_ID**: Your Fivetran LinkedIn Ads connector ID.

## 2. Configure Airflow

### Install the Required Packages

Ensure that the required Python packages are available in your Cloud Composer environment. You need to add the following to your environment's PyPI dependencies:

- `fivetran-provider-async`
- `apache-airflow-providers-google`

### Create Fivetran Connection

In the Airflow UI:

1. Navigate to **Admin > Connections**.
2. Click on **➕** to add a new connection.
3. Set the following parameters:

   - **Conn Id**: `fivetran_conn`
   - **Conn Type**: `HTTP`
   - **Host**: `https://api.fivetran.com/v1`
   - **Login**: Your Fivetran API key.
   - **Password**: Your Fivetran API secret.

## 3. Deploy the DAG to Cloud Composer

Upload the updated DAG file (`fivetran_cloud_run_dag.py`) to your Cloud Composer environment's DAGs folder. You can do this via:

- **Google Cloud Storage (GCS) Bucket**: Upload the file to the `dags` folder in your Cloud Composer's GCS bucket.
- **Cloud SDK**: Use `gsutil cp` to copy the file to the bucket.

`gsutil cp fivetran_cloud_run_dag.py gs://your-composer-bucket/dags/`


## 4. Verify and Trigger the DAG

1. In the Airflow UI, navigate to the **DAGs** tab.
2. Locate `fivetran_and_cloud_run_dag` in the list.
3. Turn on the DAG by toggling the **On/Off** switch.
4. Trigger the DAG manually if needed by clicking the **Trigger DAG** button (⏯).

## Monitoring and Troubleshooting

- Monitor the DAG's execution and logs in the Airflow UI under the **DAG Runs** and **Task Instances** tabs.
- Troubleshoot failed tasks by checking task logs and reviewing any errors in the Fivetran connectors or Cloud Run job.

## DAG Structure Overview

The DAG performs the following steps for each advertising platform:

1. **Initiate Fivetran Sync**: Starts the data synchronization using `FivetranOperator`.
2. **Wait for Sync Completion**: Uses `FivetranSensor` to poll until the sync is complete.
3. **Execute Cloud Run Job**: Triggers a Cloud Run job using `CloudRunExecuteJobOperator` after all syncs are completed.

### Task Dependencies

- Each Fivetran sync start task is followed by a sensor task that waits for completion.
- Once all syncs are complete, the DAG triggers a Cloud Run job that depends on all sync completions.
- The tasks for Facebook Ads, Google Ads, and LinkedIn Ads run independently and in parallel, with the Cloud Run job dependent on all syncs finishing.
