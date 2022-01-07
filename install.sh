#!/bin/bash

set -e

mkdir -p /devkit

JAVA_VERSION=17
GRAALVM_VERSION=21.3.0
MAVEN_VERSION=3.8.4
GRADLE_VERSION=7.3.3

# docker
if [ "$(snap list | grep docker)" = "" ]; then
	echo "Docker Installation" && \
		sudo snap install docker && \
		sudo adduser $USER docker && \
		sudo snap disable docker && \
		sudo snap enable docker && \
		docker --version && \
		docker ps -a
fi

# graalvm cc & prerequisites
if [ ! -f "/usr/bin/java" ]; then
	echo "GraalVM Installation" && \
		sudo apt-get install build-essential libz-dev zlib1g-dev -y && \
		wget -qO- https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAALVM_VERSION}/graalvm-ce-java${JAVA_VERSION}-linux-amd64-${GRAALVM_VERSION}.tar.gz | sudo tar -xvz -C /devkit && \
		sudo ln -sf /devkit/graalvm-ce-java${JAVA_VERSION}-${GRAALVM_VERSION}/bin/* /usr/bin/ && \
		gu install native-image && \
		java --version
fi

# maven
if [ ! -f "/usr/bin/mvn" ]; then
	echo "Maven Installation" && \
    		wget -qO- https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz | sudo tar -xvz -C /devkit && \
		sudo ln -sf /devkit/apache-maven-${MAVEN_VERSION}/bin/mvn /usr/bin/ && \
		mvn --version
fi

# gradle
if [ ! -f "/usr/bin/gradle" ]; then
	echo "Gradle Installation" && \
		wget -qO- https://downloads.gradle-dn.com/distributions/gradle-${GRADLE_VERSION}-bin.zip | busybox unzip - -d /devkit && \
		sudo ln -sf /devkit/gradle-${GRADLE_VERSION}/bin/gradle /usr/bin/ && \
		sudo chmod +x /devkit/gradle-${GRADLE_VERSION}/bin/gradle && \
		gradle --version
fi

# google chrome
wget -qO- https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb | sudo apt install

# git
sudo apt install git-all -y

# intellij idea ultimate
if [ "$(snap list | grep intellij-idea-ultimate)" = "" ]; then
	echo "IDEA Installation" && \
		sudo snap install intellij-idea-ultimate --classic && \
		sudo ln -sf /snap/intellij-idea-ultimate/current/bin/idea.sh /usr/bin/ && \
		sudo mv /usr/bin/idea.sh /usr/bin/idea
fi

# spotify
if [ "$(snap list | grep spotify)" = "" ]; then
	echo "Spotify Installation" && \
		sudo snap install spotify
fi

# acestream
if [ "$(snap list | grep acestreamplayer)" = "" ]; then
	echo "Acestream Installation" && \
		sudo snap install acestreamplayer
fi

# telegram
if [ "$(snap list | grep telegram-desktop)" = "" ]; then
	echo "Telegram Installation" && \
		sudo snap install telegram-desktop
fi

# shortcuts
gsettings set org.gnome.shell favorite-apps "['org.gnome.Terminal.desktop', 'google-chrome.desktop', 'intellij-idea-ultimate_intellij-idea-ultimate.desktop', 'telegram-desktop_telegram-desktop.desktop', 'spotify_spotify.desktop', 'acestreamplayer_acestreamplayer.desktop', 'org.gnome.Nautilus.desktop']"

# finilize with global upgrade
sudo apt update -y && sudo apt upgrade -y && sudo snap refresh
