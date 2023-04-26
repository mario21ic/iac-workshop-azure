locals {
  network_name  = "${terraform.workspace}-myVnet"
  subnet_name   = "${terraform.workspace}-mySubnet"
  nic_name      = "${terraform.workspace}-myNIC"
  public_ip_name = "${terraform.workspace}-myPublicIP"
  vm_name       = "${terraform.workspace}-myLinuxVM"
}


# Create virtual network
resource "azurerm_virtual_network" "my_terraform_network" {
  # name                = "myVnet"
  name                = local.network_name
  address_space       = ["10.0.0.0/16"]
  # location            = data.azurerm_resource_group.rg.location
  # resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.consul_keys.resource_group_location.var.resource_group_location
  resource_group_name = data.consul_keys.resource_group_name.var.resource_group_name
  
  tags = {
    environment = terraform.workspace
    tool        = "terraform"
  }
}

# module "myvnet" {
#   source = "github.com/mario21ic/azure_virtual_network?ref=v1.2" # usando una version
#   name   = "myVnet"
#   location = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name
# }

# Create subnet
resource "azurerm_subnet" "my_terraform_subnet" {
  # name                 = "mySubnet"
  name                 = local.subnet_name
  # resource_group_name  = data.azurerm_resource_group.rg.name
  resource_group_name = data.consul_keys.resource_group_name.var.resource_group_name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name # dependencia por recurso
  # virtual_network_name = module.myvnet.vnet_name # dependencia por modulo
  address_prefixes     = ["10.0.1.0/24"]
  
  # NO soportado
  # tags = {
  #   environment = terraform.workspace
  #   tool        = "terraform"
  # }
}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip" {
  # name                = "myPublicIP"
  name                = local.public_ip_name
  # location            = data.azurerm_resource_group.rg.location
  # resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.consul_keys.resource_group_location.var.resource_group_location
  resource_group_name = data.consul_keys.resource_group_name.var.resource_group_name
  allocation_method   = "Dynamic"

  tags = {
    environment = terraform.workspace
    tool        = "terraform"
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = "myNetworkSecurityGroup"
  # location            = data.azurerm_resource_group.rg.location
  # resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.consul_keys.resource_group_location.var.resource_group_location
  resource_group_name = data.consul_keys.resource_group_name.var.resource_group_name

  security_rule {
    name = "http"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "80"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
}

# Create network interface
resource "azurerm_network_interface" "my_terraform_nic" {
  # name                = "myNIC"
  name                = local.nic_name
  # location            = data.azurerm_resource_group.rg.location
  # resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.consul_keys.resource_group_location.var.resource_group_location
  resource_group_name = data.consul_keys.resource_group_name.var.resource_group_name

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = azurerm_subnet.my_terraform_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }

  tags = {
    environment = terraform.workspace
    tool        = "terraform"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

# Generate random text for a unique storage account name
# resource "random_id" "random_id" {
#   keepers = {
#     # Generate a new ID only when a new resource group is defined
#     resource_group = data.azurerm_resource_group.rg.name
#   }

#   byte_length = 8
# }

# # Create storage account for boot diagnostics
# resource "azurerm_storage_account" "my_storage_account" {
#   name                     = "diag${random_id.random_id.hex}"
#   location                 = data.azurerm_resource_group.rg.location
#   resource_group_name      = data.azurerm_resource_group.rg.name
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }

# Create (and display) an SSH key
# resource "tls_private_key" "example_ssh" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# Create virtual machine
resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  # name                  = "myVM"
  # name                  = "myLinuxVM"
  name                  = local.vm_name
  # location              = data.azurerm_resource_group.rg.location
  # resource_group_name   = data.azurerm_resource_group.rg.name
  location            = data.consul_keys.resource_group_location.var.resource_group_location
  resource_group_name = data.consul_keys.resource_group_name.var.resource_group_name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id] # dependencia
  #size                  = "Standard_DS1_v2"
  size                  = "Standard_B1s"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    # sku       = "16.04-LTS"
    version   = "latest"
  }

  # Provisioner para instalar remotamente
  custom_data = base64encode(file("scripts/init.sh"))

  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  
  disable_password_authentication = false
  admin_password = "ClaveYP@ssw0rd1234!"
  
  # admin_ssh_key {
  #   username   = "azureuser"
  #   public_key = tls_private_key.example_ssh.public_key_openssh
  # }

  # boot_diagnostics {
  #   storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  # }

  tags = {
    environment = terraform.workspace
    tool        = "terraform"
  }
}
