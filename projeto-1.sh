# !/bin/bash

# @Author: Alvaro Santos
# UNIPÊ - CC P6

# Script para listar  usuários que possuem a shell BASH e possibilitar
# ao administrador as funções de: troca de shell, de senha ou sair do
# script.

set UID = "id -u"

if ! [ "$UID" -eq 0 ];
then
	echo "Necessário privilégio root para rodar o script."
	exit
fi

clear

Menu() {

	echo "----------------------------------------------"
	echo "                 Projeto 01                 "
	echo "----------------------------------------------"
	echo

	echo "[1] Listar usuários que possuem a shell BASH."
	echo "[2] Trocar a shell do usuário escolhido."
	echo "[3] Mudar senha do usuário escolhido."
	echo "[4] Sair."
	echo
	echo -n  "Digite uma opção: "

	read OPCAO

	case "$OPCAO" in

	       	1)
		echo
		echo "Carregando usuários..."
		sleep 2
		clear
		echo "Usuários com a shell BASH:"
		cut -d: -f 1,7 /etc/passwd | grep /bin/bash
		Menu ;;

		2)
		echo
		echo -n "Informe o nome do usuário: "
		read USUARIO
		touch  usuarios-bash.txt
		cut -d: -f 1,7 /etc/passwd | grep /bin/bash > usuarios-bash.txt
		TESTE=$(grep -w ^"$USUARIO" usuarios-bash.txt | cut -d: -f 1)

		if [ -z "$TESTE" ];
		then
			echo "Usuário não existe ou não possui a shell BASH."
		fi

		if [ -z "$USUARIO" ];
		then
			echo  "Digite um nome de usuário."
		fi

		while [ -z "$TESTE" ];
		do
			echo
			echo -n "Informe o nome do usuário:"
			read USUARIO
			TESTE=$(grep -w ^"$USUARIO" usuarios-bash.txt | cut -d: -f 1)

			if [ -z "$TESTE" ];
			then
				echo "Usuário não existe ou nao possui a shell BASH."
			fi

			if [ -z "$USUARIO" ];
			then
				echo  "Digite um nome de usuário."
			fi
		done

		echo
		echo "Carregando shells disponíveis..."
		sleep 2
		echo
		echo "As seguintes shells estão instaladas no servidor:"
		cat /etc/shells
		echo
		echo -n "Informe a nova shell: (Exemplo: bash): "
		read SHELLS

		TESTE2=$(grep -w "$SHELLS" /etc/shells | cut -d: -f 3)

		if [ -z "$TESTE2" ];
		then
			echo "Shell não existe ou não está instalada no servidor."
		fi

		if [ -z "$SHELLS" ];
		then
			echo "Digite uma shell."
		fi

		while [ -z "$TESTE2" ] || [ -z "$SHELLS" ];
		do
			echo
			echo "Informe a nova shell: (Exemplo: bash): "
			read SHELLS

			TESTE2=$(grep -w "$SHELLS" /etc/shells | cut -d: -f 3)

			if [ -z "$TESTE2" ];
			then
				echo "Shell não existe ou não está instalada no servidor."
			fi

			if [ -z "$SHELLS" ];
			then
				echo "Digite uma shell."
			fi
		done

		echo
		echo "Alterando shell do usuário..."
		sleep 2
		chsh -s /bin/"$SHELLS" "$USUARIO"
		rm usuarios-bash.txt
		clear
		echo "Shell alterada com sucesso."
		Menu ;;

		3)
		echo
		echo "Informe o nome do usuário: "
		read USER
		touch usuarios-bash.txt
		cut -d: -f 1,7 /etc/passwd | grep /bin/bash > usuarios-bash.txt
		TESTE3=$(grep -w ^"$USER" usuarios-bash.txt| cut -d: -f 1)

		if [ -z "$TESTE3" ];
		then
			echo "Usuário não existe ou não possui a shell BASH."
		fi

		if [ -z "$USER" ];
		then
			echo "Digite um nome de usuário."
		fi

		while [ -z "$TESTE3" ];
		do
			echo
			echo "Informe o nome do usuário: "
			read USER
			TESTE3=$(grep -w ^"$USER" usuarios-bash.txt | cut -d: -f 1)

			if [ -z "$TESTE3" ];
			then
				echo "Usuário não existe ou não possui a shell BASH."
			fi

			if [ -z "$USER" ];
			then
				echo "Digite um nome de usuário: "
			fi
		done

		passwd "$USER"
		sleep 2
		rm usuarios-bash.txt
		clear
		echo "Senha alterada com sucesso."
		Menu ;;

		4)
		echo "Fim do Script."
		exit ;;

		*)
		echo "Opção inválida."
		sleep 1
		./projeto-1.sh ;;

		esac
}

Menu
