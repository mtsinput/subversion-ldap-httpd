# Install

```
docker stack deploy --compose-file docker-compose-creatio_svn.yml --with-registry-auth prd_creatio_svn
```

## SVN create
in the container console:

```bash
cd /var/svn
svnadmin create <repository>
```

# Troubleshoot

* check container running
* check gluster-fs contains data
* check LDAP is available
