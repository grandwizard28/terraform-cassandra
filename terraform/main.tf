data "template_file" "cassandra_user_data" {
  template = file("scripts/cassandra_user_data.sh")

  vars = {
    T_BUCKET_NAME = "${var.CONFIG_BUCKET_NAME}"
    T_BUCKET_KEY  = "${var.CONFIG_BUCKET_KEY}"
  }
}

data "template_cloudinit_config" "cloudinit_cassandra" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.cassandra_user_data.rendered
  }
}


resource "aws_instance" "cassandra_seed_nodes" {
  count           = length(var.SUBNET_IDs)
  ami             = var.AMI
  instance_type   = var.INSTANCE_TYPE
  subnet_id       = var.SUBNET_IDs[count.index]
  user_data       = data.template_cloudinit_config.cloudinit_cassandra.rendered
  security_groups = [aws_security_group.cassandra_security_group.id]
  key_name        = aws_key_pair.cassandra_key_pair.key_name
  tags = {
    "Name"             = upper("${var.ENVIRONMENT}-${var.NAME}-${count.index}")
    "Environment"      = upper("${var.ENVIRONMENT}"),
    "Mudrex:Terraform" = upper(true)
  }
}

output "cassandra_seed_nodes_private_ips" {
  value = aws_instance.cassandra_seed_nodes.*.private_ip
}