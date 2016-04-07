[![Build Status](https://travis-ci.org/juju4/ansible-mhn.svg?branch=master)](https://travis-ci.org/juju4/ansible-mhn)
# MHN Server and Clients ansible roles

Mostly a conversion of the shell scripts of https://github.com/threatstream/mhn to ansible config
https://github.com/threatstream/mhn/

As stated in MHN FAQ, you need proper updates and hardening for those systems. (other roles)

## Requirements & Dependencies

### Ansible
It was tested on the following versions:
 * 1.9.2
under Linux and MacOS X

### Operating systems

Tested with vagrant+ansible or ansible on Ubuntu Trusty for now but should work on any debian based systems at a few exception (dionaea is using honeynet ppa).
MHN does not support redhat/rpm system so tasks need to be rewritten to be completed with appropriate rpm repository or from source.

## Example Playbook

Just include this role in your list.
For example

```
- hosts: mhnserver
  roles:
      - maxmind
      - { role: mhn, mhnmode: server }
- hosts: mhnclient
  roles:
    #- { role: mhn, mhnmode: client, dionaea: true, glastopf: true, wordpot: true }
    - { role: mhn, mhnmode: client }
```

Once your server is configured, you will need to define additional vars (server_url, deploy_key, ...) before deploying clients.
deploy_key can be retrieved either from Web UI, either from /var/mhn/server/config.py.

If you use kippo, after first execution, you must change ssh port in your inventory file (manual inventory or vagrant .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory) or Vagrantfile (config.ssh.port) else you will have no connection. Eventually, you can override it from ansible command line (-e).

May need to add a Maxmind dependency for honeymap (configured to look into /var/maxmind)

It is recommended to reboot system after the ansible playbook as updates probably includes kernel one and to ensure everything is fine. Playbook can do it but default variable is noreboot true.


## Example Vagrantfile

Example to use with vagrant on virtualbox joined. need corresponding site.yml (previous section).
Deployment tested on Virtualbox, Amazon and Digital Ocean.

## Variables

Check defaults/main.yml for a full list.

Most important are
* mhnmode: either server or client
* MHN_EMAIL: login to web interface
* MHN_PASS: password to web interface
* server_url: need to be set to your server IP
* httpsport: to be define if you want the webserver (nginx) to be configured https only on this port. server_url need to reflect that and if you use a self-signed certificate, curl_arg too.
* deploy_key: once server is configured, you can extract this value in /var/mhn/server/config.py or through web interface > deploy. It is mandatory for client configuration.

## Continuous integration

you can test this role with test kitchen.
In the role folder, run
```
$ kitchen verify
```

Known bugs
* Ubuntu: the notify 'supervisor restart' fails the first time and nginx too. not sure
  why. second time run is fine after you do ```sudo service supervisor restart; sudo service nginx restart```
  (failed notified handlers).
?
https://github.com/ansible/ansible/issues/8155
https://github.com/ansible/ansible/issues/3977
https://groups.google.com/forum/#!msg/ansible-project/3ot5-ykkAew/ygrdCMnaeHQJ

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

## FAQ

Check
https://github.com/threatstream/mhn/wiki/MHN-Troubleshooting-Guide

## License

BSD 2-clause

