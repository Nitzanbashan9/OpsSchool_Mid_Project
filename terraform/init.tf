terraform { 
    backend "s3" {
        bucket = "opschool-take2"
        key = "opsschool-take2.tfstate"
        region = "us-east-1"
        dynamodb_table = "tf_lock"
        profile = "opsschool-take2"
    }
}