# Infrastructure for persistence backend (dynamodb)

resource "aws_dynamodb_table" "http-db" {
  name         = "smart-test-http-db"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "MockKey"
  attribute {
    name = "MockKey"
    type = "S"
  }
}
