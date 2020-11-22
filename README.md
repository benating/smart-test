# Smart Test
Deploying a basic web application to the cloud, using Terraform and Python in AWS.

# Basic architecture outline
API Gateway <-> Lambda <-> DynamoDB

Note: No secrets are stored as I'm expecting them to be passed in during the terraform commands as environment variables, whether done locally or through an automation server like github actions.
