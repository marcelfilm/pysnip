# Building from source on OS X #

NOTE: This guide was written for 10.6 (Snow Leopard), but other versions should be very similar.

  * Install [Apple Xcode](http://developer.apple.com/xcode/)
> Xcode is available for free, but requires a developer account.  For 10.6, you'll need to get Xcode 3, but if you're running 10.7, you can get Xcode 4.

NOTE: Xcode is a VERY large download, roughly 4GB.  It will take a while to download.

  * Install [Python](http://python.org/download/releases/2.7.2)

  * Download [setuptools](http://pypi.python.org/packages/2.7/s/setuptools/setuptools-0.6c11-py2.7.egg)

  * Install setuptools by opening Terminal, navigating to where you saved the .egg file, and typing:

```
sh setuptools-0.6c11-py2.7.egg 
```

NOTE: You'll need to type the .egg file name exactly.  An easy way of doing this is to type "sh setuptools" and then press tab.  Assuming there isn't more than one file in your current directory starting with "setuptools", it will fill in the rest of the file name for you.

  * Install Twisted from Terminal by typing:
```
easy_install twisted
```

  * Install zope.interface from Terminal by typing:
```
easy_install zope.interface
```

  * Install Cython from Terminal by typing:
```
easy_install cython
```

  * Download and install [Mercurial](http://mercurial.selenic.com/downloads/)

  * In Terminal, navigate to an appropriate directory (where you'd like to download pysnip to) and type this:

```
hg clone https://pysnip.googlecode.com/hg/ pysnip
```

  * REBOOT! (this step probably isn't needed, but it's not a bad idea)

  * In Terminal, type: (to change to the pysnip directory)
```
cd pysnip
```

  * Then type: (to build pysnip)
```
./build.sh
```

NOTE: You may see several warnings/errors, this is normal.

  * Edit the config.txt in the feature\_server folder
> NOTE: There will only be config.txt.default in the folder before you run it.  You can either rename it to config.txt and edit it, or run it as is, and it will create the config.txt for you.

  * In Terminal, type: (to start the server)
```
sh run_server.sh
```

Done!

If you have any problems, ask on #buildandshoot: http://webchat.quakenet.org/?channels=%23buildandshoot