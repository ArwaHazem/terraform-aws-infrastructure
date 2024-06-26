resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-private-subnets"
  subnet_ids = [
    module.network.subnets["private-subnet-1"].id,
    module.network.subnets["private-subnet-2"].id,
  ]
  tags = {
    Name = "${var.prefix_resource_name}-redis-subnet-group"
  }
}


resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "cache-cluster"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids   = [aws_security_group.cache_security_group.id]
}