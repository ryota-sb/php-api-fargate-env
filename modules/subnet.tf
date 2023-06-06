variable "availability_zones" {
  default = ["ap-northeast-1a", "ap-northeast-1c"]
  type    = list
}

variable "cidr_blocks_public" {
  default = ["10.0.0.0/24", "10.0.1.0/24"]
  type    = list
}

variable "cidr_blocks_private" {
  default = ["10.0.2.0/24", "10.0.3.0/24"]
  type    = list
}

# variable "cidr_block_codebuild" {
#   default = "10.0.4.0/24"
# }

variable "cidr_blocks_rds" {
  default = ["10.0.4.0/24", "10.0.5.0/24"]
  type    = list
}

variable "name_tag" {
  default = ["a", "c"]
  type    = list
}

# パブリックサブネット作成
resource "aws_subnet" "public" {
  count             = length(var.name_tag)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_blocks_public[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "${var.app_name}-${terraform.workspace}-public-1${var.name_tag[count.index]}"
  }
}

# プライベートサブネット作成
resource "aws_subnet" "private" {
  count             = length(var.name_tag)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_blocks_private[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "${var.app_name}-${terraform.workspace}-private-1${var.name_tag[count.index]}"
  }
}

# RDS配置プライベートサブネット
resource "aws_subnet" "rds_private" {
  count             = length(var.name_tag)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_blocks_rds[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "${var.app_name}-${terraform.workspace}-private-rds-1${var.name_tag[count.index]}"
  }
}