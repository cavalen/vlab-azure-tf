resource "azurerm_kubernetes_cluster" "akscluster" {
    name                = "aks-${var.prefix}-${random_id.randomId.hex}"
    location            = azurerm_resource_group.tfresourcegroup.location
    resource_group_name = azurerm_resource_group.tfresourcegroup.name
    dns_prefix          = "k8s-${var.prefix}-${random_id.randomId.hex}"

    default_node_pool {
        name            = "default"
        node_count      = 2
        vm_size         = "Standard_D2_v2"
        vnet_subnet_id  = azurerm_subnet.subnets["external"].id

    }

    service_principal {
        client_id     = var.sp_client_id
        client_secret = var.sp_client_secret
    }


    addon_profile {
        kube_dashboard {
            enabled = true
        }
        oms_agent {
            enabled = true
            log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
        }
    }

    network_profile {
        load_balancer_sku   = "Standard"
        network_plugin      = "azure"
    }

    tags = {
        environment = var.environment
    }
}
