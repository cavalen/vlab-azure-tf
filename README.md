Deploy de BIG-IP 2-nic, Ubuntu Server y AKS Cluster (2 Nodes) usando Terraform 

Instalacion de Automation Toolchain (ATC) usando BIG-IP Runtime Init \
Configuracion de DO y AS3 usando BIG-IP Runtime Init 

https://github.com/F5Networks/f5-bigip-runtime-init \
https://github.com/F5Networks/f5-bigip-runtime-init/blob/main/SCHEMA.md 

Instrucciones:
- Copiar `terraform.tfvars.example` a `terraform.tfvars` 
- Editar `terraform.tfvars` y configurar:
  - Prefix (letras minusculas y numeros)
  - [Subscription ID](https://portal.azure.com/?quickstart=true#blade/Microsoft_Azure_Billing/SubscriptionsBlade)
  - [Client ID (Application ID)](https://portal.azure.com/?quickstart=true#blade/Microsoft_AAD_RegisteredApps/ApplicationsListBlade)
  - [Secret (Client Secret)](https://portal.azure.com/?quickstart=true#blade/Microsoft_AAD_RegisteredApps/ApplicationsListBlade)
  - [Tenant ID (Directory ID)](https://portal.azure.com/?quickstart=true#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/Overview)

terraform init
terraform plan
terraform apply

Notes:
- Nada
