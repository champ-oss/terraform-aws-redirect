set -e

curl -v http://$HOSTNAME/ | grep github.com
curl -v https://$HOSTNAME/ | grep github.com
