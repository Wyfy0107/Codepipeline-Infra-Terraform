resource "aws_key_pair" "demo" {
  key_name   = "ssh key"
  public_key = file("${path.module}/instance.key.pub")
}
