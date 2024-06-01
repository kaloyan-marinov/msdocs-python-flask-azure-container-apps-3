output "azurerm_linux_web_app_url" {
  value = "https://${azurerm_linux_web_app.l_w_a.default_hostname}"
}
