# Alexandria - Terraform Library

This repository serves as a Terraform library to be consumed by other GitHub repositories and services. It provides Infrastructure as Code (IaC) templates and modules to facilitate the deployment and management of cloud-based architectures.

## Overview

The Terraform library includes a collection of reusable Terraform modules and configurations that can be used to set up and manage various cloud resources. The primary goal is to provide a standardized and efficient way to manage infrastructure across different environments and projects.

## Repository Structure

- **.github/**: Contains GitHub-specific configurations and templates.
- **.terraform/**: Terraform-related files and configurations.
- **envs/**: Environment-specific Terraform configurations.
- **examples/**: Example configurations demonstrating how to use the modules.
- **github-workflows/**: GitHub Actions workflows for CI/CD.
- **modules/**: Reusable Terraform modules.
- **terraform/**: Main Terraform configurations.
- **terraform.tfstate.d/**: Terraform state files.

## Getting Started

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed
- AWS CLI configured with appropriate credentials
- GitHub token for accessing private repositories

### First Run

1. Log in to AWS SSO:
   ```sh
   aws sso login --profile sandbox-admin
   ```
2. Set the AWS profile:
   ```sh
   export AWS_PROFILE=sandbox-admin
   ```
3. Get the current branch name:
   ```sh
   BRANCH_NAME=$(git symbolic-ref --short HEAD)
   ```
4. Start the Terraform setup:
   ```sh
   make start-${BRANCH_NAME}
   ```

### Successive Runs

1. Log in to AWS SSO:
   ```sh
   aws sso login --profile sandbox-admin
   ```
2. Set the AWS profile:
   ```sh
   export AWS_PROFILE=sandbox-admin
   ```
3. Get the current branch name:
   ```sh
   BRANCH_NAME=$(git symbolic-ref --short HEAD)
   ```
4. Plan the Terraform changes:
   ```sh
   make plan-${BRANCH_NAME}
   ```
5. Apply the Terraform changes:
   ```sh
   make apply-${BRANCH_NAME}
   ```

## Usage

### Modules

The repository includes various modules that can be used to set up different cloud resources. Each module has its own README file with usage instructions and examples.

### Examples

The [examples](http://_vscodecontentref_/2) directory contains example configurations demonstrating how to use the modules. These examples can be used as a reference to create your own configurations.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request with your changes.

## License

This project is licensed under the MIT License.
