locals {
  gcp_project_id = "eighty4-learning"
}

source "googlecompute" "nomad_archetype" {
  project_id              = local.gcp_project_id
  image_name              = "eighty4-nomad-${ formatdate("YYYY-MM-DD", timestamp()) }"
  image_family            = "eighty4-nomad"
  source_image_family     = "debian-11"
  ssh_username            = "packer"
  zone                    = "us-central1-c"
  machine_type            = "e2-medium"
  pause_before_connecting = "30s"
}

build {
  sources = ["source.googlecompute.nomad_archetype"]

  provisioner "ansible" {
    playbook_file   = "./nomad.playbook.yml"
    user            = "packer"
    extra_arguments = [
      "--extra-vars", "@nomad.gcp.vars.yml"
    ]
  }

}
