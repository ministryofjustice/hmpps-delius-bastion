terragrunt = {
  include {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = ["../bastion-vpc"]
  }
}

app_name = "bastion"

