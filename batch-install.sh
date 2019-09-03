#!/bin/bash

log () {
    str="$*"
    echo -e "\e[96m> "$str"\e[39m"
}

run () {
    # convert params as single string
    str="$*"

    # log the passed command
    log $str

    # run the command
    $str
}

installDeb () {
    programName=$1
    debUrl=$2
    log "Download and install $programName"
    TEMP_DEB="$(mktemp)" &&
    wget -q -O "$TEMP_DEB" $debUrl &&
    sudo dpkg -i "$TEMP_DEB"
    rm -f "$TEMP_DEB"
}

run mkdir -p ~/git

run sudo apt-get install git

installDeb "Chrome" https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
installDeb "GitKraken" https://release.gitkraken.com/linux/gitkraken-amd64.deb

log "Download and install nvm"
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

wget https://az764295.vo.msecnd.net/stable/f06011ac164ae4dc8e753a3fe7f9549844d15e35/code_1.37.1-1565886362_amd64.deb | dpkg -i

run source ~/.nvm/nvm.sh
run source ~/.profile
run source ~/.bashrc

run nvm install v10.16.3
run nvm use v10.16.3

run npm install -g @angular/cli
run npm install -g ionic
run npm install -g cordova

installDeb ".NET Core" https://packages.microsoft.com/config/ubuntu/19.04/packages-microsoft-prod.deb
run sudo apt-get install apt-transport-https
run sudo apt-get update
run sudo apt-get install dotnet-sdk-2.2=2.2.108-1

installDeb "Visual Studio Code" https://az764295.vo.msecnd.net/stable/f06011ac164ae4dc8e753a3fe7f9549844d15e35/code_1.37.1-1565886362_amd64.deb
log "Installing Visual Studio Code extensions"
run code --install-extension ms-vscode.vscode-typescript-tslint-plugin
run code --install-extension coenraads.bracket-pair-colorizer
run code --install-extension oderwat.indent-rainbow
run code --install-extension johnpapa.angular2
run code --install-extension vscode-icons-team.vscode-icons
run code --install-extension alefragnani.project-manager

log "Increasing the amount of inotify watchers"
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

run sudo apt install -y docker.io
run sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
run sudo chmod +x /usr/local/bin/docker-compose
run sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

