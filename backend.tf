terraform{
    backend "azurerm"{
        storage_account_name = "trainingstorage06"
        container_name = "backend"
        key = "terraform.tfstate"
        access_key = ""
    }
}
