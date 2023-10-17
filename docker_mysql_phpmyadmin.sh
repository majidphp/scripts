docker network create application
# Create dir for database data  
mkdir -p /opt/mysql
 
# Create MySQL container 
docker run -d \
  --name mysql \
  --network application \
  -e MYSQL_ROOT_PASSWORD="YOUR_DB_PASSWORD" \
  -v /opt/mysql:/var/lib/mysql \
  -p 3306:3306 \
  mysql

docker run -d \
  --name phpmyadmin \
  --network application \
  -e PMA_HOST=mysql \
  -p 7575:80 \
  phpmyadmin
