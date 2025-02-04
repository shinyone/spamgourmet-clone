#!/bin/bash
#This script expects to be run from the spamgourmet-clone main directory
echo '##########################################################################'
echo '### set up automated provisioning for exim4 and lighttpd'
echo '##########################################################################'
source sg-server-config.sh

cd $SCRIPT_BASE_DIR

# must install exim4 and lighttpd so I can have /etc/exim4 and Debian-exim group
# and /etc/lighttpd
apt-get update; apt-get upgrade -y ; apt-get autoremove
apt-get install -y exim4 lighttpd

mkdir -p /etc/cron.daily
cat <<-EOF >/etc/cron.daily/provision-sg-certs.sh
#!/bin/bash
# exim certificates
cp /etc/ssl/certs/$DOMAIN.crt   /etc/exim4/exim.crt
cp /etc/ssl/private/$DOMAIN.pem /etc/exim4/exim.key
chown root:Debian-exim /etc/exim4/exim.*
chmod 640 /etc/exim4/exim.*
cp /etc/ssl/private/dkim.pem /etc/exim4/
cp /etc/ssl/certs/dkim.crt   /etc/exim4/
chown root:Debian-exim /etc/exim4/dkim.*
chmod 640 /etc/exim4/dkim.*
service exim4 restart
# lighttpd certificates
cat /etc/ssl/certs/$DOMAIN.pem /etc/ssl/private/$DOMAIN.pem >/etc/lighttpd/web.pem
chmod 600 /etc/lighttpd/web.pem
chown root:root /etc/lighttpd/web.pem
service lighttpd restart
EOF
chmod +x /etc/cron.daily/provision-sg-certs.sh

# and now do the first provisioning
/etc/cron.daily/provision-sg-certs.sh
