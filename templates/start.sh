#!/bin/sh
## /opt/kippo/start.sh

cd /opt/kippo
{% if iptable_support %}
exec /usr/bin/twistd -n -y kippo.tac -l log/kippo.log --pidfile kippo.pid

{% else %}
su kippo -c "authbind --deep twistd -n -y kippo.tac -l log/kippo.log --pidfile kippo.pid"

{% endif %}

