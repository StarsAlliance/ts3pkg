#!/bin/sh

#question list
read -p "Which version of the teamspeak SERVER do you want to install [3.0.0] " ver
read -p "Choose your distro family [DEB/rh] " dfamily
read -p "Do you want to install build packages? [y/N] " dev
read -p "Choose your daemon vendor [dragonzx/mancert] " dvendor
case $dfamily in
	deb|DEB*)  read -p "Choose your distro [debian/ubuntu] " distro ;;
	rh|RH*)  read -p "Choose your distro [centos/fedora/RHEL] " distro ;;
	*) read -p "Choose your distro [debian/ubuntu] " distro ;;
esac
read -p "Choose package architecture [i386/amd64] " tsarch
if [$tsarch -eq "i386"];
then ts86arch="x86"
else ts86arch="x64"
fi
#Start of executing commands
if [[$dev -eq "Y" || $dev -eq "y"]]; 
then apt-get -y install dpkg debconf debhelper lintian fakeroot
fi
cp initd/ts3server-$dvendor.initd /tmp/ts3server
cp control /tmp/control
sed -i -e "s/$ver/"$ver"/" /tmp/control/control-$distro
sed -i -e "s/$tsarch/"$tsarch"/" /tmp/control/control-$distro
cd /usr/src

#Creating package directory and structure
binarydir="usr/bin/mh/ts3server"
docdir="usr/share/doc/ts3server"
initdir="etc/init.d"
mkdir pkg-ts3server-$ver-$tsarch
cd pkg-ts3server-$ver-$tsarch
mkdir DEBIAN
mkdir $initdir
mkdir $binarydir
mkdir $docdir
mv /tmp/ts3server $initdir/ts3server

#Get it from the net
cd /usr/src
wget -i http://dl.4players.de/ts/releases/$ver/teamspeak3-server_linux-$ts86arch-$ver.tar.gz
tar xvfz teamspeak3-server_linux-$ts86arch-$ver.tar.gz
cd teamspeak3-server_linux-$ts86arch-$ver

#Make the package structure from archive
rm -r ts3server_minimal_runscript.sh
rm -r ts3server_startscript.sh
mv LICENSE doc/LICENSE
mv CHANGELOG doc/CHANGELOG
tar cvfz doc/CHANGELOG
mv ~/tsdns/README doc/tsdns/README
mv ~/tsdns/USAGE doc/tsdns/USAGE
mv ~/doc /usr/src/pkg-ts3server-$ver-$tsarch/$docdir
mv ~/ /usr/src/pkg-ts3server-$ver-$tsarch/$binarydir

#Making package
chmod -R 644 DEBIAN/control
cd /usr/src/pkg-ts3server-$ver-$tsarch
md5deep -r usr > DEBIAN/md5sums
cd ..
fakeroot dpkg-deb --build pkg-ts3server-$ver-$tsarch
mv pkg-ts3server-$ver-$tsarch.deb /opt/ts3server-$ver-$tsarch

#Cleanup directory
rm -rf /usr/src/pkg-ts3server-$ver-$tsarch
rm -rf /usr/src/teamspeak3-server_linux-$ts86arch-$ver
rm -rf /usr/src/teamspeak3-server_linux-$ts86arch-$ver.tar.gz
