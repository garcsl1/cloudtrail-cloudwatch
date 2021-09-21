provider "aws" {
    region = "eu-west-1"
}

resource "aws_iam_role" "cloudtrail_example" {
  name = "cloudtrail-to-cloudwatch"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudtrail_example" {
  name = "cloudtrail-example"
  role = "${aws_iam_role.cloudtrail_example.id}"

policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "example" {
  name = "Example"
}

resource "aws_cloudtrail" "example" {
    name = "Example"
    cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.example.arn}:*"
    cloud_watch_logs_role_arn = "${aws_iam_role.cloudtrail_example.arn}"
    s3_bucket_name = "productionapp64"
}