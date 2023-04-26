from tf2 import Tf2, LocalCommandExecutor

tf2 = Tf2()

@tf2.test("resources.azurerm_public_ip.my_terraform_public_ip")
def test_nginx_access(self):
    executor = LocalCommandExecutor()
    executor.execute(
        f"curl -s http://{ self.values.ip_address }"
    )
    assert executor.result.rc == 0

@tf2.test("resources.azurerm_public_ip.my_terraform_public_ip")
def test_nginx_status(self):
    executor = LocalCommandExecutor()
    executor.execute(
        f"curl -I http://{ self.values.ip_address }"
    )
    # print("stdout", executor.result.stdout)
    assert "HTTP/1.1 200 OK" in executor.result.stdout.strip()

@tf2.test("resources.azurerm_public_ip.my_terraform_public_ip")
def test_nginx_home(self):
    executor = LocalCommandExecutor()
    executor.execute(
        f"curl http://{ self.values.ip_address }"
    )
    # print("stdout", executor.result.stdout)
    assert "Welcome to nginx!" in executor.result.stdout.strip()

tf2.run()