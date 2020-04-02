VERSION="$( cat VERSION )"
echo $VERSION
docker build -t danielduel/react-native-dei-core:$VERSION .
docker push danielduel/react-native-dei-core:$VERSION
