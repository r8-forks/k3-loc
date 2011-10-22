#!/bin/sh
HACKNAME=loc_de
PKGVER=0.7
KindleUpdatePY=../bin/kindle_update_tool_x.py 

cp ../bin/K3Translator-Unix.jar K3Translator.jar

dlist="k3w k3g k3gb dxg dxi dx "
if [ $# -eq 1 ] ; then
	dlist=$1
fi

echo Pack images
tar cvf ui_loc.tar ui_loc/*.gif
gzip -v ui_loc.tar

echo Pack config
tar cvf config.tar config/*
gzip -v config.tar

echo Compile translation.jar
java -Xmx500m -classpath bcel-5.2.jar:K3Translator.jar Translator mt ./strings translation.jar

echo Create update files
for i in $dlist
do
	DEVICE=$i
	$KindleUpdatePY m --${DEVICE} --sign ${HACKNAME}_${PKGVER}_${DEVICE}_install install.sh bcel-5.2.jar K3Translator.jar translation.jar config.tar.gz loc-init loc-bind ui_loc.tar.gz
	$KindleUpdatePY m --${DEVICE} --sign ${HACKNAME}_${PKGVER}_${DEVICE}_uninstall uninstall.sh
done

#echo Create update archive
zip update_${HACKNAME}_${PKGVER}.zip *.bin *.keyb

echo Clean up
rm  *.bin
rm  translation.jar
rm  ui_loc.tar.gz
rm  config.tar.gz
