{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "${project} ${environment} ECR policy",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "${ecs_instance_role_arn}"
                ]
            },
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:BatchDeleteImage",
                "ecr:SetRepositoryPolicy"
            ]
        }
    ]
}
