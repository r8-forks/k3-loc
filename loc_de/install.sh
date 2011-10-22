#!/bin/sh
#
# $Id: install.sh 6845 2010-09-23 23:11:24Z NiLuJe $
#
# diff OTA patch script

_FUNCTIONS=/etc/rc.d/functions
[ -f ${_FUNCTIONS} ] && . ${_FUNCTIONS}


MSG_SLLVL_D="debug"
MSG_SLLVL_I="info"
MSG_SLLVL_W="warn"
MSG_SLLVL_E="err"
MSG_SLLVL_C="crit"
MSG_SLNUM_D=0
MSG_SLNUM_I=1
MSG_SLNUM_W=2
MSG_SLNUM_E=3
MSG_SLNUM_C=4
MSG_CUR_LVL=/var/local/system/syslog_level

export MNT_US_LOC=/mnt/us/localization

logmsg()
{
    local _NVPAIRS
    local _FREETEXT
    local _MSG_SLLVL
    local _MSG_SLNUM

    _MSG_LEVEL=$1
    _MSG_COMP=$2

    { [ $# -ge 4 ] && _NVPAIRS=$3 && shift ; }

    _FREETEXT=$3

    eval _MSG_SLLVL=\${MSG_SLLVL_$_MSG_LEVEL}
    eval _MSG_SLNUM=\${MSG_SLNUM_$_MSG_LEVEL}

    local _CURLVL

    { [ -f $MSG_CUR_LVL ] && _CURLVL=`cat $MSG_CUR_LVL` ; } || _CURLVL=1

    if [ $_MSG_SLNUM -ge $_CURLVL ]; then
        /usr/bin/logger -p local4.$_MSG_SLLVL -t "ota_install" "$_MSG_LEVEL def:$_MSG_COMP:$_NVPAIRS:$_FREETEXT"
    fi

    if [ "$_MSG_LEVEL" != "D" ]; then
      echo "ota_install: $_MSG_LEVEL def:$_MSG_COMP:$_NVPAIRS:$_FREETEXT"
      [ -d ${MNT_US_LOC} ] && echo "ota_install: $_MSG_LEVEL def:$_MSG_COMP:$_NVPAIRS:$_FREETEXT" >> ${MNT_US_LOC}/install.log
    fi
}

# Hack specific config (name and when to start/stop)
ORIGFOLDER_BLT=/opt/amazon/ebook/booklet
ORIGFOLDER_LIB=/opt/amazon/ebook/lib
ORIGFOLDER_IMG=/opt/amazon/ebook/img/ui
ORIGFOLDER_CNF=/opt/amazon/ebook/config
#
DESTFOLDER_BLT=${ORIGFOLDER_BLT}_loc
DESTFOLDER_LIB=${ORIGFOLDER_LIB}_loc
DESTFOLDER_IMG=${ORIGFOLDER_IMG}_loc
DESTFOLDER_CNF=${ORIGFOLDER_CNF}_loc

# Unbind folders to original locations
logmsg "I" "update" "restore bindings"
[ -d ${DESTFOLDER_BLT} ] && umount ${ORIGFOLDER_BLT}
[ -d ${DESTFOLDER_LIB} ] && umount ${ORIGFOLDER_LIB}
[ -d ${DESTFOLDER_IMG} ] && umount ${ORIGFOLDER_IMG}
[ -f ${DESTFOLDER_CNF}/msp_prefs     ] && umount ${ORIGFOLDER_CNF}/msp_prefs

# DX content
[ -f ${DESTFOLDER_CNF}/reader.conf ] && umount ${ORIGFOLDER_CNF}/reader.conf
[ -f ${DESTFOLDER_CNF}/browser_prefs ] && umount ${ORIGFOLDER_CNF}/browser_prefs
update_progressbar 10

# and (safely) deleting unmounted dirs
[ -d $DESTFOLDER_BLT ] && rm -rf $DESTFOLDER_BLT
[ -d $DESTFOLDER_LIB ] && rm -rf $DESTFOLDER_LIB
[ -d $DESTFOLDER_IMG ] && rm -rf $DESTFOLDER_IMG
# deleting all config files
[ -d $DESTFOLDER_CNF ] && rm -rf $DESTFOLDER_CNF
update_progressbar 15

#Create localization dir at user store
[ -d ${MNT_US_LOC} ] || mkdir ${MNT_US_LOC}

logmsg "I" "update" "translate JARs"
# Translate all JARs in 'booklet' and 'lib' folders
update_progressbar 20

/usr/java/bin/cvm -Xms16m -classpath bcel-5.2.jar:K3Translator.jar Translator td $ORIGFOLDER_BLT translation.jar $DESTFOLDER_BLT /mnt/us >> ${MNT_US_LOC}/install.log 2>&1
update_progressbar 40

/usr/java/bin/cvm -Xms16m -classpath bcel-5.2.jar:K3Translator.jar Translator td $ORIGFOLDER_LIB translation.jar $DESTFOLDER_LIB /mnt/us >> ${MNT_US_LOC}/install.log 2>&1
update_progressbar 60

# Unpack config dir (Rest of the language specific strings)
tar -xvzf config.tar.gz

logmsg "I" "update" "translate config"
# Translate all config files in 'config' folders
update_progressbar 70

mkdir ${DESTFOLDER_CNF}
/usr/java/bin/cvm -Xms16m -classpath bcel-5.2.jar:K3Translator.jar Translator tprefs ${ORIGFOLDER_CNF}/msp_prefs     ${DESTFOLDER_CNF}/msp_prefs     config/msp_prefs     >> /mnt/us/localization/install.log 2>&1
/usr/java/bin/cvm -Xms16m -classpath bcel-5.2.jar:K3Translator.jar Translator tprefs ${ORIGFOLDER_CNF}/browser_prefs ${DESTFOLDER_CNF}/browser_prefs config/browser_prefs >> /mnt/us/localization/install.log 2>&1
/usr/java/bin/cvm -Xms16m -classpath bcel-5.2.jar:K3Translator.jar Translator tprefs ${ORIGFOLDER_CNF}/reader.conf   ${DESTFOLDER_CNF}/reader.conf   config/reader.conf   >> /mnt/us/localization/install.log 2>&1
update_progressbar 80

logmsg "I" "update" "copy images"
# Unpack and copy UI images
tar -xvzf ui_loc.tar.gz
[ -d ${DESTFOLDER_IMG} ] && rm -rf ${DESTFOLDER_IMG}
chown -R root:root ui_loc
chmod -R 644 ui_loc
mv -f ui_loc ${DESTFOLDER_IMG}

update_progressbar 90

logmsg "I" "update" "init scripts and standalone files"
# Almost done, copy init scripts and initialize it
# Move init script
mv -f loc-init /etc/init.d/loc-init
# Make it runnable
chmod +x /etc/init.d/loc-init
# Add it to boot time
if [ ! -h /etc/rcS.d/S73loc-init ]
then
   ln -fs /etc/init.d/loc-init /etc/rcS.d/S73loc-init
fi 
mv -f loc-bind /opt/amazon/loc-bind
chmod +x /opt/amazon/loc-bind

/opt/amazon/loc-bind

logmsg "I" "update" "done"
update_progressbar 100

return 0
