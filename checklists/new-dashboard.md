- [ ] Create new standard-storage GCS bucket
- [ ] Ensure [OAuth consent page](https://console.cloud.google.com/apis/credentials/consent?orgonly=true&project=whatup-prod&supportedpurview=project) is configured with the following permissions:
  - .../auth/userinfo.email
  - .../auth/userinfo.profile
  - openid
  - .../auth/admin.directory.group.readonly
- [ ] Create [oauth credential](https://console.cloud.google.com/apis/credentials?orgonly=true&project=whatup-prod&supportedpurview=project) and store in cred-tmp.json
- [ ] Create JWT secret and credentials secret:
  - `cat cred-tmp.json | pulumi config set --stack <STACK> --secret dashboardClientCreds`
  - `openssl rand -hex 64 | pulumi config set --stack <STACK> --secret dashboardJWT`
- [ ] Modify relevant stack config with the following data:

```yaml
  whatup:dashboards:
    - domain: <SUBDOMAIN>
      authGroups:
        - <AUTH GROUP>
      clientCredsKey: dashboardClientCreds
      gsPath: gs://<BUCKET NAME>/
      jwtKey: dashboardJWT
  whatup:dashboardClientCreds:
    secure: XXXX
  whatup:dashboardJWT:
    secure: XXXX
```

