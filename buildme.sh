#!/bin/sh

# Script to build a UnifiedInstaller tarball
# By default the target built against is the ~/nobackup/work directory.
# You can optionally give the target as the first argument.
# packages should already be updated; particularly the
# build-cache tarball.

WORK_DIR=~/nobackup/work
if [ -n "$1" ]; then
  WORK_DIR=$1
fi

# wget or curl?
if [ -n "`which wget`" ]; then
  WGET='wget'
else
  echo "Using curl, because wget was not found"
  WGET='curl -O'
fi

# gnutar or tar?
if [ -n "`which gnutar`" ]; then
  TAR='gnutar'
else
  echo "Using tar, because gnutar was not found"
  echo "Warning: Using tar rather than gnutar may have unintended consequences."
  TAR='tar'
fi

BASE_VER=4.3.3
NEWVER=${BASE_VER}

PORTALMODELO_VER=3.0b1

SDIR=`pwd`

cd $WORK_DIR
rm -r PortalModelo-${PORTALMODELO_VER}-UnifiedInstaller PortalModelo-${PORTALMODELO_VER}-UnifiedInstaller.tgz

cd $SDIR
cp -R ${SDIR}/ $WORK_DIR/PortalModelo-${PORTALMODELO_VER}-UnifiedInstaller/
rm -rf $WORK_DIR/PortalModelo-${PORTALMODELO_VER}-UnifiedInstaller/.git
rm $WORK_DIR/PortalModelo-${PORTALMODELO_VER}-UnifiedInstaller/.gitignore
rm $WORK_DIR/PortalModelo-${PORTALMODELO_VER}-UnifiedInstaller/buildme.sh
rm $WORK_DIR/PortalModelo-${PORTALMODELO_VER}-UnifiedInstaller/preflight.ac
rm $WORK_DIR/PortalModelo-${PORTALMODELO_VER}-UnifiedInstaller/update_packages.py
rm $WORK_DIR/PortalModelo-${PORTALMODELO_VER}-UnifiedInstaller/to-do.txt
rm $WORK_DIR/PortalModelo-${PORTALMODELO_VER}-UnifiedInstaller/install.log
rm $WORK_DIR/PortalModelo-${PORTALMODELO_VER}-UnifiedInstaller/config.status
rm $WORK_DIR/PortalModelo-${PORTALMODELO_VER}-UnifiedInstaller/config.log
rm $WORK_DIR/PortalModelo-${PORTALMODELO_VER}-UnifiedInstaller/buildenv.sh
rm $WORK_DIR/PortalModelo-${PORTALMODELO_VER}-UnifiedInstaller/tests/testout.txt
rm -r $WORK_DIR/PortalModelo-${PORTALMODELO_VER}-UnifiedInstaller/PortalModelo-docs
rm -r $WORK_DIR/PortalModelo-${PORTALMODELO_VER}-UnifiedInstaller/autom4te.cache
rm $WORK_DIR/PortalModelo-${PORTALMODELO_VER}-UnifiedInstaller/packages/Python*

mkdir $WORK_DIR/PortalModelo-${PORTALMODELO_VER}-UnifiedInstaller
cd $WORK_DIR/PortalModelo-${PORTALMODELO_VER}-UnifiedInstaller


echo "Getting docs"
$WGET --no-check-certificate http://pypi.python.org/packages/source/P/Plone/Plone-${BASE_VER}.zip
unzip Plone-${BASE_VER}.zip
rm Plone-${BASE_VER}.zip
mv Plone-${BASE_VER}/docs Plone-docs
rm -r Plone-${BASE_VER}

find . -name "._*" -exec rm {} \;
find . -name ".DS_Store" -exec rm {} \;
find . -name "*.py[co]" -exec rm -f {} \;
find . -type f -exec chmod 644 {} \;
chmod 755 install.sh base_skeleton/bin/*
find . -type d -exec chmod 755 {} \;

cd $WORK_DIR
echo Making tarball
$TAR --owner 0 --group 0 -zcf PortalModelo-${PORTALMODELO_VER}-UnifiedInstaller.tgz PortalModelo-${PORTALMODELO_VER}-UnifiedInstaller
rm -r PortalModelo-${PORTALMODELO_VER}-UnifiedInstaller
echo Test unpack of tarball
$TAR zxf PortalModelo-${PORTALMODELO_VER}-UnifiedInstaller.tgz
cd PortalModelo-${PORTALMODELO_VER}-UnifiedInstaller
