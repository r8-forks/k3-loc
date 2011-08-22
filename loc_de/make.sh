#!/bin/sh
HACKNAME=loc_de
PKGVER=0.3
KindleUpdatePY=../bin/kindle_update_tool_x.py 

# cp ../../K3Translator.jar .

echo Pack images
tar cvf ui_loc.tar ui_loc/*.gif
gzip -v ui_loc.tar

echo Pack config
tar cvf config.tar config/*
gzip -v config.tar

echo Compile translation.jar
java -Xmx500m -classpath bcel-5.2.jar:K3Translator.jar Translator mt ./strings translation.jar

echo Create update files
DEVICE=k3w
$KindleUpdatePY m --${DEVICE} --sign ${HACKNAME}_${PKGVER}_${DEVICE}_install install.sh bcel-5.2.jar K3Translator.jar translation.jar config.tar.gz loc-init loc-bind ui_loc.tar.gz
$KindleUpdatePY m --${DEVICE} --sign ${HACKNAME}_${PKGVER}_${DEVICE}_uninstall uninstall.sh

DEVICE=k3g
$KindleUpdatePY m --${DEVICE} --sign ${HACKNAME}_${PKGVER}_${DEVICE}_install install.sh bcel-5.2.jar K3Translator.jar translation.jar config.tar.gz loc-init loc-bind ui_loc.tar.gz
$KindleUpdatePY m --${DEVICE} --sign ${HACKNAME}_${PKGVER}_${DEVICE}_uninstall uninstall.sh

DEVICE=k3gb
$KindleUpdatePY m --${DEVICE} --sign ${HACKNAME}_${PKGVER}_${DEVICE}_install install.sh bcel-5.2.jar K3Translator.jar translation.jar config.tar.gz loc-init loc-bind ui_loc.tar.gz
$KindleUpdatePY m --${DEVICE} --sign ${HACKNAME}_${PKGVER}_${DEVICE}_uninstall uninstall.sh

DEVICE=dxg
$KindleUpdatePY m --${DEVICE} --sign ${HACKNAME}_${PKGVER}_${DEVICE}_install install.sh bcel-5.2.jar K3Translator.jar translation.jar config.tar.gz loc-init loc-bind ui_loc.tar.gz
$KindleUpdatePY m --${DEVICE} --sign ${HACKNAME}_${PKGVER}_${DEVICE}_uninstall uninstall.sh

DEVICE=dxi
$KindleUpdatePY m --${DEVICE} --sign ${HACKNAME}_${PKGVER}_${DEVICE}_install install.sh bcel-5.2.jar K3Translator.jar translation.jar config.tar.gz loc-init loc-bind ui_loc.tar.gz
$KindleUpdatePY m --${DEVICE} --sign ${HACKNAME}_${PKGVER}_${DEVICE}_uninstall uninstall.sh

DEVICE=dx
$KindleUpdatePY m --${DEVICE} --sign ${HACKNAME}_${PKGVER}_${DEVICE}_install install.sh bcel-5.2.jar K3Translator.jar translation.jar config.tar.gz loc-init loc-bind ui_loc.tar.gz
$KindleUpdatePY m --${DEVICE} --sign ${HACKNAME}_${PKGVER}_${DEVICE}_uninstall uninstall.sh

#echo Create update archive
#zip update_${HACKNAME}_${PKGVER}.zip *.bin *.keyb

#echo Clean up
#rm  *.bin
#rm  translation.jar
#rm  ui_loc.tar.gz
#rm  config.tar.gz
