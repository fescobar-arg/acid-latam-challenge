# Define variables
variable "app_name" {
  type        = string
  description = "The name of the FastAPI application."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to deploy the application."
}

variable "location" {
  type        = string
  description = "The Azure region in which to deploy the application."
}

variable "client_id" {
  type        = string
  description = "The client ID of the service principal."
}

variable "client_secret" {
  type        = string
  description = "The client secret of the service principal."
}

variable "tenant_id" {
  type        = string
  description = "The tenant ID of the Azure subscription."
}

variable "subscription_id" {
  type        = string
  description = "The ID of the Azure subscription."
}
