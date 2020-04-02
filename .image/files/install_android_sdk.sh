curl -SLO "https://dl.google.com/android/repository/tools_r${SDK_VERSION}-linux.zip"
echo "${SDK_CHECKSUM}  tools_r${SDK_VERSION}-linux.zip" | sha256sum -cs
mkdir -p "${ANDROID_HOME}"
unzip "tools_r${SDK_VERSION}-linux.zip" -d "${ANDROID_HOME}"
rm -Rf "tools_r${SDK_VERSION}-linux.zip"
echo y | ${ANDROID_HOME}/tools/android update sdk --filter ${SDK_UPDATE} --all --no-ui --force
mkdir -p ${ANDROID_HOME}/tools/keymaps
touch ${ANDROID_HOME}/tools/keymaps/en-us

# Licenses taken from https://github.com/mindrunner/docker-android-sdk
mkdir -p ${ANDROID_HOME}/licenses
echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55\n" > ${ANDROID_HOME}/licenses/android-sdk-license
echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd\n" > ${ANDROID_HOME}/licenses/android-sdk-preview-license

curl -SLO https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip
mkdir -p "${GRADLE_HOME}"
unzip "gradle-${GRADLE_VERSION}-bin.zip" -d "/opt"
rm -f "gradle-${GRADLE_VERSION}-bin.zip"
apk del curl
