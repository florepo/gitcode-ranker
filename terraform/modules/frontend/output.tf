output "web_bucket_id" {
  value = aws_s3_bucket.website.id
}
output "web_bucket_website_endpoint" {
  value = aws_s3_bucket.website.website_endpoint
}
