# AWS main domain bucket (file storage)
resource "aws_s3_bucket" "website" {
  bucket = "${var.frontend_subdomain}"
  acl    = "public-read"
  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AddPerm",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::${var.frontend_subdomain}/*"]
    }
  ]
}
  POLICY

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}
