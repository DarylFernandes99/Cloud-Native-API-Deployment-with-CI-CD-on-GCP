build {
  sources = ["sources.googlecompute.webapp-base"]

  provisioner "shell" {
    script = "./scripts/update_centos.sh"
  }

  // provisioner "file" {
  //   source      = "./scripts/mysql_setup.exp"
  //   destination = "/tmp/mysql_setup.exp"
  // }

  provisioner "file" {
    source      = "./files/webapp-main.zip"
    destination = "/tmp/webapp-main.zip"
  }

  provisioner "file" {
    source      = "./files/csye6225.service"
    destination = "/tmp/csye6225.service"
  }

  provisioner "shell" {
    script = "./scripts/setup_user.sh"
  }

  // provisioner "shell" {
  //   script = "./scripts/install_mysql.sh"
  // }

  provisioner "shell" {
    script = "./scripts/install_python3.sh"
  }

  // provisioner "shell" {
  //   inline = [
  //     "echo \"==============================\"",
  //     "echo \"Update root user password in MySQL\"",
  //     "echo \"==============================\"",
  //     "sudo dnf install expect -y",
  //     "cd /tmp/",
  //     "sudo chmod +x mysql_setup.exp",
  //     "sudo expect mysql_setup.exp ${var.mysql_root_password}",
  //     "cd -"
  //   ]
  // }

  provisioner "shell" {
    script = "./scripts/unzip_artifact.sh"
  }

  provisioner "shell" {
    script          = "./scripts/setup_webapp.sh"
    execute_command = "sudo  {{.Path}}"
  }

  provisioner "shell" {
    script = "./scripts/enable_csye6225_service.sh"
  }

  // provisioner "shell" {
  //   inline = [
  //     "sudo journalctl -xe | grep csye6225"
  //   ]
  // }
}
