#!/bin/bash

############################
######### DIALOGS ##########
############################

function StopProgram {
       return=$?
       [ $return -eq 1   ] && exit 1  # cancelar
       [ $return -eq 255 ] && exit 1  # Esc
}

function SitePrompt {
       dialog --title "Preencha o campo abaixo" \
	      --backtitle "Assistente para criação de site" \
	      --inputbox "Qual o nome do site ? (digitar sem o www.)" 0 50 2> /tmp/site.tmp
       StopProgram
       Site=$(cat /tmp/site.tmp | sed 's/^www\.//')
}

function SiteExist {
       if [ $chk -gt 0 ]; then
	     dialog --title 'Aviso!!!' --msgbox 'Esse site existe. Verifique com cuidado antes de prosseguir com a criação.' 8 70
	     dialog --title 'Aviso!!!' --yesno '\n Deseja criar o site mesmo assim ?\n\n' 0 0
             if [ $? -eq 1 ]; then
		     ./cl_manager.sh
	     fi
       fi
}

function UserPrompt {
       dialog --title "Preencha o campo abaixo" \
	      --backtitle "Assistente para criação de site" \
	      --inputbox "Qual o usuário vai administrar o site ?(Separar usuários com vírgula)" 0 60 2> /tmp/user.tmp
       StopProgram
       User=$(cat /tmp/user.tmp | sed 's/ //g')
}

function AnsibleBanner {
       clear
       echo "###############################################"
       echo "############## ANSIBLE RUNNNING ###############"
       echo "###############################################"
}

function LveResourcesPrompt {
       Name=$(echo usr_$Site | sed -e 's/\.domain\.com//' -e 's/\./-/')
       if [ ! -z $Name ]; then
	    dialog --title 'Seleção de Recursos' \
       	           --checklist 'O que você quer limitar?' \
       	           0 0 0                                    \
       	           cpu    'Limite de CPU'     off \
       	           memory 'Limite de Memória' off 2> /tmp/resources
       	    StopProgram
       	    Resources=$(cat /tmp/resources)

       	    grep cpu /tmp/resources &> /dev/null
       	    if [ $? -eq 0 ]; then 
       	            dialog --title "Preencha o campo abaixo" \
       	     	      --inputbox "Digite o valor que deseja limitar a CPU ?(De 1 à 100)" 0 60 2> /tmp/cpu_limit.tmp
       	            StopProgram
       	            Cpu=$(cat /tmp/cpu_limit.tmp)
       	    fi

       	    grep mem /tmp/resources &> /dev/null
       	    if [ $? -eq 0 ]; then 
       	            dialog --title "Preencha o campo abaixo" \
       	     	      --inputbox "Digite o valor que deseja limitar a Memória ?(o valor deve ser informado em MB)" 0 60 2> /tmp/mem_limit.tmp
       	            StopProgram
       	            Mem=$(cat /tmp/mem_limit.tmp)
       	    fi
       else
	       dialog --msgbox 'O site não foi encontrado.' 5 40
	       ./cl_manager.sh
       fi
}

function MainMenu {
	MenuSelect=$(dialog --stdout --backtitle 'Cloudlinux Manager V2.0 - by Michel Peterson' --menu 'Escolha uma opção:' 0 0 0 \
	        1. "Criar um novo site." \
	        2. "Criar umo novo blog." \
	        3. "Apagar um site."  \
	        4. "Aplicar controle de recursos." \
	        5. "Colocar um site em manutenção." \
	        6. "Remover um site de manutenção." \
	        7. "Adicionar um usuário ao site." \
	        8. "Remover um usuário do site." \
	        9. "Recriar atalhos para um usuário. - #ToDo" \
	        10. "Sair.")
	StopProgram
}
