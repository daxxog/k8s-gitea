#!/bin/bash
generate_python_secret() {
    python3 -c 'from secrets import choice;from string import digits, ascii_uppercase, ascii_lowercase;print("".join(map(lambda x: choice(digits + ascii_uppercase + ascii_lowercase), range(0,64))))' | tr -d '\n' | base64 | tr -d '\n'
}

generate_gitea_secret() {
    if [ "$#" -ne 1 ]; then
        echo "Usage: generate_gitea_secret {SECRET_TYPE}"
        docker run -t gitea/gitea:1.14.0-rc1 gitea generate secret
        exit 2
    fi
    docker run -t gitea/gitea:1.14.0-rc1 gitea generate secret ${1} | tr -d '\n' | tr -d '\r' | base64 | tr -d '\n'
}


cat templates/gitea-secrets.template.yml | \
    sed "s/__MINIO_ROOT_PASSWORD__/$(generate_python_secret)/g" | \
    sed "s/__REDIS_PASSWORD__/$(generate_python_secret)/g" | \
    sed "s/__POSTGRES_PASSWORD__/$(generate_python_secret)/g" | \
    sed "s/__INTERNAL_TOKEN__/$(generate_gitea_secret INTERNAL_TOKEN)/g" | \
    sed "s/__JWT_SECRET__/$(generate_gitea_secret JWT_SECRET)/g" | \
    sed "s/__LFS_JWT_SECRET__/$(generate_gitea_secret LFS_JWT_SECRET)/g" | \
    sed "s/__SECRET_KEY__/$(generate_gitea_secret SECRET_KEY)/g" | \
cat
