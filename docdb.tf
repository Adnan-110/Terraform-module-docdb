# Provisions Document-DB Cluster

resource "aws_docdb_cluster" "docdb" {
  cluster_identifier      = "roboshop-${var.ENV}-docdb"
  engine                  = var.DOCDB_ENGINE
  master_username         = local.DOCDB_USERNAME
  master_password         = local.DOCDB_PASSWORD
  engine_version          = var.DOCDB_ENGINE_VERSION
#   backup_retention_period = 5         # Commented to avoid backup
#   preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_docdb_subnet_group.docdb.name
  vpc_security_group_ids = [aws_security_group.allows_docdb.id]
}


# Creates a subnet-groups

resource "aws_docdb_subnet_group" "docdb" {
  name       = "roboshop-${var.ENV}-docdb-subnet-group"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS

  tags = {
    Name = "roboshop-${var.ENV}-docdb-subnet-group"
  }
}

# Creates Doc-DB Cluster Instances
resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = var.DOCDB_INSTANCE_COUNT
  identifier         = "roboshop-${var.ENV}-docdb-${count.index}"
  cluster_identifier = aws_docdb_cluster.docdb.id
  instance_class     = var.DOCDB_INSTANCE_TYPE
}