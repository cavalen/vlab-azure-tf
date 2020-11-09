# Dynamic Public IP address unknown until the VM starts.
# Check with "terraform refresh"

output "Resource_Group_name" { 
    value = "${azurerm_resource_group.tfresourcegroup.name}"     
    description = "Resource Group Name"
}

output "Security_Group_name" { 
    value = "${azurerm_network_security_group.vm01nsg.name}" 
    description = "Security Group Name"
}

output "BIG-IP_username" { value = "${var.nodeuser}"}
output "BIG-IP_password" { value = "${var.nodepass}"}
output "BIG-IP_mgmt_private_ip" { value = "${azurerm_network_interface.vm01-mgmt-nic.private_ip_address}" }
output "BIG-IP_mgmt_public_ip" { value = "${azurerm_public_ip.vm01mgmtpip.ip_address}" }
output "BIG-IP_mgmt_fqdn" { value = "${azurerm_public_ip.vm01mgmtpip.fqdn}" }
output "BIG-IP_Public_VIP" { value = "${azurerm_public_ip.vm01pubvippip.ip_address}" }
output "BIG-IP_Private_VIP" { value = "${azurerm_network_interface.vm01-ext-nic.private_ip_address}" }

output "Server_IP" { value = azurerm_public_ip.serverpublicip.ip_address }
output "Your_Public_IP" { value = "${chomp(data.http.myip.body)}/32" }

output "AKS_Cluster_Name" { value = azurerm_kubernetes_cluster.akscluster.name }
output "AKS_Cluster_FQDN" { value = azurerm_kubernetes_cluster.akscluster.fqdn }
