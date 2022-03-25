#!/bin/bash
set -e

# google chrome
if [ "$(dpkg -l | grep google-chrome)" = "" ]; then
	echo "Google Chrome Installation" && \
	wget -O /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
	sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb && \
	rm -f /tmp/google-chrome-stable_current_amd64.deb
fi

DEVKIT_HOME=~/DevKit
JAVA_VERSION=18
FULL_JAVA_VERSION=18
GRAALVM_JAVA_VERSION=17
GRAALVM_VERSION=22.0.0.2
MAVEN_VERSION=3.8.5
GRADLE_VERSION=7.4.1

mkdir -p $DEVKIT_HOME
sudo rm -rf $DEVKIT_HOME/*

# graalvm cc & prerequisites
echo "GraalVM Installation" && \
sudo apt-get install build-essential libz-dev zlib1g-dev -y && \
wget -qO- https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAALVM_VERSION}/graalvm-ce-java${GRAALVM_JAVA_VERSION}-linux-amd64-${GRAALVM_VERSION}.tar.gz | sudo tar -xvz -C ${DEVKIT_HOME} && \
sudo ln -sf ${DEVKIT_HOME}/graalvm-ce-java${GRAALVM_JAVA_VERSION}-${GRAALVM_VERSION}/bin/* /usr/bin/ && \
sudo gu install native-image && \
sudo ln -sf ${DEVKIT_HOME}/graalvm-ce-java${GRAALVM_JAVA_VERSION}-${GRAALVM_VERSION}/bin/* /usr/bin/ && \
java --version

# oracle jdk
echo "OracleJDK Installation" && \
wget -qO- https://download.oracle.com/java/${JAVA_VERSION}/latest/jdk-${JAVA_VERSION}_linux-x64_bin.tar.gz | sudo tar -xvz -C ${DEVKIT_HOME} && \
sudo ln -sf ${DEVKIT_HOME}/jdk-${FULL_JAVA_VERSION}/bin/* /usr/bin/ && \
java --version

# maven
echo "Maven Installation" && \
wget -qO- https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz | sudo tar -xvz -C ${DEVKIT_HOME} && \
sudo ln -sf ${DEVKIT_HOME}/apache-maven-${MAVEN_VERSION}/bin/mvn /usr/bin/ && \
mvn --version

# gradle
echo "Gradle Installation" && \
wget -q -O /tmp/gradle-${GRADLE_VERSION}-bin.zip https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
unzip /tmp/gradle-${GRADLE_VERSION}-bin.zip -d ${DEVKIT_HOME} && \
rm /tmp/gradle-${GRADLE_VERSION}-bin.zip && \
sudo ln -sf ${DEVKIT_HOME}/gradle-${GRADLE_VERSION}/bin/gradle /usr/bin/ && \
gradle --version

# idea
if [ "$(snap list | grep intellij-idea-ultimate)" = "" ]; then
	echo "IntelliJ IDEA Installation" && \
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

# docker
if [ "$(snap list | grep docker)" = "" ]; then
	echo "Docker Installation" && \
	sudo snap install docker && \
	sudo addgroup --system docker && \
	sudo adduser $USER docker && \
	sudo snap disable docker && \
	sudo snap enable docker && \
	docker --version
fi

# curl
sudo apt install curl -y

# git
sudo apt install git -y

# shortcuts
gsettings set org.gnome.shell favorite-apps "['org.gnome.Terminal.desktop', 'google-chrome.desktop', 'intellij-idea-ultimate_intellij-idea-ultimate.desktop', 'telegram-desktop_telegram-desktop.desktop', 'spotify_spotify.desktop', 'acestreamplayer_acestreamplayer.desktop', 'org.gnome.Nautilus.desktop']"

# finilize with global upgrade
sudo apt update -y && sudo apt upgrade -y && sudo snap refresh

echo "Done!"
