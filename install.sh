#!/usr/bin/env bash

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White

PRE='--| '

function checkForSSHKeyOrCreate {
	if [ -f "/Users/$USER/.ssh/id_rsa.pub" ]; then
		echo -e "${BGreen}${PRE}You have an ssh key perfect!${Color_Off}"
		return
	else
		echo -e "${BYellow}${PRE}Looks like you don't have an ssh key yet. lets create one.${Color_Off}"
		ssh-keygen -t rsa
		return 
	fi
}

function installApps {
	echo -e "${BYellow}${PRE}Attempting to install virtualbox${Color_Off}"
	if [ "$(which virtualbox)" == "" ] || [ "$FORCE" == "1" ]; then
		echo -e "${BGreen}${PRE}Installing Virtualbox${Color_Off}"
		until $(curl -Lo /tmp/VirtualBox.dmg --silent --fail "http://download.virtualbox.org/virtualbox/5.1.22/VirtualBox-5.1.22-115126-OSX.dmg"); do
			printf '.'
			sleep 5
		done

		if [ ! -f "/tmp/VirtualBox.dmg" ]; then
			echo "${BRed}Error: VirtualBox.dmg was not found, terminating script.${Color_Off}"
			rm -f /tmp/VirtualBox.dmg
			exit 1
		fi

		hdiutil attach /tmp/VirtualBox.dmg
		sudo installer -pkg /Volumes/VirtualBox/VirtualBox.pkg -target /Volumes/Macintosh\ HD
		hdiutil detach /Volumes/VirtualBox
		rm -f /tmp/VirtualBox.dmg
	else
		echo -e "${BGreen}${PRE}Virtualbox is already installed${Color_Off}"
	fi

	echo -e "${BYellow}${PRE}Attempting to install vagrant${Color_Off}"
	if [ "$(which vagrant)" == "" ] || [ "$FORCE" == "1" ]; then
		echo -e "${BGreen}${PRE}Installing Vagrant${Color_Off}"
		until $(curl -Lo /tmp/Vagrant.dmg --silent --fail "https://releases.hashicorp.com/vagrant/1.9.7/vagrant_1.9.7_x86_64.dmg"); do
			printf '.'
			sleep 5
		done

		if [ ! -f "/tmp/Vagrant.dmg" ]; then
			echo "${BRed}Error: Vagrant.dmg was not found, terminating script.${Color_Off}"
			rm -f /tmp/Vagrant.dmg
			exit 1
		fi

		hdiutil attach /tmp/Vagrant.dmg
		sudo installer -pkg /Volumes/Vagrant/Vagrant.pkg -target /Volumes/Macintosh\ HD
		hdiutil detach /Volumes/Vagrant
		rm -f /tmp/Vagrant.dmg
	else
		echo -e "${BGreen}${PRE}Vagrant is already installed${Color_Off}"
	fi
}

function installComposer {
	echo -e "${BYellow}${PRE}Attempting to install composer${Color_Off}"
	if [ -f "/usr/local/bin/composer" ]; then
		echo -e "${BGreen}${PRE}Composer is already installed${Color_Off}"
	else
		if [ "$(which composer)" == "" ]; then
			echo -e "${BGreen}${PRE}Installing composer${Color_Off}"
			curl -sS https://getcomposer.org/installer | php
			mv composer.phar /usr/local/bin/composer
		fi
	fi
}

function installBrew {
	echo -e "${BYellow}${PRE}Attempting to install brew${Color_Off}"
	if [ "$(which brew)" == "" ]; then
		echo -e "${BGreen}${PRE}Installing brew${Color_Off}"
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		brew doctor
		brew update
		brew upgrade
	else
		echo -e "${BGreen}${PRE}Brew is already installed${Color_Off}"
		brew doctor
		brew update
		brew upgrade
	fi

	brew tap homebrew/dupes
	brew tap homebrew/versions
	brew tap homebrew/homebrew-php
	brew unlink php70
	brew install php71-xdebug
}

function installNpm {
	echo -e "${BYellow}${PRE}Attempting to install npm${Color_Off}"
	if [ "$(which npm)" == "" ]; then
		brew install npm
	else
		echo -e "${BGreen}${PRE}Npm is already installed${Color_Off}"	
		brew upgrade npm
	fi

	if [ "$(which npm)" == "" ]; then
		echo "${BYellow}Npm had some trouble installing, trying something.${Color_Off}"
		sudo brew uninstall node
		brew update
		brew upgrade
		brew cleanup
		brew install node
		sudo chown -R $USER /usr/local
		brew link --overwrite node
		sudo brew postinstall node
	fi

	if [ "$(which npm)" == "" ]; then
		echo "${BRed}Error: Could not install npm, terminating script.${Color_Off}"
		exit 1
	fi

	echo -e "${BYellow}${PRE}Attempting to install bower${Color_Off}"
	if [ "$(which bower)" == "" ]; then
		sudo npm install -g bower
	else
		echo -e "${BGreen}${PRE}Bower is already installed${Color_Off}"
		npm upgrade bower
	fi

	echo -e "${BYellow}${PRE}Attempting to install gulp${Color_Off}"
	if [ "$(which gulp)" == "" ]; then
		npm install -g gulp
	else
		echo -e "${BGreen}${PRE}Gulp is already installed${Color_Off}"
		npm upgrade gulp
		npm i -g npm
	fi
}

function createAndMountSparseBundle {
	if [[ -z "${STACKNAME}" ]]; then
		echo -e "${BIYellow}Dev Stack name? ('Stack' will be appended, ie. DevStack)${Color_Off}"
		read stack
		export STACKNAME="${stack}"
	else
		echo -e "${BGreen}${PRE}Stack name pre-defined in config ${STACKNAME}${Color_Off}"
	fi
	
	if [ ! -d "/Volumes/${STACKNAME}Stack" ]; then
		echo -e "${White}${PRE}Creating and mounting sparsebundle${Color_Off}"
		if [[ ! -z "${STACKPASS}" ]]; then
			echo -n "${STACKPASS}" | hdiutil create -size 3g -fs 'Case-sensitive Journaled HFS+' -volname "${STACKNAME}Stack" -encryption AES-128 "${STACKNAME}Stack.sparsebundle" -stdinpass
		else
			hdiutil create -size 3g -fs 'Case-sensitive Journaled HFS+' -volname "${STACKNAME}Stack" -encryption AES-128 "${STACKNAME}Stack.sparsebundle"
		fi
	fi

	hdiutil attach -owners on "${STACKNAME}Stack.sparsebundle"
}

function enterStack {
	if [ ! -d "/Volumes/${STACKNAME}Stack/${STACKNAME}/" ]; then
		echo "${BRed}Error: /Volumes/${STACKNAME}Stack/${STACKNAME}/ not found.${Color_Off}"
		exit 1
	fi
	cd "/Volumes/${STACKNAME}Stack/${STACKNAME}/"
}

function getDevDomain {
	if [[ -z "${DOMAIN}" ]]; then
		echo -e "${BIYellow}Development domain name? (ex. app.dev)${Color_Off}"
		read domain
		export DOMAIN="${domain}"
	else
		echo -e "${BGreen}${PRE}Dmomain pre-defined in config ${DOMAIN}${Color_Off}"
	fi
}

function getDevIP {
	if [[ -z "${DEVIP}" ]]; then
		echo -e "${BIYellow}Development local IP? (default is $1)${Color_Off}"
		read devip
		if [[ ! -z "${devip}" ]]; then
			export DEVIP="${devip}"
		else
			export DEVIP="$1"
		fi
	else
		echo -e "${BGreen}${PRE}Development IP pre-defined in config ${DEVIP}${Color_Off}"
	fi
}

function getDevRepo {
	if [[ -z "${REPO}" ]]; then
		echo -e "${BIYellow}${1}${Color_Off}"
		read repo
		if [[ -z "${repo}" ]]; then
			if [[ ! -z "$2" ]]; then
				repo="${2}"
			else
				echo "${BRed}Error: Code repository not provided.${Color_Off}"
				exit 1
			fi
		fi
		export REPO="${repo}"
	else
		echo -e "${BGreen}${PRE}Code repository pre-defined in config ${REPO}${Color_Off}"
	fi

	if [[ -z "${BRANCH}" ]]; then
		echo -e "${BIYellow}Code repository branch? (ex. master)${Color_Off}"
		read branch
		if [ "${branch}" == "" ]; then
			export BRANCH="master"
		else
			export BRANCH="${branch}"
		fi
	else
		echo -e "${BGreen}${PRE}Repository branch pre-defined in config ${BRANCH}${Color_Off}"
	fi
}

function updateHostsFile {
	domaincheck=$(grep '${DOMAIN}' /etc/hosts | awk '{print $1}')
	if [ ! $domaincheck ]; then
		echo -e "${BGreen}${PRE}Adding domain to /etc/hosts${Color_Off}"
		sudo -- sh -c "echo '${DEVIP} ${DOMAIN}' >> /etc/hosts"
	fi
}

function cloneRepository {
	echo -e "${BGreen}${PRE}Cloning code repository${Color_Off}"
	if [ -d "/Volumes/${STACKNAME}Stack" ]; then
		cd "/Volumes/${STACKNAME}Stack"
		git clone $1 $STACKNAME --quiet --branch=$2
	else
		exit
	fi
}

function setupHomestead {
	getDevRepo "Code repository path? (ex. https://someuser@bitbucket.org/someteam/somerepo.git)"
	cloneRepository $REPO $BRANCH

	cp "${SCRIPTPATH}/.env.install" "/Volumes/${STACKNAME}Stack/${STACKNAME}/.env"
	enterStack

	mkdir bootstrap/cache
	mkdir storage
	mkdir storage/framework
	mkdir storage/framework/cache
	mkdir storage/framework/sessions
	mkdir storage/framework/views
	mkdir vendor

	chmod -R 777 bootstrap/cache
	chmod -R 777 vendor storage

	if [[ -z "${GITHUBTOKEN}" ]]; then
		echo -e "${BIYellow}GitHub Personal Access Token?${Color_Off}"
		echo -e "${BIWhite}https://github.com/settings/tokens${Color_Off}"
		read ghtoken
		export GITHUBTOKEN=$ghtoken
	else
		echo -e "${BGreen}${PRE}Github personal access token pre-defined in config ${GITHUBTOKEN}${Color_Off}"
	fi

	if [[ ! -z "${GITHUBTOKEN}" ]]; then
		composer config github-oauth.github.com $GITHUBTOKEN
	else
		echo "${BRed}Error: No github personal access token provided, terminating script.${Color_Off}"
		exit 1
	fi

	# if [ -f "Vagrantfile" ]; then
	# 	echo -e "${BIYellow}Vagrantfile exists, remove it? (Y|n)${Color_Off}"
	# 	read desire
	# 	export DESIRE="${desire}"
	# 	if [ "${desire}" == "Y" ] || [ "${desire}" == "y" ] || [ "${desire}" == "yes" ] || [ "${desire}" == "" ]; then
	# 		rm Vagrantfile
	# 	fi
	# fi

	echo -e "${BGreen}${PRE}Updating composer.${Color_Off}"
	composer selfupdate
	echo -e "${BGreen}${PRE}Installing composer files.${Color_Off}"
	composer install
	echo -e "${BGreen}${PRE}Installing homestead files.${Color_Off}"
	composer require laravel/homestead --dev

	if [ ! -f "vendor/bin/homestead" ]; then
		echo "${BRed}Error: Homestead could not be installed, terminating script.${Color_Off}"
		exit 1
	fi

	getDevDomain

	echo -e "${BGreen}${PRE}Creating homestead for ${STACKNAME} on ${DOMAIN}.${Color_Off}"
	php vendor/bin/homestead make --name=$STACKNAME --hostname=$DOMAIN
	
	LC=$(tr '[:lower:]' '[:upper:]' <<< "$STACKNAME")

	getDevIP "192.168.10.10"
	
	echo -e "${BGreen}${PRE}Modifying code path to be accurate${Color_off}"
	cat ./Homestead.yaml | sed "s/\/Code//" > ./Homestead.temp.yaml && mv ./Homestead.temp.yaml ./Homestead.yaml

	echo -e "${BGreen}${PRE}Modifying hostname in Homestead.yaml${Color_Off}"
	cat ./Homestead.yaml | sed "s/hostname: ${LC}/hostname: ${DOMAIN}/" > ./Homestead.temp.yaml && mv ./Homestead.temp.yaml ./Homestead.yaml

	if [[ ! -z "${DEVIP}" ]]; then
		echo -e "${BGreen}${PRE}Modifying ip in Homestead.yaml${Color_Off}"
		cat ./Homestead.yaml | sed "s/ip: \"192.168.10.10\"/ip: \"${DEVIP}\"/" > ./Homestead.temp.yaml && mv ./Homestead.temp.yaml ./Homestead.yaml
	fi

	updateHostsFile

	echo -e "${BGreen}${PRE}Adding environment file and generating key.${Color_Off}"
	
	if [ ! -f "/Volumes/${STACKNAME}Stack/${STACKNAME}/.env" ]; then
		cp .env.example .env
	fi

	php artisan key:generate

	echo -e "${BGreen}${PRE}Installing npm requirements.${Color_Off}"
	npm install

	if [ -f "bower.json" ]; then
		echo -e "${BGreen}${PRE}Installing bower requirements.${Color_Off}"
		sudo bower install --allow-root
	fi

	echo -e "${BGreen}${PRE}Running gulp script.${Color_Off}"
	gulp

	if [ ! -f "Vagrantfile" ]; then
		echo "${BRed}Error: Vagrantfile not found, terminating script.${Color_Off}"
		exit 1
	fi

	vagrant global-status --prune
	vagrant up

	php artisan migrate
	php artisan db:seed

	echo -e "${BGreen}Done!${Color_Off}"
	exit 1
}

function loadConfig {
	source ".env.conf"
}

function preSetup {
	loadConfig
	checkForSSHKeyOrCreate
	echo -e "${BIGreen}${PRE}Starting Installation...${Color_Off}"
	installBrew
	export PATH="/usr/local/bin:$PATH"
	installNpm
	installApps
	installComposer
	createAndMountSparseBundle
}

export SCRIPTPATH=$( cd "$(dirname "$0")" ; pwd -P )
# echo -e "${SCRIPTPATH}"

preSetup
setupHomestead

exit 1