# Creating a new deployment

This checklist assumes you have set the new stack name as envvar NEW_STACK using `$ export NEW_STACK="<org>/<name>"`

- [ ] Create new GCP project
- [ ] Create the new stack and initialize the config: `pulumi stack init $NEW_STACK --copy-config-from mynameisfiber/prod`
- [ ] Create new salts and passwords for the stack:
```bash
for key in dbRootPassword msgPassword usrPassword whatupAnonKey whatupSalt wucPassword;
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

TODO:
- create control group, modify config, add bot to it
- onboard new bot using job, re-deploy
- register first user with data
- run schema init job
