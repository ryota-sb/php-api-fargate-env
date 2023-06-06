resource "aws_cloudwatch_log_group" "nginx_cluster_log_group" {
  name = "/ecs/nginx-container"
}

resource "aws_cloudwatch_log_group" "php_cluster_log_group" {
  name = "/ecs/php-container"
}