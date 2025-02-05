# Terraform-Library

A library of cloud-based architectures using Terraform

### First Run

```
aws sso login --profile sandbox-admin
export AWS_PROFILE=sandbox-admin
BRANCH_NAME=$(git symbolic-ref --short HEAD)

make start-${BRANCH_NAME}
```

## Successive Runs

```
aws sso login --profile sandbox-admin
export AWS_PROFILE=sandbox-admin
BRANCH_NAME=$(git symbolic-ref --short HEAD)

make plan-${BRANCH_NAME}
make apply-${BRANCH_NAME}
```
