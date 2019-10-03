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

log "Installing Grub Customizer"
run sudo add-apt-repository ppa:danielrichter2007/grub-customizer
run sudo apt-get update
run sudo apt-get install grub-customizer

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

log "Installing OpenJDK 8"
run sudo apt install openjdk-8-jdk
run echo 'export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")' >> ~/.profile
run sudo update-java-alternatives --set java-1.8.0-openjdk-amd64
run source ~/.profile

log "Installing Android SDK"
run mkdir -p ~/Android/Sdk
run wget -O ~/Android/Sdk/android-sdk.zip "https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip"
run unzip ~/Android/Sdk/android-sdk.zip -d ~/Android/Sdk
run rm ~/Android/Sdk/android-sdk.zip
run mv ~/Android/Sdk/tools/emulator ~/Android/Sdk/tools/emulator2
run echo 'export ANDROID_HOME=$HOME/Android/Sdk' >> ~/.profile
run echo 'export ANDROID_SDK_ROOT=$ANDROID_HOME' >> ~/.profile
run echo 'export PATH=$PATH:$ANDROID_HOME/tools' >> ~/.profile
run echo 'export PATH=$PATH:$ANDROID_HOME/tools/bin' >> ~/.profile
run source ~/.profile
run touch ~/.android/repositories.cfg

run sdkmanager --install "platform-tools"
run sdkmanager --install "build-tools;29.0.2"
run sdkmanager --install "extras;google;google_play_services"
run sdkmanager --install "system-images;android-28;google_apis_playstore;x86_64"

# create android VMs android-small and @android-large
run avdmanager create avd -n "android-small" -k "system-images;android-28;google_apis_playstore;x86_64"


log "Installing Android SDK emulator"
run sdkmanager --install emulator
run echo 'export PATH=$PATH:$ANDROID_HOME/emulator' >> ~/.profile
run source ~/.profile
