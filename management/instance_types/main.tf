/*

Example Terraform configuration to test instance_types.rego
This contains a selection of resource types from multiple cloud providers
NOTE: This does NOT necessarily include all applicable resource types
*/

terraform {

  backend "remote" {
    hostname     = "scalr-customer-success.scalr.io"
    organization = "env-t3qeqbo97mdot6o"
    workspaces {
      name = "opa-test"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.51.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "3.32.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "3.60.0"
    }
  }
}

#---------
# AWS

provider "aws" {
  region = "us-east-1"
}

# Obtain the AMI for the region
data "aws_ami" "the_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["099720109477"]
}

# AWS - Valid instance_type
resource "aws_instance" "valid_type" {
  ami           = data.aws_ami.the_ami.id
  instance_type = "t2.nano"
}

# AWS - Invalid instance_type
resource "aws_instance" "invalid_type" {
  ami           = data.aws_ami.the_ami.id
  instance_type = "t2.medium"
}

# AWS - Valid aws_ec2_capacity_reservation
resource "aws_ec2_capacity_reservation" "valid_type" {
  instance_type     = "t2.micro"
  instance_platform = "Linux/UNIX"
  availability_zone = "eu-west-1a"
  instance_count    = 1
}

# AWS - Invalid aws_ec2_capacity_reservation
resource "aws_ec2_capacity_reservation" "invalid_type" {
  instance_type     = "t3.nano"
  instance_platform = "Linux/UNIX"
  availability_zone = "eu-west-1a"
  instance_count    = 1
}

# AWS - Valid aws_launch_configuration
resource "aws_launch_configuration" "valid_type" {
  name          = "valid-alc"
  image_id      = data.aws_ami.the_ami.id
  instance_type = "t2.micro"
}

# AWS - Invalid aws_launch_configuration
resource "aws_launch_configuration" "invalid_type" {
  name          = "invalid-alc"
  image_id      = data.aws_ami.the_ami.id
  instance_type = "t3.large"
}

#----------
# Azure

variable "publisher" {
  default = "canonical"
}
variable "offer" {
  default = "UbuntuServer"
}
variable "sku" {
  default = "20.04.0-LTS"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "arg-1" {
  name     = "arg-1"
  location = "West Europe"
}

resource "azurerm_virtual_network" "avn-1" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.arg-1.location
  resource_group_name = azurerm_resource_group.arg-1.name
}

resource "azurerm_subnet" "as-1" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.arg-1.name
  virtual_network_name = azurerm_virtual_network.avn-1.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "ani" {
  count               = 4
  name                = "ani-${count.index}"
  location            = azurerm_resource_group.arg-1.location
  resource_group_name = azurerm_resource_group.arg-1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.as-1.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Azure - Valid size on azurerm_linux_virtual_machine
resource "azurerm_linux_virtual_machine" "valid-alvm" {
  name                  = "valid-alvm"
  location              = azurerm_resource_group.arg-1.location
  resource_group_name   = azurerm_resource_group.arg-1.name
  network_interface_ids = [azurerm_network_interface.ani[0].id]
  size                  = "Standard_A0"
  admin_username        = "adminuser"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = "latest"
  }
}

# Azure - Inalid size on azurerm_linux_virtual_machine
resource "azurerm_linux_virtual_machine" "invalid-alvm" {
  name                  = "invalid-alvm"
  location              = azurerm_resource_group.arg-1.location
  resource_group_name   = azurerm_resource_group.arg-1.name
  network_interface_ids = [azurerm_network_interface.ani[1].id]
  size                  = "Standard_A2"
  admin_username        = "adminuser"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = "latest"
  }
}

# Azure - Valid Sku on azurerm_linux_virtual_machine_scale_set
resource "azurerm_linux_virtual_machine_scale_set" "valid-alvmss" {
  name                = "valid-alvmss"
  resource_group_name = azurerm_resource_group.arg-1.name
  location            = azurerm_resource_group.arg-1.location
  sku                 = "Standard_A0"
  instances           = 1
  admin_username      = "adminuser"

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.as-1.id
    }
  }
}

# Azure - Invalid Sku on azurerm_linux_virtual_machine_scale_set
resource "azurerm_linux_virtual_machine_scale_set" "invalid-alvmss" {
  name                = "invalid-alvmss"
  resource_group_name = azurerm_resource_group.arg-1.name
  location            = azurerm_resource_group.arg-1.location
  sku                 = "Standard_F2"
  instances           = 1
  admin_username      = "adminuser"

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.as-1.id
    }
  }
}

# Azure - Valid size on azurerm_windows_virtual_machine
resource "azurerm_windows_virtual_machine" "valid-awvm" {
  name                = "valid-awvm"
  resource_group_name = azurerm_resource_group.arg-1.name
  location            = azurerm_resource_group.arg-1.location
  size                = "Standard_A0"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.ani[2].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

# Azure - Invalid size on azurerm_windows_virtual_machine
resource "azurerm_windows_virtual_machine" "invalid-awvm" {
  name                = "invalid-awvm"
  resource_group_name = azurerm_resource_group.arg-1.name
  location            = azurerm_resource_group.arg-1.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.ani[3].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

# Azure - valid sku on azurerm_windows_virtual_machine_scale_set
resource "azurerm_windows_virtual_machine_scale_set" "valid-awvmss" {
  name                = "valid-awvmss"
  resource_group_name = azurerm_resource_group.arg-1.name
  location            = azurerm_resource_group.arg-1.location
  sku                 = "Standard_A0"
  instances           = 1
  admin_password      = "P@55w0rd1234!"
  admin_username      = "adminuser"

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter-Server-Core"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.as-1.id
    }
  }
}

# Azure - invalid sku on azurerm_windows_virtual_machine_scale_set
resource "azurerm_windows_virtual_machine_scale_set" "invalid-awvmss" {
  name                = "invalid-awvmss"
  resource_group_name = azurerm_resource_group.arg-1.name
  location            = azurerm_resource_group.arg-1.location
  sku                 = "Standard_F2"
  instances           = 1
  admin_password      = "P@55w0rd1234!"
  admin_username      = "adminuser"

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter-Server-Core"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.as-1.id
    }
  }
}

#----------
# Google

variable "project" {
  sensitive = true
}

provider "google" {
  project = var.project
  region  = "us-central1"
  zone    = "us-central1-c"
}

# Google - Valid google_compute_instance
resource "google_compute_instance" "valid_type" {
  name         = "valid-gci"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"
  }
}

# Google - Invalid google_compute_instance
resource "google_compute_instance" "invalid_type" {
  name         = "invalid-gci"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"
  }
}

# Google - Valid google_compute_instance_template
resource "google_compute_instance_template" "valid_type" {
  machine_type = "n1-standard-1"

  disk {
    source_image = "debian-cloud/debian-9"
  }

  network_interface {
    network = "default"
  }

}

# Google - Invalid google_compute_instance_template
resource "google_compute_instance_template" "invalid_type" {
  machine_type = "e2-medium"

  disk {
    source_image = "debian-cloud/debian-9"
  }

  network_interface {
    network = "default"
  }

}