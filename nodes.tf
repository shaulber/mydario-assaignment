resource "aws_iam_role" "mydario-assignment-workernodes" {
  name = "mydario-assignment-workernodes"
 
  assume_role_policy = jsonencode({
   Statement = [{
    Action = "sts:AssumeRole"
    Effect = "Allow"
    Principal = {
     Service = "ec2.amazonaws.com"
    }
   }]
   Version = "2012-10-17"
  })
 }

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
      policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
      role    = aws_iam_role.mydario-assignment-workernodes.name
}
resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.mydario-assignment-workernodes.name
}
resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role    = aws_iam_role.mydario-assignment-workernodes.name
}

resource "aws_eks_node_group" "mydario-assignment-worker-node-group" {
    cluster_name    = aws_eks_cluster.mydario-assignment-eks.name
    node_group_name = "mydario-assignment-worker-node-group"
    node_role_arn   = aws_iam_role.mydario-assignment-workernodes.arn

    subnet_ids = [
      aws_subnet.private-us-east-1a.id,
      aws_subnet.private-us-east-1b.id
    ]
    
    instance_types = ["t3.small"]
    
    scaling_config {
        desired_size = 1
        max_size     = 1
        min_size     = 1
    }

    depends_on = [
        aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
        aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
        aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly
    ]
}