#!/bin/bash

ldap_host="ldap://localhost"
ldap_port="389"
ldap_admin="dc=vpn-infra"
ldap_password="secret"
base_dn="dc=vpn-infra"

create_user() {
  local username="$1"
  local password="$2"

  ldif_file="$(mktemp)"
  
  cat <<EOF > "$ldif_file"
dn: uid=$username,ou=people,$base_dn
objectClass: inetOrgPerson
objectClass: person
objectClass: top
cn: $username
sn: $username
uid: $username
givenName: $username
EOF

  ldapadd -x -h $ldap_host -p $ldap_port -D "$ldap_admin" -w "$ldap_password" -f "$ldif_file"
  local exit_code=$?
  
  rm "$ldif_file"
  
  return $exit_code
}

read -p "Nom d'utilisateur : " username
read -s -p "Mot de passe : " password
echo

create_user "$username" "$password"
exit_code=$?

if [ $exit_code -eq 0 ]; then
  echo "L'utilisateur $username a été créé avec succès."
else
  echo "Une erreur s'est produite lors de la création de l'utilisateur."
fi