set HACKNAME=ru_RU
set PKGVER=4.04

copy ..\..\K3Translator.jar .\

echo Pack img images
..\bin\7z a -r img.tar  img\*.gif
..\bin\7z a img.tar.gz img.tar
del img.tar

echo Pack low_level_screens images
..\bin\7z a -r low_level_screens.tar low_level_screens\*.png
..\bin\7z a low_level_screens.tar.gz low_level_screens.tar
del low_level_screens.tar

echo Compile translation.jar
java -cp bcel-5.2.jar;K3Translator.jar Translator mt ./strings translation.jar

echo Create update files
set DEVICE=k4w
..\bin\kindle_update_tool.py m --%DEVICE% --sign %HACKNAME%_%PKGVER%_%DEVICE%_install install.sh bcel-5.2.jar K3Translator.jar translation.jar ru.properties low_level_screens.tar.gz img.tar.gz
rem ..\bin\kindle_update_tool.py m --%DEVICE% --sign %HACKNAME%_%PKGVER%_%DEVICE%_uninstall uninstall.sh

echo Create update archive
..\bin\7z a update_%HACKNAME%_%PKGVER%.zip *.bin *.keyb

echo Clean up
del *.bin
rem del translation.jar
del low_level_screens.tar.gz 
del img.tar.gz