variable "prefix" {
  type = string
  description = "The Desired Prefix  for all the Reosurces"
  default = "demo"
}


variable "env" {
  type = string
  description = "The Name of the Environment"
  default = "Dev"
}

variable "vnetCIDR" {
    type = list
    description = "IP Range of your Vnet CIDR"
    default = ["10.0.0.0/16"]
}

variable "dnsServers" {
    type = list
    default = ["10.0.0.4", "10.0.0.5"]
}

variable "bastionCIDR" {
    type = list
    description = "IP Range of your bastion subnet"
    default = ["10.0.1.0/24"]
}


variable "webCIDR" {
    type = list
    description = "IP Range of your wxeb subnet"
    default = ["10.0.5.0/24"]
}


variable "appCIDR" {
    type = list
    description = "IP Range of your app subnet"
    default = ["10.0.15.0/24"]
}



variable "dbCIDR" {
    type = list
    description = "IP Range of your DB subnet"
    default = ["10.0.30.0/24"]
}

variable "apiCIDR" {
    type = list
    description = "IP Range of your api subnet"
    default = ["10.0.40.0/24"]
}

# Variables for Bastion
variable "pubKeyPath" {}
variable "bastionVmSize" {}
variable "username" {}


variable webVmSize {
    description = "Size of the Web VMs"
    default = "Standard_B1s"

}
variable "webvmcount" {
    description = "No of Web VMS needed"
    default = 3
}