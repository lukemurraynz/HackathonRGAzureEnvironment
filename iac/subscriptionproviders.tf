variable "resource_providers" {
  description = "Map of Azure resource providers to register"
  default = {
    "Microsoft.Maps"                    = {}
    "Microsoft.OperationalInsights"     = {}
    "Microsoft.EventGrid"               = {}
    "Microsoft.EventHub"                = {}
    "Microsoft.GuestConfiguration"      = {}
    "Microsoft.HDInsight"               = {}
    "Microsoft.KeyVault"                = {}
    "Microsoft.Kusto"                   = {}
    "microsoft.insights"                = {}
    "Microsoft.Logic"                   = {}
    "Microsoft.MachineLearningServices" = {}
    "Microsoft.Media"                   = {}
    "Microsoft.MixedReality"            = {}
    "Microsoft.Monitor"                 = {}
    "Microsoft.Network"                 = {}
    "Microsoft.NotificationHubs"        = {}
    "Microsoft.OperationsManagement"    = {}
    "Microsoft.Relay"                   = {}
    "Microsoft.RecoveryServices"        = {}
    "Microsoft.ResourceHealth"          = {}
    "Microsoft.Search"                  = {}
    "Microsoft.ServiceBus"              = {}
    "Microsoft.Databricks"              = {}
    "Microsoft.Web"                     = {}
    "Microsoft.ApiManagement"           = {}
    "Microsoft.Automation"              = {}
    "Microsoft.AzurePlaywrightService"  = {}
    "Microsoft.Batch"                   = {}
    "Microsoft.BotService"              = {}
    "Microsoft.Chaos"                   = {}
    "Microsoft.Compute"                 = {}
    "Microsoft.ContainerService"        = {}
    "Microsoft.DBforMySQL"              = {}
    "Microsoft.DBforMariaDB"            = {}
    "Microsoft.DBforMySQL"              = {}
    "Microsoft.DBforPostgreSQL"         = {}
    "Microsoft.DataFactory"             = {}
    "Microsoft.HealthBot"               = {}
    "Microsoft.HealthModel"             = {}
    "Microsoft.HealthcareApis"          = {}
    "Microsoft.MachineLearning"         = {}
    "Microsoft.Orbital"                 = {}
    "Microsoft.Sql"                     = {}
    // Add the rest of your providers here
  }
}

resource "azurerm_resource_provider_registration" "resourceproviders" {
  for_each = var.resource_providers
  name     = each.key
}
