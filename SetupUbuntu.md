First, install the dependencies:
```
sudo apt-get install python2.7 python2.7-dev python-setuptools python-twisted mercurial gcc g++ zope.interface
sudo python -m easy_install cython
sudo python -m easy_install pil
sudo python -m easy_install jinja2
```

Optionally, install screen and pygeoip:
```
sudo apt-get install screen
sudo python -m easy_install pygeoip
```

Then clone the repository:
```
hg clone https://code.google.com/p/pysnip/
cd pysnip
sh build.sh
```
Edit the configuration:
```
cd feature_server
nano config.txt
```

Then, to run the server, either:
```
sh run_server.sh
```

or if you installed screen:

```
screen sh run_server.sh
```