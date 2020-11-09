
# BIG-IP
# https://github.com/F5Networks/f5-bigip-runtime-init

# Create Public IPs
resource "azurerm_public_ip" "vm01mgmtpip" {
  name                = "${var.prefix}-vm01-mgmt-pip"
  location            = azurerm_resource_group.tfresourcegroup.location
  sku                 = "Standard"
  resource_group_name = azurerm_resource_group.tfresourcegroup.name
  allocation_method   = "Static"
  domain_name_label   = "f5-${var.prefix}"

  tags = {
    Name        = "${var.environment}-vm01-mgmt-public-ip"
    environment = var.environment
    owner       = var.owner
    group       = var.group
    costcenter  = var.costcenter
    application = var.application
  }
}

resource "azurerm_public_ip" "vm01selfpip" {
  name                = "${var.prefix}-vm01-self-pip"
  location            = azurerm_resource_group.tfresourcegroup.location
  sku                 = "Standard"
  resource_group_name = azurerm_resource_group.tfresourcegroup.name
  allocation_method   = "Static"

  tags = {
    Name        = "${var.environment}-vm01-self-public-ip"
    environment = var.environment
    owner       = var.owner
    group       = var.group
    costcenter  = var.costcenter
    application = var.application
  }
}

resource "azurerm_public_ip" "vm01pubvippip" {
  name                = "${var.prefix}-pubvip-pip"
  location            = azurerm_resource_group.tfresourcegroup.location
  sku                 = "Standard"
  resource_group_name = azurerm_resource_group.tfresourcegroup.name
  allocation_method   = "Static"

  tags = {
    Name        = "${var.environment}-pubvip-public-ip"
    environment = var.environment
    owner       = var.owner
    group       = var.group
    costcenter  = var.costcenter
    application = var.application
  }
}

# Create BIG-IP Network Security Group and rules
resource "azurerm_network_security_group" "vm01nsg" {
  name                = "vm01-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.tfresourcegroup.name

  dynamic "security_rule" {
    iterator = port
    for_each = var.ports
    content {
      name                       = "tcp_${port.value}"
      priority                   = port.key + 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = port.value
      source_address_prefix      = "${chomp(data.http.myip.body)}/32"
      destination_address_prefix = "*"
    }
  }
  tags = {
    Name        = "${var.environment}-bigip-sg"
    environment = var.environment
    owner       = var.owner
    group       = var.group
    costcenter  = var.costcenter
    application = var.application
  }
}

# Create NIC for Management 
resource "azurerm_network_interface" "vm01-mgmt-nic" {
  name                = "${var.prefix}-mgmt0"
  location            = azurerm_resource_group.tfresourcegroup.location
  resource_group_name = azurerm_resource_group.tfresourcegroup.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.subnets["mgmt"].id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.f5vm01mgmt
    public_ip_address_id          = azurerm_public_ip.vm01mgmtpip.id
  }

  tags = {
    Name        = "${var.environment}-vm01-mgmt-int"
    environment = var.environment
    owner       = var.owner
    group       = var.group
    costcenter  = var.costcenter
    application = var.application
  }
}

# Create NIC for External
resource "azurerm_network_interface" "vm01-ext-nic" {
  name                 = "${var.prefix}-ext0"
  location             = azurerm_resource_group.tfresourcegroup.location
  resource_group_name  = azurerm_resource_group.tfresourcegroup.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.subnets["external"].id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.f5vm01ext
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.vm01selfpip.id
  }

  ip_configuration {
    name                          = "secondary1"
    subnet_id                     = azurerm_subnet.subnets["external"].id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.f5publicvip
    public_ip_address_id          = azurerm_public_ip.vm01pubvippip.id
  }

  ip_configuration {
    name                          = "secondary2"
    subnet_id                     = azurerm_subnet.subnets["external"].id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.f5privatevip
  }

  tags = {
    Name        = "${var.environment}-vm01-ext-int"
    environment = var.environment
    owner       = var.owner
    group       = var.group
    costcenter  = var.costcenter
    application = var.application
  }
}

# Associate network security groups with NICs
resource "azurerm_network_interface_security_group_association" "vm01-mgmt-nsg" {
  network_interface_id      = azurerm_network_interface.vm01-mgmt-nic.id
  network_security_group_id = azurerm_network_security_group.vm01nsg.id
}

resource "azurerm_network_interface_security_group_association" "vm01-ext-nsg" {
  network_interface_id      = azurerm_network_interface.vm01-ext-nic.id
  network_security_group_id = azurerm_network_security_group.vm01nsg.id
}

# Create F5 BIG-IP VMs
resource "azurerm_linux_virtual_machine" "f5vm01" {
  name                            = "${var.prefix}-f5vm01"
  location                        = azurerm_resource_group.tfresourcegroup.location
  resource_group_name             = azurerm_resource_group.tfresourcegroup.name
  network_interface_ids           = [azurerm_network_interface.vm01-mgmt-nic.id, azurerm_network_interface.vm01-ext-nic.id]
  size                            = var.instance_type
  admin_username                  = var.nodeuser
  admin_password                  = var.nodepass
  disable_password_authentication = false
  computer_name                   = "${var.prefix}vm01"
  #custom_data                     = base64encode(data.template_file.vm_onboard.rendered)

  os_disk {
    name                 = "${var.prefix}-vm01-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "f5-networks"
    offer     = var.product
    sku       = var.image_name
    version   = var.bigip_version
  }

  plan {
    name      = var.image_name
    publisher = "f5-networks"
    product   = var.product
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }

  tags = {
    Name        = "${var.environment}-f5vm01"
    environment = var.environment
    owner       = var.owner
    group       = var.group
    costcenter  = var.costcenter
    application = var.application
  }
}

# Run Startup Script
resource "azurerm_virtual_machine_extension" "f5vm01-run-startup-cmd" {
  name                 = "${var.environment}-f5vm01-run-startup-cmd"
  virtual_machine_id   = azurerm_linux_virtual_machine.f5vm01.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
        {   
        "fileUris": [
            "https://raw.githubusercontent.com/cavalen/vlab-azure-tf/master/files/runtime-init-conf.yaml"
        ],
        "commandToExecute": "mkdir -p /config/cloud; mkdir -p /var/log/cloud/azure; cp runtime-init-conf.yaml /config/cloud/runtime-init-conf.yaml; curl -L https://cdn.f5.com/product/cloudsolutions/f5-bigip-runtime-init/v1.0.0/dist/f5-bigip-runtime-init-1.0.0-1.gz.run -o f5-bigip-runtime-init-1.0.0-1.gz.run && bash f5-bigip-runtime-init-1.0.0-1.gz.run -- '--cloud azure' 2>&1; f5-bigip-runtime-init --config-file /config/cloud/runtime-init-conf.yaml 2>&1"
        }
    SETTINGS

  tags = {
    Name        = "${var.environment}-f5vm01-startup-cmd"
    environment = var.environment
    owner       = var.owner
    group       = var.group
    costcenter  = var.costcenter
    application = var.application
  }
}
