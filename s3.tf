resource "aws_s3_bucket" "demo" {
  bucket = "${var.project}-${var.environment}-demo"
  acl    = "private"
}
