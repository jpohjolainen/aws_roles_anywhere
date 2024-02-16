resource "random_string" "random" {
  length           = 8
  special          = false
  upper            = false
  override_special = "/@£$"
}

resource "aws_s3_bucket" "private_ca_s3" {
  bucket        = "private-ca-crl-${random_string.random.result}"
  force_destroy = true
}

data "aws_iam_policy_document" "acmpca_bucket_access" {
  statement {
    actions = [
      "s3:GetBucketAcl",
      "s3:GetBucketLocation",
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]

    resources = [
      aws_s3_bucket.private_ca_s3.arn,
      "${aws_s3_bucket.private_ca_s3.arn}/*",
    ]

    principals {
      identifiers = ["acm-pca.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_s3_bucket_policy" "private_ca_s3" {
  bucket = aws_s3_bucket.private_ca_s3.id
  policy = data.aws_iam_policy_document.acmpca_bucket_access.json
}
