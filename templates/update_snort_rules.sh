#!/bin/bash
## /etc/cron.daily/update_snort_rules.sh

mkdir -p /opt/mhn/rules
rm -f /opt/mhn/rules/mhn.rules.tmp
echo "[`date`] Updating snort signatures ..."
wget --no-check-certificate {{ server_url }}/static/mhn.rules -O /opt/mhn/rules/mhn.rules.tmp && \
    mv /opt/mhn/rules/mhn.rules.tmp /opt/mhn/rules/mhn.rules && \
    (supervisorctl update ; supervisorctl restart snort ) && \
    echo "[`date`] Successfully updated snort signatures" && \
    exit 0

echo "[`date`] Failed to update snort signatures"
exit 1

