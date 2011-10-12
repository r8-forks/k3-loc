set HACKNAME=loc_ru
set PKGVER=0.15

rem copy ..\..\K3Translator.jar .\

echo Pack images
..\bin\7z a ui_loc.tar  ui_loc\*.gif
..\bin\7z a ui_loc.tar.gz ui_loc.tar
del ui_loc.tar

echo Compile translation.jar
java -cp bcel-5.2.jar;K3Translator.jar Translator mt ./strings translation.jar

echo Create update files
set DEVICE=k3w
..\bin\kindle_update_tool.py m --%DEVICE% --sign %HACKNAME%_%PKGVER%_%DEVICE%_install install.sh bcel-5.2.jar K3Translator.jar translation.jar msp_prefs loc-init loc-bind ui_loc.tar.gz
..\bin\kindle_update_tool.py m --%DEVICE% --sign %HACKNAME%_%PKGVER%_%DEVICE%_uninstall uninstall.sh

set DEVICE=k3g
..\bin\kindle_update_tool.py m --%DEVICE% --sign %HACKNAME%_%PKGVER%_%DEVICE%_install install.sh bcel-5.2.jar K3Translator.jar translation.jar msp_prefs loc-init loc-bind ui_loc.tar.gz
..\bin\kindle_update_tool.py m --%DEVICE% --sign %HACKNAME%_%PKGVER%_%DEVICE%_uninstall uninstall.sh

set DEVICE=k3gb
..\bin\kindle_update_tool.py m --%DEVICE% --sign %HACKNAME%_%PKGVER%_%DEVICE%_install install.sh bcel-5.2.jar K3Translator.jar translation.jar msp_prefs loc-init loc-bind ui_loc.tar.gz
..\bin\kindle_update_tool.py m --%DEVICE% --sign %HACKNAME%_%PKGVER%_%DEVICE%_uninstall uninstall.sh

set DEVICE=dxg
..\bin\kindle_update_tool.py m --%DEVICE% --sign %HACKNAME%_%PKGVER%_%DEVICE%_install install.sh bcel-5.2.jar K3Translator.jar translation.jar msp_prefs loc-init loc-bind ui_loc.tar.gz
..\bin\kindle_update_tool.py m --%DEVICE% --sign %HACKNAME%_%PKGVER%_%DEVICE%_uninstall uninstall.sh

set DEVICE=dxi
..\bin\kindle_update_tool.py m --%DEVICE% --sign %HACKNAME%_%PKGVER%_%DEVICE%_install install.sh bcel-5.2.jar K3Translator.jar translation.jar msp_prefs loc-init loc-bind ui_loc.tar.gz
..\bin\kindle_update_tool.py m --%DEVICE% --sign %HACKNAME%_%PKGVER%_%DEVICE%_uninstall uninstall.sh

set DEVICE=dx
..\bin\kindle_update_tool.py m --%DEVICE% --sign %HACKNAME%_%PKGVER%_%DEVICE%_install install.sh bcel-5.2.jar K3Translator.jar translation.jar msp_prefs loc-init loc-bind ui_loc.tar.gz
..\bin\kindle_update_tool.py m --%DEVICE% --sign %HACKNAME%_%PKGVER%_%DEVICE%_uninstall uninstall.sh

echo Create update archive
..\bin\7z a update_%HACKNAME%_%PKGVER%.zip *.bin *.keyb

echo Clean up
del *.bin
del translation.jar
del ui_loc.tar.gz