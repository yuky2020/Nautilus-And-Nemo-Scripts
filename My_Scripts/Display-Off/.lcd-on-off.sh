#/bin/sh
OID='LVDS1'
STATE=`xrandr | grep $OID | grep -c "ted ("`
case $STATE in
'1')
xrandr --output $OID --auto
;;
'0')
xrandr --output $OID --off
;;
esac
