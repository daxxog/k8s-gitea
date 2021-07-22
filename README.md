## gitea deployment

requires `gitea` namespace
```bash
scripts/generate.secrets.sh|kubectl -n gitea apply -f -
kubectl -n gitea apply -f gitea-deployment.yml
```

get a shell inside gitea container
```bash
kubectl -n gitea exec --stdin --tty $(kubectl -n gitea get pods | grep gitea | grep Running | awk '{split($0,a," ");print a[1]}') -c gitea -- /bin/bash
```

create admin user inside pod
```bash
gitea admin user create --username myusername --email my.email@example.com --admin --random-password
```
