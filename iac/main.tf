locals {
  # Read the content of the CSV file named "az_hackathon.csv" and store it in the local variable "csv_content".
  csv_content = file("az_hackathon.csv")
  # Decode the CSV content into a list of maps, where each map represents a row in the CSV file.
  csv_data    = csvdecode(local.csv_content)
}

# Define an Azure Resource Group resource named "rg".
resource "azurerm_resource_group" "rg" {
  # Create one resource group for each entry in the csv_data list.
  count    = length(local.csv_data)
  
  # Set the name of the resource group using the Team, Environment, and Application attributes from the csv_data list.
  name     = lower(format("%s-%s-%s-rg", local.csv_data[count.index].Team, local.csv_data[count.index].Environment, local.csv_data[count.index].Application))
  
  # Set the location of the resource group using the Location attribute from the csv_data list.
  location = local.csv_data[count.index].Location
  
  # Set tags for the resource group using attributes from the csv_data list.
  tags = {
    Environment = lower(local.csv_data[count.index].Environment)
    Team        = lower(local.csv_data[count.index].Team)
    Application = lower(local.csv_data[count.index].Application)
    Notes       = lower(local.csv_data[count.index].Notes)
  }
}

# Define an Azure AD Group resource named "ad_group".
resource "azuread_group" "ad_group" {
  # Create one Azure AD group for each entry in the csv_data list.
  count            = length(local.csv_data)
  # Set the display name of the Azure AD group using the Team, Environment, and Application attributes from the csv_data list.
  display_name     = lower(format("%s-%s-%s-group", local.csv_data[count.index].Team, local.csv_data[count.index].Environment, local.csv_data[count.index].Application))
  # Set the description of the Azure AD group using the Team, Environment, and Application attributes from the csv_data list.
  description      = format("Group for %s environment of %s application managed by %s team.", title(local.csv_data[count.index].Environment), title(local.csv_data[count.index].Application), title(local.csv_data[count.index].Team))
  # Disable mail for the Azure AD group.
  mail_enabled     = false
  # Enable security for the Azure AD group.
  security_enabled = true
}

# Define an Azure Role Assignment resource named "role_assignment".
resource "azurerm_role_assignment" "role_assignment" {
  # Create one role assignment for each entry in the csv_data list.
  count                = length(local.csv_data)
  # Set the scope of the role assignment to the ID of the corresponding resource group.
  scope                = azurerm_resource_group.rg[count.index].id
  # Assign the "Owner" role to the principal.
  role_definition_name = "Owner"
  # Set the principal ID to the object ID of the corresponding Azure AD group.
  principal_id         = azuread_group.ad_group[count.index].object_id
}