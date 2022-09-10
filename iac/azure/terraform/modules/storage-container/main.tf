resource "azurerm_storage_account" "this" {
  # name can only consist of lowercase letters and numbers
  name                     = "azuresamplessa${var.env}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "this" {
  name                  = "${var.project}-sc-${var.env}"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}