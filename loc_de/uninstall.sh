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

    [ "$_MSG_LEVEL" != "D" ] && echo "ota_install: $_MSG_LEVEL def:$_MSG_COMP:$_NVPAIRS:$_FREETEXT"
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

# unmounting
[ -d $DESTFOLDER_BLT ] && umount $ORIGFOLDER_BLT
update_progressbar 10

[ -d $DESTFOLDER_LIB ] && umount $ORIGFOLDER_LIB
update_progressbar 20

[ -d $DESTFOLDER_IMG ] && umount $ORIGFOLDER_IMG
update_progressbar 30

[ -f $DESTFOLDER_CNF/msp_prefs     ] && umount $ORIGFOLDER_CNF/msp_prefs
[ -f $DESTFOLDER_CNF/browser_prefs ] && umount $ORIGFOLDER_CNF/browser_prefs
[ -f $DESTFOLDER_CNF/reader.conf   ] && umount $ORIGFOLDER_CNF/reader.conf
update_progressbar 40

# and deleting
[ -d $DESTFOLDER_BLT ] && rm -rf $DESTFOLDER_BLT
update_progressbar 50

[ -d $DESTFOLDER_LIB ] && rm -rf $DESTFOLDER_LIB
update_progressbar 60

[ -d $DESTFOLDER_IMG ] && rm -rf $DESTFOLDER_IMG
update_progressbar 75

# deleting all config files
[ -d $DESTFOLDER_CNF ] && rm -rf $DESTFOLDER_CNF
update_progressbar 70

[ -f /opt/amazon/loc-bind ] && rm -f /opt/amazon/loc-bind
update_progressbar 80

[ -f /etc/init.d/loc-init  ] && rm -f /etc/init.d/loc-init
update_progressbar 85

[ -h /etc/rcS.d/S73loc-init  ] && rm -f /etc/rcS.d/S73loc-init
update_progressbar 90

[ -d /mnt/us/localization  ] && rm -rf /mnt/us/localization

logmsg "I" "update" "done"
update_progressbar 100

return 0
