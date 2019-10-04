#!/bin/bash

log () {
    str="$*"
    echo "\n######   $str   #####\n"
}

installLog () {
    str="$*"
    log "Download and install $str"
}

installDeb () {
    programName=$1
    debUrl=$2
    installLog "$programName"
    TEMP_DEB="$(mktemp)" &&
    wget -O "$TEMP_DEB" $debUrl &&
    sudo dpkg -i "$TEMP_DEB"
    rm -f "$TEMP_DEB"
}

log "Update apt-get repositories"
sudo apt update

installLog "Git"
mkdir -p ~/git
sudo apt-get install git -s

installDeb "Chrome" https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
installDeb "GitKraken" https://release.gitkraken.com/linux/gitkraken-amd64.deb

log "Grub Customizer"
sudo add-apt-repository ppa:danielrichter2007/grub-customizer -y
sudo apt-get update
sudo apt-get install grub-customizer -s

installLog "nvm"
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

. ~/.nvm/nvm.sh
. ~/.profile
. ~/.bashrc

nvm install v10.16.3
nvm use v10.16.3

installLog "Angular"
npm install -g @angular/cli

installLog "Ionic"
npm install -g ionic

installLog "Cordova"
npm install -g cordova

installDeb ".NET Core" https://packages.microsoft.com/config/ubuntu/19.04/packages-microsoft-prod.deb
sudo apt-get install apt-transport-https -s
sudo apt-get update
sudo apt-get install dotnet-sdk-2.2=2.2.108-1 -s

installDeb "Visual Studio Code" https://az764295.vo.msecnd.net/stable/f06011ac164ae4dc8e753a3fe7f9549844d15e35/code_1.37.1-1565886362_amd64.deb

installLog "Visual Studio Code extensions"
code --install-extension ms-vscode.vscode-typescript-tslint-plugin
code --install-extension coenraads.bracket-pair-colorizer
code --install-extension oderwat.indent-rainbow
code --install-extension johnpapa.angular2
code --install-extension vscode-icons-team.vscode-icons
code --install-extension alefragnani.project-manager

log "Increase the amount of inotify watchers"
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

installLog "Docker and Docker Compose"
sudo apt install -y docker.io -s
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

installLog "OpenJDK 8"
sudo apt install openjdk-8-jdk -s
echo 'export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")' >> ~/.profile
sudo update-java-alternatives --set java-1.8.0-openjdk-amd64
. ~/.profile

installLog "Android SDK"
mkdir -p ~/Android/Sdk
wget -O ~/Android/Sdk/android-sdk.zip "https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip"
unzip -o -qq ~/Android/Sdk/android-sdk.zip -d ~/Android/Sdk
rm ~/Android/Sdk/android-sdk.zip
mv ~/Android/Sdk/tools/emulator ~/Android/Sdk/tools/emulator2
echo 'export ANDROID_HOME=$HOME/Android/Sdk' >> ~/.profile
echo 'export ANDROID_SDK_ROOT=$ANDROID_HOME' >> ~/.profile
echo 'export PATH=$PATH:$ANDROID_HOME/tools' >> ~/.profile
echo 'export PATH=$PATH:$ANDROID_HOME/tools/bin' >> ~/.profile
. ~/.profile
touch ~/.android/repositories.cfg

installLog "Android SDK packages"
sdkmanager --install "platform-tools"
sdkmanager --install "build-tools;29.0.2"
sdkmanager --install "extras;google;google_play_services"
sdkmanager --install "system-images;android-28;google_apis_playstore;x86_64"

log "Android SDK emulator"
sdkmanager --install emulator
echo 'export PATH=$PATH:$ANDROID_HOME/emulator' >> ~/.profile
. ~/.profile

# create android VMs android-small and @android-large
log "Create Android virtual devices"
avdmanager create avd -n "android-small" -k "system-images;android-28;google_apis_playstore;x86_64"
avdmanager create avd -n "android-small" -k "system-images;android-28;google_apis_playstore;x86_64" -d "Nexus S" -c 512
