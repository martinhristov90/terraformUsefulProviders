## This reposistory is created with learning purposes for Terraform, focusing on Terraform providers and data sources.

## Purpose :

- The repository provides simple guidelines how to use the `random_id` resource and `template` data provider.

## How to install terraform : 

- The information about installing terraform can be found on the HashiCorp website 
[here](https://learn.hashicorp.com/terraform/getting-started/install.html)

## What is `random_id` provider : 

- `random_id` is a resource that generates random numbers. Those numbers can be used in as unique identifiers when EC2 instance is created. Below is an example of how `random_id` resource is used: 

```
variable ami_image_id {}

resource "random_id" "server" {
  keepers = {
    # Generate a new id each time we switch to a new AMI id
    ami_id = "${var.ami_image_id}"
  }
  byte_length = 8
}


output "ami_id" {
  value = "${random_id.server.keepers.ami_id}"
}

output "Name" {
  value = "web-server-${random_id.server.hex}"
}

```
The code above is used as a module in this repository, located in the `random_id_module` directory. At first sight the code is hard to grasp, but lets examine it from top to bottom. 
- Firstly, variable `ami_image_id` is defined, its value is going to be passed from the `root` module. 
- Secondly, a resource of type `random_id` is defined, giving it name `server`.
- Here comes the tricky part, the variable (`ami_image_id`) is passed from the `root` module. The value of `ami_id` is assigned from `ami_image_id`, in this case it is going to be `test_ami` since it is defined this way in the `main.tf` of the `root` module. Having this variable located inside the `keepers` section means that for value of `test_ami` for `ami_image_id` only one randomly generated number is going to be produced. This creates bond between the `ami_image_id` and the generated number. If the value of `ami_image_id` is changed, new randomly generated number is going to be crated. No matter how many times `terraform apply` is run, the generated value for `test_ami` is going to be the same. The `output` values of the module are going to provide the generated value along side the passed value of `ami_image_id`. This comes pretty handy when, many instances out of same image need to be generated but they need to have unique identifier. For example : 
```

resource "aws_instance" "server" {
  tags = {
    Name = "web-server-${random_id.server.hex}"
  }
  ami = "${random_id.server.keepers.ami_id}"
}
```
- This `aws_instance` resource is going to create an instance from image `test_ami` and tag it with randomly generated number, if the section is added twice the tag values are going to be the same. 
- After running `terraform apply` in this repository, you should get output like this :
```
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

Name = web-server-076c07b4bda2df0c
ami_id = test_ami
```