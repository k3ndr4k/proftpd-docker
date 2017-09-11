#!/bin/sh

cat > /etc/proftpd/sql.conf <<EOH
<Global>
<IfModule mod_sql.c>
SQLBackend      postgres
SQLEngine       on
SQLLogFile      /var/log/proftpd/sql.log
SQLAuthenticate users userset groups groupset
SQLAuthTypes    Crypt
SQLConnectInfo  ${FTP_DB_NAME}@${FTP_DB_HOST} ${FTP_DB_USER} ${FTP_DB_PASS}
SQLUserInfo     ftp.users userid passwd uid gid homedir shell
SQLGroupInfo    ftp.groups groupname gid members
SQLDefaultUID   $(id -u ftp)
SQLDefaultGID   $(id -g ftp)
</IfModule>
</Global>
EOH

cat > /etc/proftpd/sftp.conf <<EOH
<IfModule mod_sftp.c>
<VirtualHost $(hostname)>
Port 23
SFTPEngine on
SFTPLog /var/log/proftpd/sftp.log
SFTPAuthMethods password
SFTPOptions IgnoreSFTPSetPerms IgnoreSFTPUploadPerms IgnoreSFTPSetTimes
SFTPHostKey /etc/ssh/ssh_host_dsa_key
SFTPHostKey /etc/ssh/ssh_host_rsa_key
SFTPHostKey /etc/ssh/ssh_host_ecdsa_key
</VirtualHost>
</IfModule mod_sftp.c>
EOH

exec /usr/sbin/proftpd --nodaemon
