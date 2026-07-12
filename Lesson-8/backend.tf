#terraform {
#  backend "s3" {
#    bucket         = "emiliia-ft-state-lesson-99"
#    key            = "lesson-8/terraform.tfstate"
#    region         = "eu-central-1"
#    dynamodb_table = "terraform-lock"
#  }
#}