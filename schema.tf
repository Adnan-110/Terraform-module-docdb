resource "null_resource" "schema" {
  # This make sure that null resource will ony be executed post the creation of the RDS/MYSQL only 
  depends_on = [ aws_docdb_cluster.docdb, aws_docdb_cluster_instance.cluster_instances ]

  provisioner "local-exec" {
    command = <<EOF
        cd /tmp
        wget https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem
        curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip"
        unzip -o mongodb.zip
        ls -ltr
        cd mongodb-main
        ls -ltr
        mongo --ssl --host ${aws_docdb_cluster.docdb.endpoint}:27017 --sslCAFile /tmp/global-bundle.pem --username admin1 --password roboshop1 < catalogue.js
        
        mongo --ssl --host ${aws_docdb_cluster.docdb.endpoint}:27017 --sslCAFile /tmp/global-bundle.pem --username ${local.DOCDB_USERNAME} --password ${local.DOCDB_PASSWORD} < users.js
   
    EOF
  }
}

# 1) Creates Resource 
# 2) Null provisioner authenticates/establishes connection to the newly created resource
# 3) Then executes tasks mentioned in the remote_exec block

