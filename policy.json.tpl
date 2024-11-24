[
    {
        "name": "networking-admins",
        "path": "/terraform/networking/admins/users/",
        "policy_statement": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Action": [
                      "ec2:CreateVpc",
                      "ec2:DeleteVpc",
                      "ec2:DescribeVpcs",
                      "ec2:CreateSubnet",
                      "ec2:DeleteSubnet",
                      "ec2:DescribeSubnets",
                      "ec2:CreateRouteTable",
                      "ec2:AssociateRouteTable",
                      "ec2:DeleteRouteTable",
                      "ec2:DescribeRouteTables",
                      "ec2:CreateSecurityGroup",
                      "ec2:DeleteSecurityGroup",
                      "ec2:AuthorizeSecurityGroupIngress",
                      "ec2:RevokeSecurityGroupIngress",
                      "ec2:AuthorizeSecurityGroupEgress",
                      "ec2:RevokeSecurityGroupEgress"
                    ],
                    "Resource": "*"
                  },
                  {
                    "Effect": "Allow",
                    "Action": [
                        "s3:CreateBucket",
                        "s3:PutObject",
                        "s3:GetObject",
                        "s3:ListBucket",
                        "s3:PutBucketPolicy",
                        "s3:PutBucketAcl",
                        "s3:GetBucketPolicy",
                        "s3:GetBucketAcl"
                    ],
                    "Resource": [
                        "arn:aws:s3:::${bucket_name}",
                        "arn:aws:s3:::${bucket_name}/*"
                    ]
                },
                {
                    "Effect": "Allow",
                    "Action": [
                        "dynamodb:CreateTable",
                        "dynamodb:UpdateTable",
                        "dynamodb:DescribeTable",
                        "dynamodb:Query",
                        "dynamodb:Scan",
                        "dynamodb:GetItem",
                        "dynamodb:PutItem"
                    ],
                    "Resource": "arn:aws:dynamodb:*:*:table/${dynamodb_table_name}"
                },
                {
                    "Effect": "Deny",
                    "Action": [
                        "s3:DeleteBucket",
                        "s3:DeleteObject"
                    ],
                    "Resource": [
                        "arn:aws:s3:::${bucket_name}",
                        "arn:aws:s3:::${bucket_name}/*"
                    ]
                },
                {
                    "Effect": "Deny",
                    "Action": [
                        "dynamodb:DeleteTable",
                        "dynamodb:DeleteItem"
                    ],
                    "Resource": "arn:aws:dynamodb:*:*:table/${dynamodb_table_name}"
                }
            ]
        }
    },
    {
        "name": "networking-non-admins",
        "path": "/terraform/networking/non-admins/users/",
        "policy_statement": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Action": [
                      "ec2:CreateVpc",
                      "ec2:DescribeVpcs",
                      "ec2:CreateSubnet",
                      "ec2:DescribeSubnets",
                      "ec2:CreateRouteTable",
                      "ec2:AssociateRouteTable",
                      "ec2:DescribeRouteTables",
                      "ec2:CreateSecurityGroup",
                      "ec2:AuthorizeSecurityGroupIngress",
                      "ec2:RevokeSecurityGroupIngress",
                      "ec2:AuthorizeSecurityGroupEgress",
                      "ec2:RevokeSecurityGroupEgress"
                    ],
                    "Resource": "*"
                  },
                  {
                    "Effect": "Allow",
                    "Action": [
                        "s3:PutObject",
                        "s3:GetObject",
                        "s3:ListBucket",
                        "s3:PutBucketPolicy",
                        "s3:PutBucketAcl",
                        "s3:GetBucketPolicy",
                        "s3:GetBucketAcl"
                    ],
                    "Resource": [
                        "arn:aws:s3:::${bucket_name}",
                        "arn:aws:s3:::${bucket_name}/*"
                    ]
                },
                {
                    "Effect": "Allow",
                    "Action": [
                        "dynamodb:UpdateTable",
                        "dynamodb:DescribeTable",
                        "dynamodb:Query",
                        "dynamodb:Scan",
                        "dynamodb:GetItem",
                        "dynamodb:PutItem"
                    ],
                    "Resource": "arn:aws:dynamodb:*:*:table/${dynamodb_table_name}"
                },
                {
                    "Effect": "Deny",
                    "Action": [
                        "s3:DeleteBucket",
                        "s3:DeleteObject"
                    ],
                    "Resource": [
                        "arn:aws:s3:::${bucket_name}",
                        "arn:aws:s3:::${bucket_name}/*"
                    ]
                },
                {
                    "Effect": "Deny",
                    "Action": [
                        "dynamodb:DeleteTable",
                        "dynamodb:DeleteItem"
                    ],
                    "Resource": "arn:aws:dynamodb:*:*:table/${dynamodb_table_name}"
                }
            ]
        }
    }
]