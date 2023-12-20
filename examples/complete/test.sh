set -e

curl -v --silent http://$HOSTNAME/ 2>&1 | grep github.com
curl -v --silent https://$HOSTNAME/ 2>&1 | grep github.com
