#!/bin/ash

workdir=$(mktemp -d)

# Find all secrets that may have been mounted
find /etc/alertmanager/secrets/ -type f | while read f ;
do
  _secret_name=`basename $f`
  _secret_contents=`cat $f`
  # Dump them to a tempfile for now to get around exporting in a 
  # sub-hell.
  echo "export ${_secret_name}=\"${_secret_contents}\"" >> $workdir/secrets.var
done

# Source the secrets and make them available to envsubst
source $workdir/secrets.var

# Now generate the real alertmanager config
/usr/local/bin/envsubst < /etc/alertmanager/configmaps/alertmanager/alertmanager.yml > /etc/alertmanager/alertmanager.yml
exec "$@"
