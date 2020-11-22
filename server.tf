# Server 
# VM, NSG, Network Interface, Public IP 

# Create Server public IP
resource "azurerm_public_ip" "serverpublicip" {
    name                         = "server-public-ip"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.tfresourcegroup.name
    allocation_method            = "Dynamic"
}

# Create Network Security Group and rules
resource "azurerm_network_security_group" "servernsg" {    
    name                = "server-nsg"
    location            = var.location
    resource_group_name = azurerm_resource_group.tfresourcegroup.name
    
    dynamic "security_rule" {
        iterator = port
        for_each = var.ports
        content {
            name                        = "tcp_${port.value}"
            priority                    = port.key + 101
            direction                   = "Inbound"
            access                      = "Allow"
            protocol                    = "Tcp"
            source_port_range           = "*"
            destination_port_range      = port.value
            source_address_prefix       = "${chomp(data.http.myip.body)}/32"
            destination_address_prefix  = "*"
        }
    }
}

# Create network interface
resource "azurerm_network_interface" "servernic" {
    name                      = "server-nic-ext"
    location                  = var.location
    resource_group_name       = azurerm_resource_group.tfresourcegroup.name

    ip_configuration {
        name                          = "server_NicConfiguration"
        subnet_id                     = azurerm_subnet.subnets["external"].id
        private_ip_address_allocation = "Static"
        private_ip_address            = var.serverip
        public_ip_address_id          = azurerm_public_ip.serverpublicip.id
        primary                       = true
    }
    tags = {
        Name        = "${var.environment}-backend01-ext-int"
        environment = var.environment
        owner       = var.owner
        group       = var.group
        costcenter  = var.costcenter
        application = "app1"
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "servernic-nsg" {
    network_interface_id      = azurerm_network_interface.servernic.id
    network_security_group_id = azurerm_network_security_group.servernsg.id
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "tfservervm" {
    name                            = "server-vm"
    location                        = var.location
    resource_group_name             = azurerm_resource_group.tfresourcegroup.name
    network_interface_ids           = [azurerm_network_interface.servernic.id]
    size                            = "Standard_B2ms"
    computer_name                   = "servervm"
    admin_username                  = var.nodeuser
    admin_password                  = var.nodepass
    disable_password_authentication = false
    #custom_data                     = base64encode(local.backendvm_custom_data)

    os_disk {
        name              = "server-os-disk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }
}

resource "azurerm_virtual_machine_extension" "tfservervm-script" {
    name                 = azurerm_linux_virtual_machine.tfservervm.name
    virtual_machine_id   = azurerm_linux_virtual_machine.tfservervm.id
    publisher            = "Microsoft.Azure.Extensions"
    type                 = "CustomScript"
    type_handler_version = "2.0"
    settings = <<SETTINGS
        {
            "fileUris": ["https://raw.githubusercontent.com/cavalen/vlab-azure-tf/master/files/config_server.sh" ],
            "commandToExecute": "nohup sh config_server.sh </dev/null >/dev/null 2>&1 & "
        }
    SETTINGS
    tags = {
        environment = "vlab"
    }
    }
