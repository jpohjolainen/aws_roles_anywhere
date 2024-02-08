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
      country = "DE"
      organization = "PolarSquad"
      organizational_unit = "Dev"
      common_name = "DevCA"
    }
  }

  permanent_deletion_time_in_days = 7

  #
  # CRL (Certification Revoking List) configuration should be enabled so certificates can be revoked,
  # but for the moment it's not possible to enable RolesAnywhere to fetch CRL through Terraform so 
  # left out in this example.
  #
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
