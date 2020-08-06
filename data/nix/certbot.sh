
# Cron Job
echo "0 0,12 * * * root python -c 'import random; import time; time.sleep(random.random() * 3600)' && update-alternatives --set python3 /usr/bin/python3.5 && certbot renew -q && update-alternatives --set python3 /usr/bin/python3.6" | sudo tee -a /etc/crontab > /dev/null
echo "0 0,12 * * * root python -c 'import random; import time; time.sleep(random.random() * 3600)' && /usr/local/bin/certbot-auto renew -q" | sudo tee -a /etc/crontab > /dev/null

# 0 */12 * * * root test -x /usr/bin/certbot -a \! -d /run/systemd/system && perl -e 'sleep int(rand(43200))' && certbot -q renew
0 */12 * * * root test -x /usr/bin/certbot && perl -e 'sleep int(rand(43200))' && certbot -q renew


certbot certonly -d example.com -d *.example.com --dns-route53 --logs-dir ./letsencrypt/log/ --config-dir ./letsencrypt/config/ --work-dir ./letsencrypt/work/ -m email@example.com --agree-tos --non-interactive --server https://acme-v02.api.letsencrypt.org/directory
certbot renew --dns-route53 --logs-dir ./letsencrypt/log/ --config-dir ./letsencrypt/config/ --work-dir ./letsencrypt/work/ --non-interactive --server https://acme-v02.api.letsencrypt.org/directory
