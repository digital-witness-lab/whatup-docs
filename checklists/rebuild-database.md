# Rebuilding the database

The databases can, at any point, be re-built from the archived data. The process may take a while, but it will ensure that the resulting bigquery database is in a clean state. This process can be done regularly (with caution to the possible costs of running this pipeline).

The process is,

- [ ] Deploy the updated processing code to the relevant stack (`pulumi up --stack test`)
- [ ] Delete the `messages` postgres database in [CloudSQL](https://console.cloud.google.com/sql/instances/whatup-bc6c0a5/databases?authuser=0&project=whatup-deploy) (NOTE: make sure you are in the correct project and are deleting the database corresponding to the stack in question)
- [ ] Manually trigger the [bot-db-load-archive-job](https://console.cloud.google.com/run/jobs/details/europe-west3/bot-db-load-archive-job-f1ff665/executions?authuser=0&project=whatup-deploy) job (NOTE: if time is of essence, you can do an "Execute job with overrides" and increase the number of tasks allocated to this job. Be caseful, however, of the resulting costs of doing so. The maximum value for this is ~75% the number of groups we are tracking)
- [ ] Wait for the job to terminate
- [ ] Manually trigger the BigQuery [scheduled queries](https://console.cloud.google.com/bigquery/scheduled-queries?authuser=0&project=whatup-deploy)

If all these steps complete without error, bigquery should have the newly processed data.
