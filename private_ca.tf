#
# Create private CA
#
resource "aws_acmpca_certificate_authority" "private_ca" {
  type = "ROOT"

  certificate_authority_configuration {
    key_algorithm     = "RSA_4096"
    signing_algorithm = "SHA512WITHRSA"

    # Subject can be as minimal as having just common_name with domain as value, 
    # country and others are not necessary
    subject {
      common_name         = var.ca_subject.common_name
      country             = lookup(var.ca_subject, "country", null)
      organization        = lookup(var.ca_subject, "organization", null)
      organizational_unit = lookup(var.ca_subject, "organizational_unit", null)
      state               = lookup(var.ca_subject, "state", null)
    }
  }

  permanent_deletion_time_in_days = 7


  revocation_configuration {
    crl_configuration {
      custom_cname       = "crl.privateca"
      enabled            = true
      expiration_in_days = 7
      s3_bucket_name     = aws_s3_bucket.private_ca_s3.id
      s3_object_acl      = "BUCKET_OWNER_FULL_CONTROL"
    }
  }

  depends_on = [ aws_s3_bucket_policy.private_ca_s3 ]
}

resource "aws_acmpca_certificate" "private_ca" {
  certificate_authority_arn   = aws_acmpca_certificate_authority.private_ca.arn
  certificate_signing_request = aws_acmpca_certificate_authority.private_ca.certificate_signing_request
  signing_algorithm           = "SHA512WITHRSA"

  template_arn = "arn:${data.aws_partition.current.partition}:acm-pca:::template/RootCACertificate/V1"

  validity {
    type  = "YEARS"
    value = 1
  }
}

resource "aws_acmpca_certificate_authority_certificate" "private_ca" {
  certificate_authority_arn = aws_acmpca_certificate_authority.private_ca.arn

  certificate       = aws_acmpca_certificate.private_ca.certificate
  certificate_chain = aws_acmpca_certificate.private_ca.certificate_chain
}
