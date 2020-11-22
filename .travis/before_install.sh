#!/usr/bin/env bash

#sudo apt install -y libmemcached-dev
git clone https://github.com/php-memcached-dev/php-memcached.git
cd php-memcached
phpize
./configure --disable-memcached-sasl
make
sudo make install
echo "extension = memcached" >> ~/.phpenv/versions/$(phpenv version-name)/etc/conf.d/travis.ini

git clone https://github.com/xdebug/xdebug
cd xdebug
git checkout origin/xdebug_2_9 -b 2.9
phpize
./configure
make
make install
cat << EOF >~/xdebug.ini
zend_extension = xdebug
xdebug.coverage_enable=On
EOF

mkdir -p \"${BUILD_CACHE_DIR}\" || exit $? # Create build cache directory

cp app/config/recaptcha_secrets.json.dist app/config/recaptcha_secrets.json

# Update composer to the latest stable release as the build env version is outdated
composer self-update --stable || exit $?
