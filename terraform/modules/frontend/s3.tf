# AWS main domain bucket (file storage)
resource "aws_s3_bucket" "website" {
  bucket = var.web_bucket_name
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
      "Resource":["arn:aws:s3:::${var.web_bucket_name}/*"]
    }
  ]
}
  POLICY

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}
