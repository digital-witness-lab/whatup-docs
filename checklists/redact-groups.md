
    
- [ ] create list of gs-urls to affected groups
    - ie: `gcloud storage ls gs://dwl-msgarc-76f5b32 | grep -E '/[0-9]+-[0-9]+@g.us' > gsurls.txt`
- [ ] copy affected data
```bash
for path in $( cat gsurls.txt ); do
    group=$( basename $path )
    gcloud storage rsync $path origina-data/$group
done
```

- [ ] distable whatupcore2 and all bot services
- [ ] copy affected data
```bash
for path in $( cat gsurls.txt ); do
    group=$( basename $path )
    gcloud storage rsync $path original-data/$group
done
```

- [ ] backup affected data
```bash
$ cp -r original-data workspace
```

- [ ] pulumi refresh && pulumi up
```bash
$ pulumi refresh --stack prod
$ pulumi up --stack prod
```

- [ ] run redact script
```bash
$ export ANON_KEY=pulumi config get whatupAnonKey --stack prod
$ ./scripts/redact-message-archive.sh /path/to/workspace/ /path/to/output/
```
- [ ] delete affected groups using databasebot-delete-groups job
    - When running the job, set the `WHATUPY_DELETE_GROUPS` envvar to the output of the following:
```bash
$ for path in $( cat gsurls.txt) ; do
    group=$( basename $path )
    echo -n "$group ";
done; echo
```

- [ ] upload redacted data
```bash
$ cd /path/to/output/
$ gcloud storage rsync . gs://dwl-msgarc-76f5b32
```

- [ ] delete old archive data
```bash
$ for path in $( cat gsurls.txt) ; do
    gcloud storage rm $path
done
```

- [ ] run load archive
