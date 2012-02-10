set HACKNAME=ru_mini
set PKGVER=4.04

copy ..\..\K3Translator.jar .\

echo Compile translation.jar
java -cp bcel-5.2.jar;K3Translator.jar Translator mt ./strings translation.jar

echo Create update files
set DEVICE=k4w
..\bin\kindle_update_tool.py m --%DEVICE% --sign %HACKNAME%_%PKGVER%_%DEVICE%_install install.sh bcel-5.2.jar K3Translator.jar translation.jar ru.properties
..\bin\kindle_update_tool.py m --%DEVICE% --sign %HACKNAME%_%PKGVER%_%DEVICE%_uninstall uninstall.sh

echo Create update archive
..\bin\7z a update_%HACKNAME%_%PKGVER%.zip *.bin *.keyb

echo Clean up
del *.bin
rem del translation.jar