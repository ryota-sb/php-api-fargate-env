# httpとhttpsを許可したセキュリティグループ作成
resource "aws_security_group" "main" {
  name   = "${var.app_name}-${terraform.workspace}-main-sg"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.app_name}-${terraform.workspace}-main-sg"
  }
}

# 3306ポートのみ許可するセキュリティグループ
resource "aws_security_group" "db" {
  name   = "${var.app_name}-${terraform.workspace}-db-sg"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.app_name}-${terraform.workspace}-db-sg"
  }
}