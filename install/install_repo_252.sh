#!/bin/sh
CURL=/usr/local/bin/curl
ARCH=`uname -m`

if [ $ARCH == "arm" ]
then
	ARCH="armv7"
elif  [ $ARCH == "arm64" ]
then
	ARCH="aarch64"
fi

KEY=https://packages.mced.tech/install/poudriere.cert
REPO=http://packages.mced.tech/packages/freebsd_12-2_${ARCH}-ng_ports_252
KEY_LOC=/usr/local/etc/ssl/wireguard.crt
PATCH_LOC=https://packages.mced.tech/install/25_unofficial_packages_list.patch
$CURL -s $KEY -o $KEY_LOC
$CURL -s $PATCH_LOC -o /tmp/pkg.patch
patch -p0 --ignore-whitespace < /tmp/pkg.patch
REPO_OUTPUT="FreeBSD: { enabled: no } 
mced: { url: \"$REPO\", 
mirror_type: \"http\" ,
signature_type: \"pubkey\",
pubkey: \"$KEY_LOC\",
enabled: yes}"
echo $REPO_OUTPUT > /usr/local/etc/pkg/repos/00_WireGuard.conf
pkg update

