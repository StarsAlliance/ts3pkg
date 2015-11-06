#!/bin/sh

#question list
read -p 'Which version of the teamspeak SERVER do you want to install [3.0.0] ' ver
read -p 'Choose your distro family [DEB/rh] ' dfamily
read -p 'Do you want to install build packages? [y/N] ' dev
read -p 'Choose your daemon vendor [dragonzx/mancert] ' dvendor
case $dfamily in
	deb|DEB*)  read -p 'Choose your distro [debian/ubuntu] ' distro ;;
	rh|RH*)  read -p 'Choose your distro [centos/fedora/RHEL] ' distro ;;
	*) read -p 'Choose your distro [debian/ubuntu] ' distro ;;
esac
read -p 'Choose package architecture [i386/amd64] ' tsarch
if [$tsarch="i386"]; then ts86arch='x86'; else ts86arch='x64';

#Start of executing commands
if [[$dev="Y" || $dev="y";]]; then apt-get -y install dpkg debconf debhelper lintian fakeroot
fi
cp initd/ts3server-$dvendor.initd /usr/src/ts3server
cd /usr/src
#Creating package directory and structure
binarydir ='usr/bin/mh/ts3server'
mkdir 'pkg-ts3server-'$ver'-'$tsarch''
cd 'pkg-ts3server-'$ver'-'$tsarch''
mkdir DEBIAN
mkdir etc/init.d
mkdir $binarydir
mkdir usr/doc/ts3server
#Get it from the net
wget -i 'http://dl.4players.de/ts/releases/'$ver'/teamspeak3-server_linux-'$ts86arch'-'$ver'.tar.gz'
tar xvfz 'teamspeak3-server_linux-'$ts86arch'-'$ver'.tar.gz'
cd 'teamspeak3-server_linux-'$ts86arch'-'$ver'.tar.gz'
