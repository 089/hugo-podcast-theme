#!/usr/bin/env bash

# redirect output to file
exec 9> _deploy.log

echo "STARTED DEPLOY WEBSITE" >&9

# create preview feed
hugo --minify --buildFuture >&9
cp public/episode/index.xml preview/

# remove old directory
rm -r public/* >&9

# enable production mode 
export HUGO_ENV="production" >&9

# create static pages
if [ "$1" != "bf" ]; then
	echo "buildFuture is disabled" >&9
	hugo --minify $1 >&9
else
    echo "buildFuture is enabled" >&9
    hugo --minify --buildFuture >&9
fi

# cp preview directory --> podpreview: vorherhören
cp -r preview/ public/

# cp robots.txt
cp robots.txt public/

# copy to server
rsync -rtvhze ssh public/ user@7gutegruende.de:/var/www/html/7gutegruende.de/ >&9

echo "FINISHED DEPLOY WEBSITE" >&9
