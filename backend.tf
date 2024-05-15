terraform{
    backend "azurerm"{
        storage_account_name = "trainingstorage06"
        container_name = "backend"
        key = "terraform.tfstate"
        access_key = "oyQRkncNQpyKwRjo/H1ml14IfRqq4KS5+tKlnEhaAsVUMm8OJMBBZX205MC6jIkfFbhL0cAZWyOd+AStAOFbAg=="
    }
}