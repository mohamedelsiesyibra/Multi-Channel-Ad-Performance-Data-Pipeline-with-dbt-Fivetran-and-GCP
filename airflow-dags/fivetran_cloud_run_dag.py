from airflow import DAG
from airflow.providers.google.cloud.operators.cloud_run import CloudRunExecuteJobOperator
from airflow.operators.dummy import DummyOperator
from fivetran_provider_async.operators import FivetranOperator
from fivetran_provider_async.sensors import FivetranSensor
from datetime import datetime, timedelta

# Define placeholders for sensitive information
GCP_PROJECT_ID = 'your_gcp_project_id'  # Replace with your GCP project ID
REGION = 'your_region'  # Replace with your GCP region (e.g., europe-west2)
CLOUD_RUN_JOB_ID = 'your_cloud_run_job_id'  # Replace with your Cloud Run job ID
FIVETRAN_FACEBOOK_CONNECTOR_ID = 'your_facebook_ads_connector_id'  # Replace with actual Fivetran Facebook Ads connector ID
FIVETRAN_GOOGLE_CONNECTOR_ID = 'your_google_ads_connector_id'  # Replace with actual Fivetran Google Ads connector ID
FIVETRAN_LINKEDIN_CONNECTOR_ID = 'your_linkedin_ads_connector_id'  # Replace with actual Fivetran LinkedIn Ads connector ID

# Define the DAG
with DAG(
    dag_id='fivetran_and_cloud_run_dag',
    start_date=datetime(2023, 1, 1),
    schedule_interval='@daily',
    catchup=False,
) as dag:
    
    # Facebook Ads Sync
    fivetran_facebook_sync_start = FivetranOperator(
        task_id="fivetran-facebook-task",
        fivetran_conn_id="fivetran_conn",
        connector_id=FIVETRAN_FACEBOOK_CONNECTOR_ID,
    )

    fivetran_facebook_sync_wait = FivetranSensor(
        task_id="fivetran-facebook-sensor",
        fivetran_conn_id="fivetran_conn",
        connector_id=FIVETRAN_FACEBOOK_CONNECTOR_ID,
        poke_interval=5,
    )

    # Google Ads Sync
    fivetran_google_sync_start = FivetranOperator(
        task_id="fivetran-google-task",
        fivetran_conn_id="fivetran_conn",
        connector_id=FIVETRAN_GOOGLE_CONNECTOR_ID,
    )

    fivetran_google_sync_wait = FivetranSensor(
        task_id="fivetran-google-sensor",
        fivetran_conn_id="fivetran_conn",
        connector_id=FIVETRAN_GOOGLE_CONNECTOR_ID,
        poke_interval=5,
    )

    # LinkedIn Ads Sync
    fivetran_linkedin_sync_start = FivetranOperator(
        task_id="fivetran-linkedin-task",
        fivetran_conn_id="fivetran_conn",
        connector_id=FIVETRAN_LINKEDIN_CONNECTOR_ID,
    )

    fivetran_linkedin_sync_wait = FivetranSensor(
        task_id="fivetran-linkedin-sensor",
        fivetran_conn_id="fivetran_conn",
        connector_id=FIVETRAN_LINKEDIN_CONNECTOR_ID,
        poke_interval=5,
    )

    # Dummy operator to synchronize tasks before Cloud Run execution
    all_fivetran_jobs_done = DummyOperator(task_id="all_fivetran_jobs_done")

    # Cloud Run job task, which depends on all Fivetran syncs completing
    run_cloud_run_job = CloudRunExecuteJobOperator(
        task_id='run_cloud_run_job',
        project_id=GCP_PROJECT_ID,
        region=REGION,
        job_name=CLOUD_RUN_JOB_ID,
        retries=3,
        retry_delay=timedelta(minutes=5)
    )

    # Set task dependencies
    fivetran_facebook_sync_start >> fivetran_facebook_sync_wait >> all_fivetran_jobs_done
    fivetran_google_sync_start >> fivetran_google_sync_wait >> all_fivetran_jobs_done
    fivetran_linkedin_sync_start >> fivetran_linkedin_sync_wait >> all_fivetran_jobs_done

    all_fivetran_jobs_done >> run_cloud_run_job
