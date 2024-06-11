```bash
$ python3 --version
Python 3.8.3

$ python3 -m venv venv
$ source venv/bin/activate
(venv) $ pip install --upgrade pip
(venv) $ pip install -r requirements.txt
```

```bash
$ podman build \
   --file Containerfile \
   --tag image-msdocs-python-flask-azure-container-apps-3 \
   .

$ podman run \
    --name container-msdocs-python-flask-azure-container-apps-3 \
    --publish 5000:5000 \
    image-msdocs-python-flask-azure-container-apps-3
```

The following assumes that you:
- have a Linode account
- own a custom domain
- manage the custom domain via the _Domains_ section of your Linode account
  (FYI: that section is referred to as [the Linode DNS Manager](
    https://www.linode.com/docs/products/networking/dns-manager/
  ))
```bash
$ cp \
    infrastructure/terraform.tfvars.example \
    infrastructure/terraform.tfvars.sensitive
# Edit the newly-created file according to the instructions therein.

$ cd infrastructure

# Follow the instructions on
# https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/azure_cli :

#   - log into the Azure CLI using a User:
$ az login \
    --allow-no-subscriptions

#     (
#       The AzureAD provider operates on tenants and not on subscriptions.
#       We recommend always specifying `az login --allow-no-subscriptions`
#       as it will force the Azure CLI to report tenants with no associated subscriptions,
#       or where your user account does not have any roles assigned for a subscription.
#     )

#   - list the Subscriptions and Tenants associated with the account:
$ az account list \
    -o table \
    --all \
    --query "[].{TenantID: tenantId, Subscription: name, Default: isDefault}"

# [For each of the subsequent commands,]
# the provider will select the tenant ID from your default Azure CLI account.
# If you have more than one tenant listed in the output of `az account list`
# - for example if you are a guest user in other tenants -
# you can specify the tenant to use.

$ terraform init



$ ARM_TENANT_ID=<provide-the-ID-of-the-tenant-you-wish-to-deploy-to> terraform plan \
    -var-file=terraform.tfvars.sensitive \
    -target=linode_domain_record.l_d_r_1_txt \
    -target=linode_domain_record.l_d_r_2_cname \
    -out=phase-1.terraform.plan

$ ARM_TENANT_ID=<provide-the-ID-of-the-tenant-you-wish-to-deploy-to> terraform apply \
    phase-1.terraform.plan

# Confirm the "apply" request issued by the previous command
# by typing "yes" and pressing [Enter].



$ ARM_TENANT_ID=<provide-the-ID-of-the-tenant-you-wish-to-deploy-to> terraform plan \
    -var-file=terraform.tfvars.sensitive \
    -out=phase-2.terraform.plan

$ ARM_TENANT_ID=<provide-the-ID-of-the-tenant-you-wish-to-deploy-to> terraform apply \
    phase-2.terraform.plan

# Confirm the "apply" request issued by the previous command
# by typing "yes" and pressing [Enter].



$ ARM_TENANT_ID=<provide-the-ID-of-the-tenant-you-wish-to-deploy-to> terraform destroy \
    -var-file=terraform.tfvars.sensitive

# Confirm the "destroy" request issued by the previous command
# by typing "yes" and pressing [Enter].
```



It is possible (to use the Azure CLI in order)
to make the deployed web application available at a custom domain,
you can follow the instructions at
https://learn.microsoft.com/en-us/azure/container-apps/custom-domains-managed-certificates?pivots=azure-cli .

HOWEVER:
According to https://github.com/hashicorp/terraform-provider-azurerm/issues/21866 ,
it not possible (as of 2024/05/30) to use `terraform apply`
to achieve that;
in other words,
it is not possible to use `terraform apply`
to achieve
the effect of step 8 (= add a custom domain to your Azure Container App)
and
that of step 9 (= configure an Azure-Managed Certificate and bind the domain to your Azure Container App),
with both steps being the ones mentioned in the resource
which was linked to in the preceding sentence.
