set -e

curl -v --silent https://$HOSTNAME/ 2>&1 | grep github.com
