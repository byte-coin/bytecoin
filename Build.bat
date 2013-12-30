
rem The script to make bytecoin installer.

svn up
SubWCRev . src/clientversion.h.in src/clientversion.h -f
SubWCRev . src/version.cpp.in src/version.cpp -f

cd src
mingw32-make -f makefile.mingw
strip bytecoind.exe
copy /Y bytecoind.exe ..\release\
cd ..

del build\bitcoin-qt_res.o
qmake bytecoin-qt.pro
mingw32-make -f Makefile.Release

cd share
SubWCRev .. setup.nsi setup.release.nsi -f
makensis setup.release.nsi
del setup.release.nsi
cd ..