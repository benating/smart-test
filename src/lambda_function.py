import boto3

dynamodb = boto3.resource("dynamodb", region_name="eu-west-2")
table = dynamodb.Table("smart-test-http-db")

def lambda_handler(event, context):
    path = event.get("path")
    http_method = event.get("httpMethod")

    # Based on path and http method and perhaps query params, do something and store in the db
    # table.put_item or update_item can be used
    # with params (Item={"MockKey": key, ... (other columns))

    # then return some data to the caller through apigw
    return {
        "headers": {"Access-Control-Allow-Origin": "*"},
        "statusCode": 200,
        "body": f"{body}",
    }
