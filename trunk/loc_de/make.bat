set HACKNAME=loc_de
set PKGVER=0.3

rem copy ..\..\K3Translator.jar .\

echo Pack images
..\bin\7z a ui_loc.tar  ui_loc\*.gif
..\bin\7z a ui_loc.tar.gz ui_loc.tar
del ui_loc.tar

echo Pack config
..\bin\7z a config.tar  config\*.gif
..\bin\7z a config.tar.gz config.tar
del config.tar

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

rem echo Create update archive
rem ..\bin\7z a update_%HACKNAME%_%PKGVER%.zip *.bin *.keyb

rem echo Clean up
rem del *.bin
rem del translation.jar
rem del ui_loc.tar.gz
