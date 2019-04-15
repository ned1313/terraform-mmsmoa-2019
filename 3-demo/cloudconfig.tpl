#cloud-config
#Requires modification
#cloud-init to setup a LEMP stack
#more details at www.opentechshed.com/lemp-stack-using-cloud-init
package_upgrade: true

packages:
  - nginx
  - php7.0-fpm
  - php-mysql
  - php7.0-mcrypt
  - php7.0-gd
  - php7.0-curl
  - git

write_files:
  - path: /etc/nginx/sites-available/default
    content: |
      server {
        listen 80 default_server;
        listen [::]:80 default_server ipv6only=on;
        root /var/www/html;
        index index.php index.html index.htm;
        server_name localhost;
        location / {
            # First attempt to serve request as file, then
            # as directory, then fall back to displaying a 404.
            try_files $uri $uri/ =404;
            # Uncomment to enable naxsi on this location
            # include /etc/nginx/naxsi.rules
        }
        error_page 404 /404.html;
        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
            root /usr/share/nginx/html;
        }
        location ~ \.php$ {
            try_files $uri =404;
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
            fastcgi_index index.php;
            include fastcgi.conf;
        }
      }

  - path: /var/www/html/index.php
    content: |
      <?php
      phpinfo();
      ?>

runcmd:
  - export HNAME=$(hostname -f)
  - export MDBPASS=`dd if=/dev/urandom bs=1 count=12 2>/dev/null | base64 -w 0 | rev | cut -b 2- | rev`
  - export DEBIAN_FRONTEND=noninteractive
  - echo "mariadb-server-10.0 mysql-server/root_password password $MDBPASS" | debconf-set-selections
  - echo "mariadb-server-10.0 mysql-server/root_password_again password $MDBPASS" | debconf-set-selections
  - sudo apt-get -y install software-properties-common
  - sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
  - sudo add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.3/ubuntu xenial main'
  - sudo apt update
  - sudo apt -y install mariadb-server
  - sed -i 's/server_name localhost;/server_name '$HOSTNAME';/' /etc/nginx/sites-available/default
  - systemctl restart nginx
  - echo "$MDBPASS" >> /root/mysql.txt