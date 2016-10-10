#!/bin/sh
## one script to be used by travis, jenkins, packer...

umask 022

if [ $# != 0 ]; then
rolesdir=$1
else
rolesdir=$(dirname $0)/..
fi

[ ! -d $rolesdir/maxmind ] && git clone https://github.com/juju4/ansible-maxmind $rolesdir/maxmind
[ ! -d $rolesdir/redhat-epel ] && git clone https://github.com/juju4/ansible-redhat-epel $rolesdir/redhat-epel

