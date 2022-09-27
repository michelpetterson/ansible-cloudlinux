#!/bin/bash

######################################################################################
# Program Name:  CloudLinux Site Configuration
# Version: 1.0
# Description: Script para criação e configuração de sites no cloudlinux
# Author: Michel Peterson <michel.peterson@l1nuxc0d3.com>
# Date: 08/03/2021
# Changelog:
#           - Adaptação para uso com Ansible
#######################################################################################

########################
###### Parameters ######
########################

export NCURSES_NO_UTF8_ACS=1
SharedDirs="/sharedirs/sharedir0?"
source ./cl_manager.d/dialogs.sh

############################
######### FUNCTIONS ########
############################

function PreCheck {
     Site=$(cat /tmp/site.tmp)
     host www.$Site > /tmp/query.tmp
     host $Site >> /tmp/query.tmp
     chk=$(grep -v NXDOMAIN /tmp/query.tmp | wc -l)
     SiteExist
}

#function RebuildLinks {
#}

function CreateSite {
       AnsibleBanner
       ansible-playbook -i hosts \
	       		-e site_name=$Site \
			-e user_names=$User \
			-e option=1. \
			clm_add_site.yaml
}

function CreateBlog {
       AnsibleBanner
       ansible-playbook -i hosts \
	       		-e site_name=$Site \
			clm_add_blog.yaml
}

function AddUser {
       AnsibleBanner
       ansible-playbook -i hosts \
	       		-e site_name=$Site \
			-e user_names=$User \
			-e option=7. \
			clm_add_user.yaml
}

function LveControl {
	AnsibleBanner
	ansible-playbook -i hosts \
	       		 -e site_name=$Site \
			 -e site_user_id=$Name \
			 -e cpu=$Cpu \
			 -e mem=$Mem \
			 clm_lve_control.yaml
}

function RemoveUser {
       AnsibleBanner
       ansible-playbook -i hosts \
	       		-e site_name=$Site \
			-e user_names=$User \
			clm_remove_user.yaml
}

function EnableMaintenance {
       AnsibleBanner
       ansible-playbook -i hosts \
	       		-e site_name=$Site \
			-e option=5. \
			clm_site_manut.yaml
}

function DisableMaintenance {
       AnsibleBanner
       ansible-playbook -i hosts \
	       		-e site_name=$Site \
			-e option=6. \
			clm_site_manut.yaml
}

function DeleteSite {
	AnsibleBanner
	ansible-playbook -i hosts \
			 -e site_name=$Site \
			 clm_disable_site.yaml
}

function CleanUp {
       rm -f /tmp/user.tmp
       rm -f /tmp/site.tmp
       rm -f /tmp/query.tmp
       rm -f /tmp/resources.tmp
       rm -f /tmp/cpu_limit.tmp
       rm -f /tmp/mem_limit.tmp
}

#############################
######## ACTIONS  ###########
#############################

MainMenu

case $MenuSelect in
"1.")
       SitePrompt
       UserPrompt
       PreCheck
       CreateSite
;;

"2.")
       SitePrompt
       CreateBlog
;;

"3.")
       SitePrompt
       DeleteSite
;;

"4.")
       SitePrompt
       LveResourcesPrompt
       LveControl
;;

"5.")
       SitePrompt
       EnableMaintenance
;;

"6.")
       SitePrompt
       DisableMaintenance
;;

"7.")
       SitePrompt
       UserPrompt
       AddUser
;;

"8.")
       SitePrompt
       UserPrompt
       RemoveUser
;;

"9.")
       UserPrompt
       RebuildLinks
;;

"10.")
       echo -e "Bye :-P\n"
       exit 0
;;
esac

# Clean ALL Temp files...
CleanUp
