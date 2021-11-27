resource "aws_key_pair" "cassandra_key_pair" {
  key_name   = "${var.ENVIRONMENT}-${var.NAME}-key-pair"
  public_key = file("key.pub")
}
