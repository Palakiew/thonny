#!/bin/bash

set -e

PREFIX=$HOME/pythonny



# prepare working folder
rm -rf build
TARGET_DIR=build/thonny
mkdir -p $TARGET_DIR




# copy files
cp -r $PREFIX/* $TARGET_DIR
cp install.py $TARGET_DIR/install.py
cp install.sh $TARGET_DIR/install

mkdir -p $TARGET_DIR/templates
cp uninstall.sh $TARGET_DIR/templates
cp Thonny.desktop $TARGET_DIR/templates

export LD_LIBRARY_PATH=$TARGET_DIR/lib

# INSTALL THONNY ###################################
$TARGET_DIR/bin/python3.5 -m pip install --pre --no-cache-dir thonny

# INSTALL EASYGUI (TODO: temp) ###################################
$TARGET_DIR/bin/python3.5 -m pip install --no-cache-dir easygui

VERSION=$(<$TARGET_DIR/lib/python3.5/site-packages/thonny/VERSION)
ARCHITECTURE="$(uname -m)"
VERSION_NAME=thonny-$VERSION-$ARCHITECTURE 

# override thonny launcher
rm $TARGET_DIR/bin/thonny
cp thonny $TARGET_DIR/bin


# clean up unnecessary stuff
rm -rf $TARGET_DIR/share
rm -rf $TARGET_DIR/man
rm -rf $TARGET_DIR/openssl/man
rm -rf $TARGET_DIR/include/openssl

rm -rf $TARGET_DIR/bin/python3.5m # too big
rm -rf $TARGET_DIR/bin/openssl
rm -rf $TARGET_DIR/bin/*z*
rm -rf $TARGET_DIR/bin/c_rehash
rm -rf $TARGET_DIR/bin/2to3*
rm -rf $TARGET_DIR/bin/idle*
rm -rf $TARGET_DIR/bin/pip* # TODO: don't delete but replace shebang
rm -rf $TARGET_DIR/bin/pydoc*
rm -rf $TARGET_DIR/bin/pyvenv*
rm -rf $TARGET_DIR/bin/tclsh*
rm -rf $TARGET_DIR/bin/wish*


#find $TARGET_DIR -type f -name "*.a" -delete
find $TARGET_DIR -type f -name "*.pyo" -delete
find $TARGET_DIR -type f -name "*.pyc" -delete
find $TARGET_DIR -type d -name "__pycache__" -delete

rm -rf $TARGET_DIR/lib/python3.5/ensurepip
#rm -rf $TARGET_DIR/include
#rm -rf $TARGET_DIR/lib/python3.5/config-3.5m
#rm -rf $TARGET_DIR/lib/python3.5/site-packages/pip*
#rm -rf $TARGET_DIR/lib/python3.5/site-packages/setuptools*

rm -rf $TARGET_DIR/lib/python3.5/site-packages/tkinterhtml/tkhtml/Windows
rm -rf $TARGET_DIR/lib/python3.5/site-packages/tkinterhtml/tkhtml/MacOSX

# copy licenses
cp ../../*LICENSE.txt $TARGET_DIR

# put it together
mkdir -p dist
tar -cvzf dist/$VERSION_NAME.tar.gz -C build thonny

