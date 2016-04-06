# Building from source on Win32 #

NOTE: x86 and 32-bit are interchangeable, and if given the option, you should always be installing the 32-bit/x86 versions of these files.

  * Install [Python](http://python.org/download/releases/2.7.2), then add this to your PATH:

```
C:\Python27
```

(if you installed python somewhere else, enter that instead)

  * Install [Twisted for Python 2.7](http://pypi.python.org/packages/2.7/T/Twisted/Twisted-11.0.0.winxp32-py2.7.msi#md5=edc63d41222fdb9ef4545ee33931eca0)
  * Install [setuptools](http://pypi.python.org/pypi/setuptools)
  * Click Start -> Run -> cmd and press Enter to get to the command prompt.  Once at the command prompt, type the following and press enter to install zope.interface:
```
python -m easy_install zope.interface
```

  * Install [MinGW32](http://sourceforge.net/projects/mingw/files/Installer/mingw-get-inst/mingw-get-inst-20110530/mingw-get-inst-20110530.exe/download)

> During installation, at the screen titled "Select Components", ensure that "C++ Compiler" is checked.

After MinGW is installed and has finished downloading/installing the necessary packages, add these to your PATH:

```
C:\MinGW\bin\
C:\MinGW\lib\gcc\mingw32\4.5.2\
```

  * Install [Cython](http://www.lfd.uci.edu/~gohlke/pythonlibs/#cython)
  * Install [Python Win32 Extensions](http://sourceforge.net/projects/pywin32/files/pywin32/Build216/pywin32-216.win32-py2.7.exe/download)
  * Open Windows Explorer (right click on the start button, click explore) and open the following file in notepad:
```
C:\Python27\Lib\distutils\cygwinccompiler.py
```
  * Using the find tool (control+f), search for "-mno-cygwin" (without quotes).  Delete all entries you find (there should be 4).
  * Download [Mercurial](http://mercurial.selenic.com/downloads/) and install it (it should ask you whether or not to automatically add it to your path, make sure that option is ticked).

  * REBOOT!

  * In a CMD, navigate to an appropriate directory (where you want the pysnip folder placed, it can go anywhere you'd like) and type this:
```
hg clone https://pysnip.googlecode.com/hg/ pysnip
```

  * Go to the new directory 'pysnip'
  * Run **build\_all\_mingw.bat**
> NOTE: You may see several warnings, this is normal.
  * Edit the config.txt in the feature\_server folder
> NOTE: There will only be config.txt.default in the folder before you run it.  You can either rename it to config.txt and edit it, or run it as is, and it will create the config.txt for you.
  * Run run\_server.bat

Done!

If you have any problems, ask on #buildandshoot: http://webchat.quakenet.org/?channels=%23buildandshoot

### Manipulating PATH ###
**Windows XP**: Start>Right Click My Computer>Advance>Enviroment Variables>Under System Variables look for "Path">Click it and hit edit>Go all the way right, add a semi-colin (;) and the path.

EX: (RANDOM PATHS);C:\Python27\

**Windows Vista/7**: Start>Right Click Computer>Advance System Settings>Click The "Advanced" Tab>Enviroment Variables>Under System Variables look for "Path">Click it and hit edit>Go all the way right, add a semi-colin (;) and the path.

EX: (RANDOM PATHS);C:\Python27\