output "azurerm_container_app_url" {
  # value = azurerm_container_app.c_a.latest_revision_fqdn
  # (
  # Based on
  # https://stackoverflow.com/a/75803638
  # and
  # https://github.com/hashicorp/terraform-provider-azurerm/issues/20696#issuecomment-1578567585 ,
  # the following is an improvement upon the former :
  # )
  value = "https://${azurerm_container_app.c_a.ingress[0].fqdn}"
}
