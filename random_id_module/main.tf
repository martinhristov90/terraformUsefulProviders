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

