
#
# Variables
# 
set -x

buildpath="$(cd $(dirname $0); pwd)"
webapppath="${buildpath}/../src/main/webapp"
releasepath="${webapppath}/build"

#
# Command path definitions
#
python="/usr/bin/python"
mkdir="/bin/mkdir"
rm="/bin/rm"
sh="/bin/sh"
cp="/bin/cp"

#
# build
#
if [ -d ${releasepath} ]; then
    ${rm} -rf ${releasepath}
fi

${mkdir} -p ${releasepath} ${releasepath}/lang

(cd ${buildpath};
 echo "running jsbuild for main app..."
 /bin/jsbuild -o "${releasepath}" main.cfg
 echo "done."
)

if [ ! -e ${releasepath}/mapfishapp.js ]; then
    echo "\033[01;31m[NOK]\033[00m jsbuild failure"
    exit 1
fi;
#
# OpenLayers resources
#
openlayerspath="${webapppath}/lib/externals/openlayers"
openlayersreleasepath="${releasepath}/openlayers"

echo "copying OpenLayers resources..."
${mkdir} ${openlayersreleasepath}
${cp} -r "${openlayerspath}/img" "${openlayersreleasepath}"
${cp} -r "${openlayerspath}/theme" "${openlayersreleasepath}"
echo "done."

# Cleanup SVN stuff
${rm} -rf `find "${releasepath}" -name .svn -type d`

echo "built files and resources placed in src/main/webapp/build"

exit 0
