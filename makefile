# Makefile for managing Terraform stages

# Define the available stages (add more if needed)
STAGES := dev prod


# Define common variables
TF_DIR := terraform/src
TF_REMOTE_STATE_DIR := terraform/remote-state

# The first launch of the service
start-%:
	cd $(TF_REMOTE_STATE_DIR) && terraform init -backend-config=backend-$*.tfvars
	cd $(TF_REMOTE_STATE_DIR) && terraform fmt # format your terraform code
	cd $(TF_REMOTE_STATE_DIR) && terraform validate # validate your terraform code
	cd $(TF_REMOTE_STATE_DIR) && terraform plan -var="stage=$*"
	cd $(TF_REMOTE_STATE_DIR) && terraform apply -var="stage=$*"
	cd $(TF_DIR) && terraform init -backend-config=backend-$*.tfvars
	cd $(TF_DIR) && terraform fmt # format your terraform code
	cd $(TF_DIR) && terraform validate # validate your terraform code
	cd $(TF_DIR) && terraform plan -var="stage=$*" -target aws_iam_policy.terrform_service_iam_user_assume_role_policy
	cd $(TF_DIR) && terraform apply -var="stage=$*" -target aws_iam_policy.terrform_service_iam_user_assume_role_policy

# Generate a Terraform plan for the specified stage
plan-%:
	cd $(TF_DIR) && terraform init -backend-config=backend-$*.tfvars
	cd $(TF_DIR) && terraform fmt # format your terraform code
	cd $(TF_DIR) && terraform validate # validate your terraform code
	cd $(TF_DIR) && terraform plan -var="stage=$*" -out=tfplan

# Apply the Terraform configuration for the specified stage
apply-%:
	cd $(TF_DIR) && terraform init -backend-config=backend-$*.tfvars
	cd $(TF_DIR) && terraform fmt # format your terraform code
	cd $(TF_DIR) && terraform validate # validate your terraform code
	cd $(TF_DIR) && terraform apply -var="stage=$*"

# Destroy the Terraform resources for the specified stage
destroy-%:
	cd $(TF_DIR) && terraform init -backend-config=backend-$*.tfvars
	cd $(TF_DIR) && terraform fmt # format your terraform code
	cd $(TF_DIR) && terraform validate # validate your terraform code
	cd $(TF_DIR) && terraform destroy -var="stage=$*"


# Show available stages
help:
	@echo "Available stages:"
	@echo "  $(STAGES)"
	@echo ""
	@echo "Usage:"
	@echo "  make <target>"
	@echo ""
	@echo "  Available targets for each stage:"
	@echo "  make start-<stage>   - First command to run when initially launching the service."
	@echo "  make plan-<stage>    - Generate a Terraform plan for the specified stage."
	@echo "  make apply-<stage>   - Apply the Terraform configuration for the specified stage."
	@echo "  make destroy-<stage> - Destroy the Terraform resources for the specified stage."
	@echo "  make help            - Show this help message."

default: help
$(STAGES): help

.PHONY: default $(STAGES)
