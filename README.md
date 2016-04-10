# le-cron #

Cron script for [letsencrypt.sh](https://github.com/lukas2511/letsencrypt.sh)

Use with Nginx and Debian.

## Usage ##

	$ git clone https://github.com/petrkle/le-cron.git

	$ cd le-cron

	$ sudo make init

Then edit list of your domains in /home/letsencrypt/domains.txt, add
your email address to /home/letsencrypt/config.sh

Next step is add redirect and alias to your nginx configuration:

	server {
	    listen *:80;
	    listen [::]:80;
	    server_name example.com www.example.com;
	
	    location / {
	        return 301 https://example.com$request_uri;
	    }
	
	    location /.well-known/acme-challenge {
	      alias /home/letsencrypt/www;
	    }
	}

After nginx reload can run

	$ sudo /home/letsencrypt/le-cron.sh

and finaly add new certs to nginx conf:

	server {
	    listen 443 ssl spdy;
	    listen [::]:443 ssl spdy;
	    ssl on;
	    server_name example.com;
	    ssl_certificate      /home/letsencrypt/certs/example.com/fullchain.pem;
	    ssl_certificate_key  /home/letsencrypt/certs/example.com/privkey.pem;
	}

## Requirements ##

 * git
 * sudo
 * make
