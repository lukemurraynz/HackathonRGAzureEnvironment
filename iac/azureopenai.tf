# This resource block defines an Azure Cognitive Account resource named "openai"
resource "azurerm_cognitive_account" "openai" {
  # The for_each argument is used to iterate over a map created from local.csv_data.
  # Each entry in the map is identified by an index (idx) and its corresponding value (val).
  for_each = { for idx, val in local.csv_data : idx => val }
  # The name of the cognitive account is dynamically set using the "Team" attribute from each value in the map.
  name = "openai-ca-${lower(each.value.Team)}-${lower(each.value.Location)}"
  # The location of the cognitive account is set using the "Location" attribute from each value in the map.
  location = each.value.Location
  # The resource group name is dynamically set using the key from the map.
  resource_group_name = azurerm_resource_group.rg[each.key].name
  # The kind of cognitive account is set to "OpenAI".
  kind = "OpenAI"
  # The SKU (pricing tier) of the cognitive account is set to "S0".
  sku_name = "S0"

  tags = {
    Purpose     = "azure openai"
    Environment = lower(each.value.Environment)
    Team        = lower(each.value.Team)
    Application = lower(each.value.Application)
  }

}