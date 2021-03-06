resource "aws_iam_role" "cassandra_role" {
  name               = "${var.ENVIRONMENT}-${var.NAME}-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "cassandra_instance_profile" {
  name = "${var.ENVIRONMENT}-${var.NAME}-instance-profile"
  role = aws_iam_role.cassandra_role.name
}

resource "aws_iam_role_policy" "cassandra_policy" {
  name = "${var.ENVIRONMENT}-${var.NAME}-policy"
  role = aws_iam_role.cassandra_role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
       {
          "Effect": "Allow",
          "Action": [
              "s3:ListBucket"
          ],
          "Resource": [
              "arn:aws:s3:::${var.CONFIG_BUCKET_NAME}"
          ]
      },
      {
        "Action": [
          "s3:GetObject",
          "s3:GetObjectVersion"
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:s3:::${var.CONFIG_BUCKET_NAME}/*"
      }
    ]
  }
  EOF
}