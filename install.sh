#!/bin/bash

set -ex

mkdir -p /devkit

JAVA_VERSION=17
GRAALVM_VERSION=21.3.0
MAVEN_VERSION=3.8.4
GRADLE_VERSION=7.3.3

# docker
sudo snap remove docker && \
	sudo snap install docker && \
	sudo adduser $USER docker && \
	snap disable docker && \
	snap enable docker && \
	docker --version && \
	docker ps -a

# java
wget -qO- https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAALVM_VERSION}/graalvm-ce-java${JAVA_VERSION}-linux-amd64-${GRAALVM_VERSION}.tar.gz | sudo tar -xvz -C /devkit && \
	sudo ln -sf /devkit/graalvm-ce-java${JAVA_VERSION}-${GRAALVM_VERSION}/bin/* /usr/bin/ && \
	gu install native-image && \
	java --version

# maven
wget -qO- https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz | sudo tar -xvz -C /devkit && \
	sudo ln -sf /devkit/apache-maven-${MAVEN_VERSION}/bin/mvn /usr/bin/ && \
	mvn --version

# gradle
wget -qO- https://downloads.gradle-dn.com/distributions/gradle-${GRADLE_VERSION}-bin.zip | busybox unzip - -d /devkit && \
	sudo ln -sf /devkit/gradle-${GRADLE_VERSION}/bin/gradle /usr/bin/ && \
	sudo chmod +x /devkit/gradle-${GRADLE_VERSION}/bin/gradle && \
	gradle --version

# google chrome
wget -qO- https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb | sudo apt install

# git
sudo apt install git-all -y
	
# intellij idea ultimate
sudo snap remove intellij-idea-ultimate && \
	sudo snap install intellij-idea-ultimate --classic && \
	cp /snap/intellij-idea-ultimate/*/bin/idea.sh /snap/intellij-idea-ultimate/*/bin/idea && \
	ln -sf /snap/intellij-idea-ultimate/*/bin/idea /usr/bin/

# spotify
sudo snap remove spotify && \
	sudo snap install spotify
	
# telegram
sudo snap remove telegram-desktop && \
	sudo snap install telegram-desktop

# shortcuts
gsettings set org.gnome.shell favorite-apps "['org.gnome.Terminal.desktop', 'google-chrome.desktop', 'intellij-idea-ultimate_intellij-idea-ultimate.desktop', 'telegram-desktop_telegram-desktop.desktop', 'spotify_spotify.desktop', 'org.gnome.Nautilus.desktop']"
