from tf2 import Tf2, Terraform, TerraformPlanLoader

tf2 = Tf2(Terraform(TerraformPlanLoader()))

# @tf2.test("resources.azurerm_virtual_network.my_terraform_network")
# def test_vnet_name_not_default(self):
#     print(self.values.name)
#     # assert self.values.name != "default"
#     assert "default" not in self.values.name

@tf2.test("resources.azurerm_virtual_network.my_terraform_network")
def test_vnet_tags(self):
    # print("tags tool", self.values.tags.tool)
    # assert self.values.tags.environment != "default"
    assert self.values.tags.tool == "terraform"

@tf2.test("resources.azurerm_public_ip.my_terraform_public_ip")
def test_public_ip_tags(self):
    # assert self.values.tags.environment != "default"
    assert self.values.tags.tool == "terraform"

@tf2.test("resources.azurerm_network_interface.my_terraform_nic")
def test_network_interface_tags(self):
    # assert self.values.tags.environment != "default"
    assert self.values.tags.tool == "terraform"

@tf2.test("resources.azurerm_linux_virtual_machine.my_terraform_vm")
def test_virtual_machine_tags(self):
    # assert self.values.tags.environment != "default"
    assert self.values.tags.tool == "terraform"

# Ejecutar los tests
tf2.run()