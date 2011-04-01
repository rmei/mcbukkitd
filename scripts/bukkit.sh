#!/bin/bash
#!/bin/bash -vx
BUKKIT="craftbukkit.jar"
VM=1G
JAVA="java"
#function childpid {
#    local ppid=$$ ptn=$1 pid= pidfile=$2
#    until [ -n "${pid//[[:blank:]]}" ] ; do
#        usleep 100000
#        pid=`pgrep -P $ppid $ptn`
#    done
#    echo $pid >$pidfile
#}
cd "${0%/*}"

#childpid java ${PIDFILE:-${0##*/}.pid} &
#$JAVA -Xincgc -Xms${VM} -Xmx${VM} -jar "$BUKKIT" nogui
/usr/local/sbin/nohupd --nodaemon -f ${PIDFILE:-${0##*/}.pid} $JAVA -Xincgc -Xms${VM} -Xmx${VM} -jar "$BUKKIT" nogui
