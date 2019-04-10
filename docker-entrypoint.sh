#!/bin/ash
/usr/local/bin/envsubst < /config/alertmanager-template.yml > /etc/alertmanager/alertmanager.yml
exec "$@"
