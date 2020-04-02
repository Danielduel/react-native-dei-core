VERSION="$( cat VERSION )"
echo $VERSION
docker build -t duelsik/react-native-env-core:$VERSION .
