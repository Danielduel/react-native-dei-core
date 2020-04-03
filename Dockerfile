FROM node:13.12.0-alpine3.11

#
# This one is used to setup abd, more info in further comments.
# To be honest - update-platform-tools.sh is doing stuff with repos and certs,
# I haven't checked that for safety.
#
ADD .image/files/install_adb.sh /usr/local/bin/install_adb.sh
ADD .image/files/update-platform-tools.sh /usr/local/bin/update-platform-tools.sh
#
# Android sdk things
#
ADD .image/files/install_android_sdk.sh /usr/local/bin/install_android_sdk.sh
#
# Services aren't used now, probably will change later.
#
ADD .image/systemd/* /etc/systemd/system/

#
# Envs for android sdk
#
ENV SDK_VERSION     25.2.3
ENV SDK_CHECKSUM    1b35bcb94e9a686dff6460c8bca903aa0281c6696001067f34ec00093145b560
ENV ANDROID_HOME    /opt/android-sdk
#
# This is working for new devices, I need to create a script to automate builds for
# older android sdks in future.
#
ENV SDK_UPDATE      tools,platform-tools,build-tools-28.0.3,android-28
# ENV SDK_UPDATE    tools,platform-tools,build-tools-25.0.2,build-tools-28.0.3,android-28,android-25,android-24,android-23,android-22,android-21,sys-img-armeabi-v7a-android-23,sys-img-x86-android-23
ENV LD_LIBRARY_PATH ${ANDROID_HOME}/tools/lib64/qt:${ANDROID_HOME}/tools/lib/libQt5:$LD_LIBRARY_PATH/
ENV GRADLE_VERSION  2.13
ENV GRADLE_HOME     /opt/gradle-${GRADLE_VERSION}
ENV PATH            ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${GRADLE_HOME}/bin

#
# So, there is this fancy part, which is setting up everything...
#
RUN set -xeo pipefail \
  # Init
  &&  apk update \
  # Add random stuff, which is probably needed later
  &&  apk add curl wget ca-certificates tini screen bash gradle openjdk8 \
  #
  # This piece will get and setup adb
  # original: https://github.com/sorccu/docker-adb/blob/master/Dockerfile
  #
  # The original repo is setting up a adb server, which I think is not needed in
  # our case.
  # 
  && /usr/local/bin/install_adb.sh \
  #
  # This piece will get and setup android studio with accepting licenses
  # original: https://github.com/cakuki/docker-alpine-android-sdk
  #
  # Gradle is also a part of sdk, so it's included in this script.
  # 
  && /usr/local/bin/install_android_sdk.sh

# yarn is a part of alpine-node
WORKDIR /code
ADD package*.json .
ADD yarn.lock .
RUN yarn install && yarn global add react-native-cli

# Expose default ADB port
EXPOSE 5037

# Hook up tini as the default init system for proper signal handling
ENTRYPOINT ["/sbin/tini", "--"]
