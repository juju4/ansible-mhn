[![Build Status - Master](https://travis-ci.org/juju4/ansible-mhn.svg?branch=master)](https://travis-ci.org/juju4/ansible-mhn)
[![Build Status - Devel](https://travis-ci.org/juju4/ansible-mhn.svg?branch=devel)](https://travis-ci.org/juju4/ansible-mhn/branches)
# MHN Server ansible role

Mostly a conversion of the shell scripts of https://github.com/threatstream/mhn to ansible config

* https://github.com/threatstream/mhn/
* http://www.505forensics.com/honeypot-data-part-1-mongodb-elasticsearch-mhn/

As stated in MHN FAQ, you need proper updates and hardening for those systems. (other roles)

## Requirements & Dependencies

### Ansible
It was tested on the following versions:
 * 2.0
 * 2.1
 * 2.2
 * 2.5

### Operating systems

Tested with Ubuntu 14.04, 16.04 and CentOS 7
Ubuntu 12.04 is supported in official MHN scripts but with libev compiled from source (pyev require 4.15+, precise only has 4.11). In the same way, Centos6 requires source install of libev and python 2.7. Both are not included in this role currently.
Initial testing for Ubuntu 18.04.

## Example Playbook

Just include this role in your list.
For example

```
- hosts: mhnserver
  roles:
      - juju4.maxmind
      - juju4.mhn
- hosts: mhnclient
  roles:
    - { role: juju4.mhnclient, mhnclient_dionaea: true, mhnclient_glastopf: true, mhnclient_wordpot: true }
```

If you use kippo, after first execution, you must change ssh port in your inventory file (manual inventory or vagrant .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory) or Vagrantfile (config.ssh.port) else you will have no connection. Eventually, you can override it from ansible command line (-e).

May need to add a Maxmind dependency for honeymap (configured to look into /var/maxmind)

It is recommended to reboot system after the ansible playbook as updates probably includes kernel one and to ensure everything is fine. Playbook can do it but default variable is noreboot true.


## Example Vagrantfile

Example to use with vagrant on virtualbox joined. need corresponding site.yml (previous section).
Deployment tested mostly on LXD, Virtualbox and Digital Ocean.

## Variables

Check defaults/main.yml for a full list.

Most important are
* MHN_EMAIL: login to web interface
* MHN_PASS: password to web interface
* server_url: need to be set to your server IP
* httpsport: to be define if you want the webserver (nginx) to be configured https only on this port. server_url need to reflect that and if you use a self-signed certificate, curl_arg too.

## Troubleshooting & Known issues

## Known Issues

* for some reason, honeymap doesn't work on https but is ok on http
* deploy scripts for suricata/bro where not converted as there are already ansible playbooks for that and their usage is much larger than honeynet, so reuse them. snort has been converted as it is threatstream repository's one.
* splunk, arcsight and elk part are work in progress and not fully done/tested. server deployment should be separated. Integration part needs to be build.
* when doing vagrant up <box> or provision, it does all box up... if you manually call ansible with appropriate limit, it works well
$ Vagrant up node3
[create node3]
[provision all systems which are up]
$ ansible-playbook -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory site.yml --limit node3
* DigitalOcean: 512MB box by default has no swap, add it or face Out of Memory killing especially on master server
* idempotency: failing
* mongodb can easily grow a lot depending on traffic.
watch size of /var/lib/mongodb
eventually delete content and reclaim space
```
# mongod --repair -f /etc/mongod.conf -vvvv
```
Note that "repairDatabase requires free disk space equal to the size of your current data set plus 2 gigabytes."
https://docs.mongodb.com/manual/reference/command/repairDatabase/#using-repairdatabase-to-reclaim-disk-space
* Redhat/Centos support is under review. not working currently.
* Centos "You (root) are not allowed to access to (crontab) because of pam configuration."
check root password is not expired (/var/log/secure).
It is the case on lxc default images. A task file has been added which set a random password. Better to use ssh key anyway.
* nginx frontend on debian/ubuntu
```
$ cat /var/log/nginx/error.log
[emerg] 28420#0: unknown directive "uwsgi_param" in /etc/nginx/uwsgi_params:1
```
mhn requires uwsgi which is not available in nginx-naxsi or nginx-light

* uwsgi not starting
```
$ cat /var/log/mhn/mhn-uwsgi.log
[...]
--- no python application found, check your startup logs for errors ---
```
chek permissions and user used to run uwsgi: normally _mhn here/

* cron issue inside travis+docker
https://github.com/ansible/ansible-modules-core/pull/4777
= pending release

* geoloc module FATAL error
check following commands:
```
$ cat /opt/hpfeeds/geoloc.json
$ mongo hpfeeds -eval "db.auth_key.find({identifier: 'geoloc'}).pretty();"
```
https://groups.google.com/forum/#!topic/modern-honey-network/FKQRr_ZHVfA
It happens also on mhnclient+mhn test config on Ubuntu trusty only for unknown reason.

* Centos7: 502 Bad gateway between nginx and uwsgi.
when switching uwsgi to http socket, web interface is accessible directly through uwsgi but still 502 on nginx.
with curl 7.40+:
```
$ curl -v --unix-socket /tmp/uwsgi.sock http://localhost
* Rebuilt URL to: http://localhost/
*   Trying /tmp/uwsgi.sock...
* Connected to localhost (/tmp/uwsgi.sock) port 80 (#0)
> GET / HTTP/1.1
> Host: localhost
> User-Agent: curl/7.51.0
> Accept: */*
> 
* Curl_http_done: called premature == 0
* Empty reply from server
* Connection #0 to host localhost left intact
curl: (52) Empty reply from server
```
using network access, service is accessible but nginx is still returning 502.
pending.

* Travis/trusty: uptstream mongodb packages fail to install but working fine in local kitchen.
pending



## FAQ

Check
https://github.com/threatstream/mhn/wiki/MHN-Troubleshooting-Guide

* Current ELK setup need a local logstash to read local log file on MHN server.
Elasticsearch can be remote.
You can use geerlingguy.logstash role to set it up

* Alternatives
http://dtag-dev-sec.github.io/mediator/feature/2016/03/11/t-pot-16.03.html

* Ubuntu bionic not supported - cursor issue.
bionic has mongodb 3.6 in official repository and mongodb 3.4 community repository is not available.

## Continuous integration

This role has a travis basic test (for github), more advanced with kitchen and also a Vagrantfile (test/vagrant).
Default kitchen config (.kitchen.yml) is lxd-based, while (.kitchen.vagrant.yml) is vagrant/virtualbox based.

Once you ensured all necessary roles are present, You can test with:
```
$ cd /path/to/roles/juju4.mhn
$ kitchen verify
$ kitchen login
$ KITCHEN_YAML=".kitchen.vagrant.yml" kitchen verify
```
or
```
$ cd /path/to/roles/juju4.mhn/test/vagrant
$ vagrant up
$ vagrant ssh
```

Role has also a packer config which allows to create image for virtualbox, vmware, eventually digitalocean, lxc and others.
When building it, it's advise to do it outside of roles directory as all the directory is upload to the box during building 
and it's currently not possible to exclude packer directory from it (https://github.com/mitchellh/packer/issues/1811)
```
$ cd /path/to/packer-build
$ cp -Rd /path/to/mhn/packer .
## update packer-*.json with your current absolute ansible role path for the main role
## you can add additional role dependencies inside setup-roles.sh
$ cd packer
$ packer build packer-*.json
$ packer build -only=virtualbox-iso packer-*.json
## if you want to enable extra log
$ PACKER_LOG_PATH="packerlog.txt" PACKER_LOG=1 packer build packer-*.json
## for digitalocean build, you need to export TOKEN in environment.
##  update json config on your setup and region.
$ export DO_TOKEN=xxx
$ packer build -only=digitalocean packer-*.json
```

## License

BSD 2-clause

