# Creating a new deployment

This checklist assumes you have set the new stack name as envvar NEW_STACK using `$ export NEW_STACK="<org>/<name>"`

- [ ] Create new GCP project
- [ ] Create the new stack and initialize the config: `pulumi stack init $NEW_STACK --copy-config-from mynameisfiber/prod`
- [ ] Create new salts and passwords for the stack:
```bash
for key in dbRootPassword msgPassword usrPassword whatupAnonKey whatupSalt wucPassword ;
do
  openssl rand -hex 64 | pulumi config set --stack $NEW_STACK --secret $key
done;
```
- [ ] Fields to manually set:
  - [ ] Set the `project`/`region`/`zone`/`bqDatasetRegion` fields to correspond with the desired data locality for the project
  - [ ] Set `control_groups` to empty list
  - [ ] Select a name for the `primary_bot_name`
- [ ] (Optional) Add corresponding auth helper target into "infrastructure/Makefile"
- [ ] Deploy `pulumi up --stack $NEW_STACK`
- [ ] Run `bot-onboard-job` (set `WHATUPY_ONBOARD_BOT_NAME` envvar)
- [ ] Onboard test device `@RegisterBot register infra-test` + add a couple groups through onboarding process (ref: group GGG)
- [ ] Send test messages on group GGG:
  - [ ] text
  - [ ] react to message
  - [ ] forward message (messages must be written by someone other than the person forwarding it)
  - [ ] image
- [ ] Verify media is located in media dwl-media bucket
- [ ] Verify data is in postgres DB using BigQuery external connection
- [ ] Run `bq-init-schema-messages-job` and `bq-init-schema-users-job` jobs
- [ ] Set schedule for `hash-gen-job`
- [ ] Manually run BigQuery scheduled queries
- [ ] Verify BigQuery data is filled
- [ ] Unregister `infra-test` device

Optional:
- [ ] Create `data-editors` group with permissions:
  - [ ] roles/bigquery.dataEditor
  - [ ] roles/bigquery.jobUser
  - [ ] roles/looker.instanceUser
  - [ ] roles/looker.viewer
  - [ ] roles/storage.objectViewer
- [ ] Create `data-viewers` group with permissions:
  - [ ] roles/bigquery.dataViewer
  - [ ] roles/bigquery.jobUser
  - [ ] roles/bigquery.user
  - [ ] roles/looker.viewer
  - [ ] roles/storage.objectViewer WITH CONDITION `resource.name.startsWith("{media_bucket.name}")`
- [ ] Create `group_info_canonical` table using the SQL below

## `group_info_canonical` table

```sql
CREATE MATERIALIZED VIEW `<UPDATE_LOCATION>.group_info_canonical`
OPTIONS (
  enable_refresh = true,
  refresh_interval_minutes = 10,
  max_staleness = INTERVAL "6" HOUR,
  allow_non_incremental_definition = true)
AS (
  SELECT t.*, max_ts.first_seen
  FROM `<UPDATE_LOCATION>.device_group_info` AS t
  JOIN (
    SELECT JID, MAX(last_seen) AS max_last_seen,
    min(timestamp) AS first_seen
    FROM `<UPDATE_LOCATION>.device_group_info`
    GROUP BY JID
  ) AS max_ts
  ON t.JID = max_ts.JID
  WHERE 
    (t.last_seen >= DATETIME_SUB(max_ts.max_last_seen, INTERVAL 24 HOUR) AND t.isPartialInfo = FALSE)
    OR t.last_seen = max_ts.max_last_seen
)
```
