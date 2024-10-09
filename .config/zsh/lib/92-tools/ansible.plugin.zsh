# vim: foldmethod=marker

# [[ -d "$XDG_CONFIG_HOME/ansible/roles" ]] && _prependvar ANSIBLE_ROLES_PATH "$XDG_CONFIG_HOME/ansible/roles"
# ANSIBLE_ROLES_PATH="./roles:$ANSIBLE_ROLES_PATH"
# export ANSIBLE_ROLES_PATH

alias ansible-playbook-local='ansible-playbook -c local -i localhost, '
