resource "azurerm_frontdoor" "this" {
  name                = "${var.project}-frontdoor-${var.env}"
  resource_group_name = var.resource_group_name

  routing_rule {
    name               = "${var.project}-frontdoor-routing-rule-${var.env}"
    accepted_protocols = ["Http", "Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = ["${var.project}-frontdoor-${var.env}"]

    forwarding_configuration {
      forwarding_protocol                   = "MatchRequest"
      cache_enabled                         = true
      cache_query_parameter_strip_directive = "StripNone"
      backend_pool_name                     = "exampleBackend"
    }

  }

  backend_pool_load_balancing {
    name = "${var.project}-frontdoor-backend-pool-lb${var.env}"
  }

  backend_pool_health_probe {
    name = "${var.project}-frontdoor-backend-pool-hp${var.env}"
  }

  backend_pool {
    name = "exampleBackend"
    backend {
      host_header = azurerm_cdn_frontdoor_endpoint.this.host_name
      address     = azurerm_cdn_frontdoor_endpoint.this.host_name
      http_port   = 80
      https_port  = 443
    }

    load_balancing_name = "${var.project}-frontdoor-backend-pool-lb${var.env}"
    health_probe_name   = "${var.project}-frontdoor-backend-pool-hp${var.env}"
  }

  frontend_endpoint {
    name      = "${var.project}-frontdoor-${var.env}"
    host_name = "${var.project}-frontdoor-${var.env}.azurefd.net"
  }
}

resource "azurerm_cdn_frontdoor_profile" "this" {
  name                = "${var.project}-frontdoor-profile-${var.env}"
  resource_group_name = var.resource_group_name
  sku_name            = "Standard_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_endpoint" "this" {
  name                     = "${var.project}-frontdoor-endpoint-${var.env}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
}

resource "azurerm_cdn_frontdoor_origin_group" "this" {
  name                     = "${var.project}-origin-group-${var.env}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
  session_affinity_enabled = true

  health_probe {
    interval_in_seconds = 100
    path                = "/"
    protocol            = "Http"
    request_type        = "HEAD"
  }

  load_balancing {
    additional_latency_in_milliseconds = 50
    sample_size                        = 4
    successful_samples_required        = 3
  }
}

resource "azurerm_cdn_frontdoor_origin" "this" {
  name                           = "${var.project}-origin-${var.env}"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.this.id
  health_probes_enabled          = true
  certificate_name_check_enabled = true

  host_name          = azurerm_storage_account.this.primary_web_host
  origin_host_header = azurerm_storage_account.this.primary_web_host
  http_port          = 80
  https_port         = 443
  priority           = 1
  weight             = 1000
}