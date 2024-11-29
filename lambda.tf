data "archive_file" "lambda" {
  type        = "zip"
  source_file = "hello_world/app.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_layer_version" "jwt" {
  filename   = "python.zip"
  layer_name = "jwt"

  compatible_runtimes = ["python3.9"]
}

resource "aws_lambda_function" "loja-authorizer" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "lambda_function_payload.zip"
  function_name = "lambda_loja_authorizer"
  role          = "arn:aws:iam::339712924021:role/LabRole"
  handler       = "app.lambda_handler"
  layers        = [aws_lambda_layer_version.jwt.arn] 

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.9"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

