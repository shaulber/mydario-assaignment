resource "aws_iam_role" "mydario-assignment-iam-role" {
 name = "mydario-assignment-iam-role"

 assume_role_policy = <<POLICY
{
 "Version": "2012-10-17",
 "Statement": [
  {
   "Effect": "Allow",
   "Principal": {
    "Service": "eks.amazonaws.com"
   },
   "Action": "sts:AssumeRole"
  }
 ]
}
POLICY

}

resource "aws_iam_role_policy_attachment" "mydario-assignment-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.mydario-assignment-iam-role.name
}

resource "aws_eks_cluster" "mydario-assignment-eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.mydario-assignment-iam-role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.private-us-east-1a.id,
      aws_subnet.private-us-east-1b.id,
      aws_subnet.public-us-east-1a.id,
      aws_subnet.public-us-east-1b.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.mydario-assignment-AmazonEKSClusterPolicy]

  enabled_cluster_log_types = ["api", "audit"]

}

resource "aws_cloudwatch_log_group" "mydario-log" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 7 
}