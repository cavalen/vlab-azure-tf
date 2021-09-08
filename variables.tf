# Azure Environment
variable sp_subscription_id {}
variable sp_client_id {}
variable sp_client_secret {}
variable sp_tenant_id {}
variable prefix {}
variable location {}

# Users and passwords
variable nodeuser {}
variable nodepass {}

# NETWORK
variable allow_cidr { default = "0.0.0.0/0"}
variable vnet_cidr { default = "10.1.0.0/16" }
variable "subnets" {
    type = map
    default = {
        "mgmt" = "10.1.1.0/24"
        "external" = "10.1.10.0/24"
        "internal" = "10.1.20.0/24"
    }
}
variable "ports" {
    type = list
    default = ["22", "80", "443", "8443", "8080-8089", "3000"]
}
variable f5vm01mgmt { default = "10.1.1.245" }
variable f5vm01ext { default = "10.1.10.245" }
variable f5vm01int { default = "10.1.20.245" }
variable f5publicvip { default = "10.1.10.246" }
variable f5privatevip { default = "10.1.10.247" }
variable serverip { default = "10.1.10.80" }
variable mgmt_gw { default = "10.1.1.1" }
variable ext_gw { default = "10.1.10.1" }

# TAGS
variable purpose { default = "public" }
variable environment { default = "f5env" } #ex. dev/staging/prod
variable owner { default = "f5owner" }
variable group { default = "f5group" }
variable costcenter { default = "f5costcenter" }
variable application { default = "f5app" }

# REST API Setting
variable rest_do_uri { default = "/mgmt/shared/declarative-onboarding" }
variable rest_as3_uri { default = "/mgmt/shared/appsvcs/declare" }
variable rest_do_method { default = "POST" }
variable rest_as3_method { default = "POST" }
variable rest_vm01_do_file { default = "vm01_do_data.json" }
variable rest_vm_as3_file { default = "vm01_as3_data.json" }
variable rest_ts_uri { default = "/mgmt/shared/telemetry/declare" }
variable rest_vm_ts_file { default = "vm01_ts_data.json" }

# BIGIP Image - PAYG 
#    List of all images ---> az vm image list --output table --publisher f5-networks --all
#variable instance_type { default = "Standard_DS4_v2" }
#variable image_name { default = "f5-bigip-virtual-edition-25m-best-hourly" }
#variable product { default = "f5-big-ip-best" }
#variable bigip_version { default = "15.1.004000" }
#variable license1 { default = "" }

# BIGIP Image - PAYG (AWAF)
#    List of all images ---> az vm image list --output table --publisher f5-networks --all
variable instance_type { default = "Standard_DS4_v2" }
#variable image_name { default = "f5-big-awf-plus-hourly-25mbps" }
#variable product { default = "f5-big-ip-advanced-waf" }
variable image_name { default = "f5-bigip-virtual-edition-25m-best-hourly" }
variable product { default = "f5-big-ip-best"" }
variable bigip_version { default = "16.1.000000" }
variable license1 { default = "" }

## BIGIP Image - BYOL
#variable instance_type { default = "Standard_DS4_v2" }
#variable image_name { default = "f5-big-all-1slot-byol" }
#variable product { default = "f5-big-ip-byol" }
#variable bigip_version { default = "15.1.004000" }
#variable license1 { default = "XXXX-XXXX-XXXX-XXXX" }


# BIGIP Setup
variable host1_name { default = "f5vm01" }
variable dns_server { default = "8.8.8.8" }
variable ntp_server { default = "0.us.pool.ntp.org" }
variable timezone { default = "UTC" }
variable DO_URL { default = "https://github.com/F5Networks/f5-declarative-onboarding/releases/download/v1.13.0/f5-declarative-onboarding-1.13.0-5.noarch.rpm" }
variable AS3_URL { default = "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.20.0/f5-appsvcs-3.20.0-3.noarch.rpm" }
variable TS_URL { default = "https://github.com/F5Networks/f5-telemetry-streaming/releases/download/v1.12.0/f5-telemetry-1.12.0-3.noarch.rpm" }
variable libs_dir { default = "/config/cloud/azure/node_modules" }
variable onboard_log { default = "/var/log/startup-script.log" }
