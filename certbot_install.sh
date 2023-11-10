if [ "$EUID" -ne 0 ]
then
        echo "Please run as root or sudo"
        exit
fi

OS=$(lsb_release -si)
if [[ $OS != *"Ubuntu"* ]]; then
        echo "This script run only for Ubuntu"
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

apt update

PS3="Please select your webserver: "
options=("Apache" "Nginx")
select opt in "${options[@]}"
do
    case $opt in
        "Apache")
            WEBSRV='apache'
            WEBSERVICE='apache2'
            break
            ;;
        "Nginx")
            WEBSRV='nginx'
            WEBSERVICE='nginx'
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

servstat=$(service $WEBSERVICE status)

if [[ $servstat == *"is not running"* ]]; then
        echo "Please make sure $WEBSRV is running"
        exit
fi

apt install python3 python3-venv libaugeas0 -y
python3 -m venv /opt/certbot/
/opt/certbot/bin/pip install --upgrade pip
/opt/certbot/bin/pip install certbot certbot-$WEBSRV
ln -s /opt/certbot/bin/certbot /usr/bin/certbot

DOMAIN=$1
EMAIL=$2

certbot certonly -d $DOMAIN --$WEBSRV --non-interactive --agree-tos -m $EMAIL
