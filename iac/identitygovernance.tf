resource "azuread_access_package_catalog" "Sandbox" {
  description  = "Hackathon Sandboxes"
  display_name = "Sandbox"
  published    = true
}

# Define an Azure AD Access Package resource named "access_package"
resource "azuread_access_package" "access_package" {
  # The count parameter determines how many instances of this resource to create, based on the length of the csv_data list.
  count = length(local.csv_data)
  # The display_name parameter sets the display name of the access package for each instance,
  # using the Team, Environment, and Application attributes from the csv_data list.
  display_name = format("%s-%s-%s-access-package", local.csv_data[count.index].Team, local.csv_data[count.index].Environment, local.csv_data[count.index].Application)
  # The catalog_id parameter sets the ID of the access package catalog for each instance,
  # using the Sandbox catalog ID.
  catalog_id = azuread_access_package_catalog.Sandbox.id
  # The description parameter sets the description of the access package for each instance,
  # using the Team, Environment, and Notes attributes from the csv_data list.
  description = "Access package for ${local.csv_data[count.index].Team}-${local.csv_data[count.index].Environment}-${local.csv_data[count.index].Notes}"
}

# Assign all groups we have created to our catalog
resource "azuread_access_package_resource_catalog_association" "CloudSandbox_Groups" {
  # The count parameter determines how many instances of this resource to create, based on the length of the csv_data list.
  count = length(local.csv_data)
  # The catalog_id parameter sets the ID of the access package catalog for each instance, using the Sandbox catalog ID.
  catalog_id = azuread_access_package_catalog.Sandbox.id
  # The resource_origin_id parameter sets the ID of the Azure AD group for each instance, using the index from the csv_data list.
  resource_origin_id = azuread_group.ad_group[count.index].id
  # The resource_origin_system parameter specifies the origin system of the resource, which is "AadGroup" in this case.
  resource_origin_system = "AadGroup"
}

resource "azuread_access_package_resource_package_association" "group_association" {
  # The count parameter determines how many instances of this resource to create, based on the length of the csv_data list.
  count = length(local.csv_data)
  # The access_package_id parameter sets the ID of the access package for each instance, using the index from the csv_data list.
  access_package_id = azuread_access_package.access_package[count.index].id
  # The catalog_resource_association_id parameter sets the ID of the catalog resource association for each instance, using the index from the csv_data list.
  catalog_resource_association_id = azuread_access_package_resource_catalog_association.CloudSandbox_Groups[count.index].id
}

# Policy creation and assignment, done manually.