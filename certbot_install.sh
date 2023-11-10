if [ "$EUID" -ne 0 ]
then
        echo "Please run as root or sudo"
        exit
fi

if [ -z "$1" ]
then
        echo "Please provide your domain"
        exit
elif [ -z "$2" ]
then
        echo "Please provide your email address"
        exit
fi

apt install python3 python3-venv libaugeas0 -y
python3 -m venv /opt/certbot/
/opt/certbot/bin/pip install --upgrade pip
/opt/certbot/bin/pip install certbot certbot-apache
 /opt/certbot/bin/pip install certbot certbot-nginx
ln -s /opt/certbot/bin/certbot /usr/bin/certbot

DOMAIN=$1
EMAIL=$2

certbot certonly -d $DOMAIN --non-interactive --agree-tos -m $EMAIL
