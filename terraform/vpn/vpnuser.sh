#!/bin/bash

function create() {
  CLIENT=$1
  conf="/tmp/$CLIENT.ovpn"

  # verifica se o usuario ja existe
  CLIENTEXISTS=$(tail -n +2 /etc/openvpn/easy-rsa/pki/index.txt | grep -c -E "/CN=$CLIENT\$")
  if [[ $CLIENTEXISTS == '1' ]]; then
    echo ""
    echo -e "\e[31;1mERRO: Usuario ja existe.\e[m"
    exit 1
  fi

  cd /etc/openvpn/easy-rsa/ || return
  ./easyrsa build-client-full "$CLIENT" nopass
  echo "Usuario $CLIENT adicionado."

	cp /etc/openvpn/client-template.txt $conf
	{
		echo "<ca>"
		cat "/etc/openvpn/easy-rsa/pki/ca.crt"
		echo "</ca>"

		echo "<cert>"
		awk '/BEGIN/,/END/' "/etc/openvpn/easy-rsa/pki/issued/$CLIENT.crt"
		echo "</cert>"

		echo "<key>"
		cat "/etc/openvpn/easy-rsa/pki/private/$CLIENT.key"
		echo "</key>"

		echo "key-direction 1"

		echo "<tls-crypt>"
		cat /etc/openvpn/tls-crypt.key
		echo "</tls-crypt>"

	} >>"$conf"

  # Remover chave de usuario
  rm -rf "/etc/openvpn/easy-rsa/pki/private/$CLIENT.key"

  adduser -s /bin/null $CLIENT
  passwd $CLIENT

  echo -e "\n\e[32;1mArquivo de configuracao do usuario disponivel em:\e[m\n$conf"
}

function remove() {
  CLIENT=$1

  # verifica se o usuario existe
	CLIENTEXISTS=$(tail -n +2 /etc/openvpn/easy-rsa/pki/index.txt | grep -c -E "/CN=$CLIENT\$")
  if [[ $CLIENTEXISTS != '1' ]]; then
    echo ""
    echo -e "\e[31;1mUsuario nao existe.\e[m"
    exit 1
  fi

	cd /etc/openvpn/easy-rsa/ || return
	./easyrsa --batch revoke "$CLIENT"
	EASYRSA_CRL_DAYS=3650 ./easyrsa gen-crl
	rm -f /etc/openvpn/crl.pem
	cp /etc/openvpn/easy-rsa/pki/crl.pem /etc/openvpn/crl.pem
	chmod 644 /etc/openvpn/crl.pem
	find /home/ -maxdepth 2 -name "$CLIENT.ovpn" -delete
	sed -i "/^$CLIENT,.*/d" /etc/openvpn/ipp.txt
	cp /etc/openvpn/easy-rsa/pki/index.txt{,.bk}

  userdel -r $CLIENT

	echo ""
	echo "Usuario $CLIENT removido."
}

function list {
  echo "# Usuarios ativos"
  egrep  -v "(^R|CN=server/)" /etc/openvpn/easy-rsa/pki/index.txt | sed -r "s/.*CN=([[:alnum:]\.\-\_]*)\/.*/\1/g"
}


#
case $1 in
    create)
      create $2
    ;;
    list)
      list $2
    ;;
    remove)
      remove $2
    ;;
    *)
      echo -e "Uso:"
      echo -e "- Criar usuario"
      echo -e "  vpnuser create <nome_usuario>"
      echo -e "\n- Listar usuarios existentes"
      echo -e "  vpnuser list"
      echo -e "\n- Remover usuario"
      echo -e "  vpnuser remove <nome_usuario>"
    ;;
  esac
