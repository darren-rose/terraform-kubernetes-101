# Terraform Kubernetes 101

Use Terraform to provision Kubernetes objects e.g. prods, services, etc

Initialise Kubernetes provider (Note: update the provider values for your cluster)

```
terraform init
```

Dry run detailing what will be provisioned

```
terraform plan
```

Provision objects

```
terraform apply
```

Destroy provisioned objects

```
terraform destroy
```
