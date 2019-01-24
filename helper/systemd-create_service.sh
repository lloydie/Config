#!/bin/sh

# create systemd service
read -e -p "SVC_NAME=" SVC_NAME
read -e -p "SVC_USR=" -i "$SVC_NAME" SVC_USR
read -e -p "SVC_OPT=" SVC_OPT
read -e -p "EnvironmentFile=" SVC_ENV_FILE
read -e -p "ExecStart=" SVC_EXEC_START
read -e -p "WantedBy=" -i "multi-user.target" SVC_WANTED_BY

useradd $SVC_USR -s /sbin/nologin

cat <<EOF > "/etc/systemd/system/$SVC_NAME.service"
[Unit]
Description=$SVC_DESC

[Service]
User=$SVC_USER
EnvironmentFile=$SVC_ENV_FILE
ExecStart=$SVC_EXEC_START $OPTIONS

[Install]
WantedBy=$SVC_WANTED_BY
EOF

mkdir -v -p /etc/sysconfig

cat <<EOF > "/etc/sysconfig/$SVC_NAME"
OPTIONS=$SVC_OPT
EOF

systemctl daemon-reload
systemctl enable $SVC_NAME
systemctl start $SVC_NAME
systemctl status $SVC_NAME

