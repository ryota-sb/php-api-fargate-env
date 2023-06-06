# パブリックルートテーブル作成
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.app_name}-${terraform.workspace}-public-rt"
  }
}

# プライベートルートテーブル作成
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.app_name}-${terraform.workspace}-private-rt"
  }
}

# インターネットゲートウェイをルートに追加
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

# パブリックルートテーブルとパブリックサブネットを関連付け
resource "aws_route_table_association" "public" {
  count          = 2
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id
}

# プライベートルートテーブルとプライベートサブネットを関連付け
resource "aws_route_table_association" "private" {
  count          = 2
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private[count.index].id
}

# パブリックルートテーブルとコードビルド用サブネットを関連付け
# resource "aws_route_table_association" "codebuild_private" {
#   route_table_id = aws_route_table.public.id
# }