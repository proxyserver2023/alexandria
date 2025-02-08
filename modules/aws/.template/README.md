# TITLE

<!-- Briefly describe the module in a sentence -->

## Usage

Review the [general usage guidance](/modules/README.md#usage)

<!-- Provide any module specific usage instructions here -->

## Requirements

AWS Provider version >= <VERSION_NUMBER>

## Inputs

<details>
    <summary>input-name-1</summary>

</details>

## Outputs

<details>
    <summary>output-name-1</summary>

</details>

## Example

<details>
    <summary>main.tf</summary>

    ```terraform
        module "module-name" {
            source = "git::https://${var.token}@github.com/proxyserver2023/Terraform-Library.git//modules/bc-module-name"

            input-name-1 = ""

        }

        module "dependent-module-nickname" {
            module.module-name.output-name-1
        }
    ```

</details>
