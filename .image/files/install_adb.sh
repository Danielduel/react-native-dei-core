wget -O "/etc/apk/keys/sgerrand.rsa.pub" "https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub"
wget -O "/tmp/glibc.apk" "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk"
wget -O "/tmp/glibc-bin.apk" "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-bin-2.28-r0.apk"
apk add "/tmp/glibc.apk" "/tmp/glibc-bin.apk"
rm "/etc/apk/keys/sgerrand.rsa.pub"
rm "/root/.wget-hsts"
rm "/tmp/glibc.apk" "/tmp/glibc-bin.apk"
rm -r /var/cache/apk/APKINDEX.*
/usr/local/bin/update-platform-tools.sh
