# Rebuilding the database

The databases can, at any point, be re-built from the archived data. The process may take a while, but it will ensure that the resulting bigquery database is in a clean state. This process can be done regularly (with caution to the possible costs of running this pipeline).

The process is,

- [ ] Deploy the updated processing code to the relevant stack (`pulumi up --stack test`)
- [ ] Delete the `bot-db` service
- [ ] Delete the `messages` postgres database in [CloudSQL](https://console.cloud.google.com/sql/instances/whatup-bc6c0a5/databases?authuser=0&project=whatup-deploy) (NOTE: make sure you are in the correct project and are deleting the database corresponding to the stack in question)
- [ ] Refresh the stack and deploy again in order to recreate the database (`pulumi refresh --stack test --skip-preview --yes && pulumi up --stack test`)
- [ ] Ensure `bot-db- has come back online and is healthy
- [ ] Manually trigger the [bot-db-load-archive-job](https://console.cloud.google.com/run/jobs/details/europe-west3/bot-db-load-archive-job-f1ff665/executions?authuser=0&project=whatup-deploy) job
  - Make sure to watch the logs of this job to make sure the new code is properly processing the archive files
  - NOTE: if time is of essence, you can do an "Execute job with overrides" and increase the number of tasks allocated to this job. Be caseful, however, of the resulting costs of doing so. The maximum value for this is ~75% the number of groups we are tracking
- [ ] Wait for the job to terminate
- [ ] Manually trigger the [bq-init-schema-job](https://console.cloud.google.com/run/jobs/details/europe-west3/bq-init-schema-job-c3d23d5/executions?authuser=0&project=whatup-deploy) job
- [ ] Manually trigger the BigQuery [scheduled queries](https://console.cloud.google.com/bigquery/scheduled-queries?authuser=0&project=whatup-deploy) by scheduling a backfill
  - NOTE: If you get an error about "inserted row has wrong column count", delete the target bigquery table, run a pulumi refresh/up, re-run the `bg-init-schema-job` and then re-trigger the backfill for that table

If all these steps complete without error, bigquery should have the newly processed data. If any steps before the "bq-init-schema" step fails, restart from the beginning of the checklist.

NOTE: `bot-db` will start failing after the delete of the database. Verify that it has sucessfully come back online. If it hasn't, make a simle change to whatupy and re-deploy the code at some point to "restart" the process
