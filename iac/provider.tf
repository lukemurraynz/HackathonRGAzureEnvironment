# Set the terraform required version and configure the Azure Provider with remote storage.

# Configure the Azure Provider
terraform {
  required_version = ">= 1.7.4, < 2.0.0" # Specifies the minimum and maximum required version of Terraform.
  required_providers {
    azurerm = {
      version = "~>3.111.0"         # Specifies the version of the azurerm provider to use.
      source  = "hashicorp/azurerm" # Specifies the source of the azurerm provider.

    }

    azuread = {
      version = "~>2.53.1"          # Specifies the version of the azuread provider.
      source  = "hashicorp/azuread" # Specifies the source of the azuread provider.
    }

    random = {
      source  = "hashicorp/random" # Specifies the source of the random provider.
      version = "3.6.2"            # Specifies the version of the random provider to use.
    }


  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform-hackathon-prod"
    storage_account_name = "tfstatehackathon"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_oidc             = true
  }


}

provider "azuread" {
  use_oidc = true
}

# Configure the Azure Provider with the features block
provider "azurerm" {

  skip_provider_registration = true
  use_oidc                   = true
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}
