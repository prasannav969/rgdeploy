#!/bin/bash
# Download the latest scripts
version='0.1.2'
echo "updatescripts.sh version: $version"
[ -z $RG_HOME ] && RG_HOME='/opt/deploy/sp2'
echo "RG_HOME=$RG_HOME"
[ -z $RG_SRC ] && RG_SRC='/home/ubuntu'
echo "RG_SRC=$RG_SRC"
echo "Fetching latest scripts"
aws s3 cp s3://rg-deployment-docs/scripts.tar.gz $RG_SRC
mkdir -p $RG_SRC/scripts
tar -xvf $RG_SRC/scripts.tar.gz -C $RG_SRC/scripts

echo "Fetching latest configs"
aws s3 cp s3://rg-deployment-docs/config.tar.gz $RG_SRC
tar --keep-newer-files -xvf $RG_SRC/config.tar.gz -C $RG_HOME
tar -xvf $RG_SRC/config.tar.gz -C $RG_SRC

grep -i 'version='  /usr/local/sbin/fix*.sh /usr/local/sbin/start_server.sh
# Check if any of the scripts are later versions than those present
# in the AMI
if [ ! -f /usr/local/sbin/fixips.sh ] ||  [ $RG_SRC/scripts/fixips.sh -nt /usr/local/sbin/fixips.sh ]; then
  echo "Found newer version of fixips.sh. Updating"
  cp $RG_SRC/scripts/fixips.sh  /usr/local/sbin/
fi

if [ ! -f /usr/local/sbin/fixmongo.sh ] ||  [ $RG_SRC/scripts/fixmongo.sh -nt /usr/local/sbin/fixmongo.sh ]; then
  echo "Found newer version of fixmongo.sh. Updating"
  cp $RG_SRC/scripts/fixmongo.sh  /usr/local/sbin/
fi

if [ ! -f /usr/local/sbin/fixconfigs.sh ] ||  [ $RG_SRC/scripts/fixconfigs.sh -nt /usr/local/sbin/fixconfigs.sh ]; then
  echo "Found newer version of fixconfigs.sh. Updating"
  cp $RG_SRC/scripts/fixconfigs.sh  /usr/local/sbin/
fi

if [ ! -f /usr/local/sbin/fixdocdb.sh ] ||  [ $RG_SRC/scripts/fixdocdb.sh -nt /usr/local/sbin/fixdocdb.sh ]; then
  echo "Found newer version of fixdocdb.sh. Updating"
  cp $RG_SRC/scripts/fixdocdb.sh  /usr/local/sbin/
fi

if [ ! -f /usr/local/sbin/fixsecrets.sh ] ||  [ $RG_SRC/scripts/fixsecrets.sh -nt /usr/local/sbin/fixsecrets.sh ]; then
  echo "Found newer version of fixsecrets.sh. Updating"
  cp $RG_SRC/scripts/fixsecrets.sh  /usr/local/sbin/
fi

if [ ! -f /usr/local/sbin/fixswarm.sh ] ||  [ $RG_SRC/scripts/fixswarm.sh -nt /usr/local/sbin/fixswarm.sh ]; then
  echo "Found newer version of fixswarm.sh. Updating"
  cp $RG_SRC/scripts/fixswarm.sh  /usr/local/sbin/
fi

if [ ! -f /usr/local/sbin/start_server.sh ] ||  [ $RG_SRC/scripts/start_server.sh -nt /usr/local/sbin/start_server.sh ]; then
  echo "Found newer version of start_server.sh. Updating"
  cp $RG_SRC/scripts/start_server.sh  /usr/local/sbin/
fi

if [ ! -f /usr/local/sbin/create_rg_admin_user.sh ] ||  [ $RG_SRC/scripts/create_rg_admin_user.sh -nt /usr/local/sbin/create_rg_admin_user.sh ]; then
  echo "Found newer version of create_rg_admin_user.sh. Updating"
  cp $RG_SRC/scripts/create_rg_admin_user.sh  /usr/local/sbin/
fi

grep -i 'version=' /usr/local/sbin/fix*.sh /usr/local/sbin/start_server.sh
rm -rf $RG_SRC/scripts
echo "Done updating scripts"
