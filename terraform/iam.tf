resource "aws_iam_role" "cassandra_role" {
  name               = "cassandra_role"
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
  name = "cassandra_instance_profile"
  role = aws_iam_role.cassandra_role.name
}

resource "aws_iam_role_policy" "cassandra_policy" {
  name = "cassandra_policy"
  role = aws_iam_role.cassandra_role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
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