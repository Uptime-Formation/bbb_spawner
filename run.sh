set -eu
trap 'echo "Aborting due to errexit on line $LINENO. Exit code: $?" >&2' ERR
set -o pipefail

_print_help() {
  cat <<HEREDOC

HEREDOC
}

###############################################################################
# Program Functions
###############################################################################

_setup_full() {
  _setup_terraform
  printf "Sleeping 15s to wait for VMs to boot fully\\n"
  printf "##############################################\\n"
  sleep 15
  _setup_ansible
}

_setup_terraform() {
  printf "Setup Terraform resources\\n"
  printf "##############################################\\n"
  cd "$TERRAFORM_DIR"
  tfenv install 0.12.30
  tfenv use 0.12.30
  terraform init
  terraform plan
  terraform apply -auto-approve 
  cd "$PROJECT_DIR"
}

_setup_ansible() {
  printf "Setup infra VPS using Ansible\\n"
  printf "##############################################\\n"
  cd "$ANSIBLE_DIR"
  # ansible-galaxy install -i -r roles/requirements.yml -p roles
  ansible-playbook -i ${ANSIBLE_INVENTORY} ${ANSIBLE_PLAYBOOK} -vv
  cd "$PROJECT_DIR"
}


_destroy_infra() {
  printf "DESTROY Terraform resources\\n"
  printf "##############################################\\n"
  cd "$TERRAFORM_DIR"
  terraform destroy -auto-approve
}

_recreate_infra() {
  printf "DESTROY AND REPROVISION\\n"
  printf "##############################################\\n"
  _destroy_infra
  _setup_full
}

_main() {
  source ./env_file

  if [[ "${1:-}" =~ ^-h|--help$  ]]
  then
    _print_help
  elif [[ "${1:-}" =~ ^terraform$  ]]
  then
    _setup_terraform
  elif [[ "${1:-}" =~ ^ansible$  ]]
  then
    _setup_ansible
  elif [[ "${1:-}" =~ ^destroy$  ]]
  then
    _destroy_infra
  elif [[ "${1:-}" =~ ^recreate$  ]]
  then
    _recreate_infra
  elif [[ "${1:-}" =~ ^all$  ]]
  then
    _setup_full
  elif [[ "${1:-}" =~ ^full$  ]]
  then
    _setup_full
  elif [[ "${1:-}" =~ ^setup$  ]]
  then
    _setup_full
  else
    _print_help
  fi
}

# Call `_main` after everything has been defined.
_main "$@"
