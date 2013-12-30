#!/bin/bash

svn up

VERSION=1.0.0

REVISION_CURRENT=`svn info --xml . | grep "revision" | awk 'END{print $NF}' | sed 's/revision="//' | sed 's/">//'`
REVISION_OLD=`grep CLIENT_VERSION_BUIL src/clientversion.h | awk -F" "  '{print $3}'`
MOD_TIME=`svn info --xml . | grep date | awk -F">" '{print $2}' | awk -F"Z" '{print $1}' | sed 's/T/ /'`
if [ "$REVISION_CURRENT" -ne "$REVISION_OLD"  ]; then
    sed "s/#define CLIENT_VERSION_BUILD.*/#define CLIENT_VERSION_BUILD       $REVISION_CURRENT/" -i src/clientversion.h
    sed "s/const std::string CLIENT_DATE(.*/const std::string CLIENT_DATE(\"$MOD_TIME\");/" -i src/version.cpp
fi

pushd src
make -f makefile.unix
strip bytecoind
popd

if [ ! -d bytecoin-build ]; then
    mkdir bytecoin-build
fi
pushd bytecoin-build
~/qt/qt-4.6.4-shared/bin/qmake ../bytecoin-qt.pro -r "CONFIG+=release"
make
popd

if [ ! -d bytecoin-release ]; then
    mkdir bytecoin-release
fi
pushd bytecoin-release
mkdir -p bytecoin-$VERSION.$REVISION_CURRENT-linux-x64/bin
cd bytecoin-$VERSION.$REVISION_CURRENT-linux-x64/bin
pwd
cp -a ../../../bytecoin-build/bytecoin-qt .
cp -a ../../../src/bytecoind .
cd ..
svn export -q http://192.168.7.1/svn/bytecoin/bytecoin/trunk src
cd ..
tar cjf bytecoin-$VERSION.$REVISION_CURRENT-linux-x64.tar.bz2 bytecoin-$VERSION.$REVISION_CURRENT-linux-x64




