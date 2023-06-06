# ECRのVPCエンドポイント
resource "aws_vpc_endpoint" "vpce_ecr" {
  vpc_id             = aws_vpc.vpc.id
  service_name       = "com.amazonaws.ap-northeast-1.ecr.dkr"
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.main.id]
  subnet_ids = [
    aws_subnet.private[0].id,
    aws_subnet.private[1].id,
  ]
  private_dns_enabled = true
  tags = {
    Name = "ECR"
  }
}

# LogsのVPCエンドポイント
resource "aws_vpc_endpoint" "vpce-logs" {
  vpc_id             = aws_vpc.vpc.id
  service_name       = "com.amazonaws.ap-northeast-1.logs"
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.main.id]
  subnet_ids = [
    aws_subnet.private[0].id,
    aws_subnet.private[1].id,
  ]
  private_dns_enabled = true
  tags = {
    Name = "CloudWatch-logs"
  }
}

# S3のVPCエンドポイント
resource "aws_vpc_endpoint" "vpce_s3" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.ap-northeast-1.s3"
  vpc_endpoint_type = "Gateway"
  tags = {
    Name = "S3"
  }
}

# プライベートルートテーブルとS3のVPCエンドポイントを関連付け
resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  vpc_endpoint_id = aws_vpc_endpoint.vpce_s3.id
  route_table_id  = aws_route_table.private.id
}