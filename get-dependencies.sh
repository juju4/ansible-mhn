#!/bin/sh
## one script to be used by travis, jenkins, packer...

umask 022

if [ $# != 0 ]; then
rolesdir=$1
else
rolesdir=$(dirname $0)/..
fi

[ ! -d $rolesdir/juju4.maxmind ] && git clone https://github.com/juju4/ansible-maxmind $rolesdir/juju4.maxmind
[ ! -d $rolesdir/juju4.redhat-epel ] && git clone https://github.com/juju4/ansible-redhat-epel $rolesdir/juju4.redhat-epel
[ ! -d $rolesdir/juju4.golang ] && git clone https://github.com/juju4/ansible-golang $rolesdir/juju4.golang

#[ ! -d $rolesdir/geerlingguy.java ] && git clone https://github.com/geerlingguy/ansible-role-java.git $rolesdir/geerlingguy.java
[ ! -d $rolesdir/geerlingguy.java ] && git clone https://github.com/juju4/ansible-role-java.git $rolesdir/geerlingguy.java
## getting v5 roles
[ ! -d $rolesdir/geerlingguy.elasticsearch ] && git clone https://github.com/juju4/ansible-role-elasticsearch.git $rolesdir/geerlingguy.elasticsearch
[ ! -d $rolesdir/geerlingguy.logstash ] && git clone https://github.com/juju4/ansible-role-logstash.git $rolesdir/geerlingguy.logstash
[ ! -d $rolesdir/geerlingguy.kibana ] && git clone https://github.com/juju4/ansible-role-kibana.git $rolesdir/geerlingguy.kibana

## galaxy naming: kitchen fails to transfer symlink folder
#[ ! -e $rolesdir/juju4.mhn ] && ln -s ansible-mhn $rolesdir/juju4.mhn
[ ! -e $rolesdir/juju4.mhn ] && cp -R $rolesdir/ansible-mhn $rolesdir/juju4.mhn

## don't stop build on this script return code
true

