resource "azurerm_storage_account" "this" {
  # name can only consist of lowercase letters and numbers
  name                     = "staticwebsitekalilsa${var.env}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  static_website {
    index_document     = "index.html"
    error_404_document = "error.html"
  }
}