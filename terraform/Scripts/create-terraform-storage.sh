#!/bin/sh

$RESOURCE_GROUP_NAME="dvt-infini-connect-terra-rg"
STORAGE_ACCOUNT_NAME="dvticterrasa"
CONTAINER_NAME="dvt-ic-tfstate"

# Create Resource Group
az group create -l westeurope -n $RESOURCE_GROUP_NAME

# Create Storage Account
az storage account create -n $STORAGE_ACCOUNT_NAME -g $RESOURCE_GROUP_NAME -l westeurope --sku Standard_LRS

# Create Storage Account blob
az storage container create  --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME