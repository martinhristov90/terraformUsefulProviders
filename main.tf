module "random" {
    source = "./random_id_module"
    ami_image_id = "test_ami"
}

output "ami_id" {
    value = "${module.random.ami_id}"
}
output "Name" {
    value = "${module.random.Name}"
}