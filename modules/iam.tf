resource "aws_iam_role" "fargate_task_execution" {
  name               = "fargate-task-execution-role"
  assume_role_policy = file("${path.module}/roles/fargate_task_assume_role.json")
}

resource "aws_iam_role_policy" "fargate_task_definition" {
  name   = "execution-policy"
  role   = aws_iam_role.fargate_task_execution.name
  policy = file("${path.module}/roles/fargate_task_execution_policy.json")
}

resource "aws_iam_policy_attachment" "ssm_access" {
  name   = "AmazonSSMReadOnlyAccess"
  roles   = [aws_iam_role.fargate_task_execution.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_policy_attachment" "rds_access" {
  name = "AmazonRDSDataFullAccess"
  roles = [aws_iam_role.fargate_task_execution.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSDataFullAccess"
}