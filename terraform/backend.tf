terraform {
  backend "s3" {
    bucket = var.STATE_BUCKET_NAME
    key    = var.STATE_BUCKET_KEY
    region = var.AWS_REGION
  }
}