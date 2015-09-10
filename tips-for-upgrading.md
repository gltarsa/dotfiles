# Before

* Get a list of all of the top-level packages you have installed with brew.

 ```brew leaves > installed.brew.pkgs.txt```
 
* re-install brew (per the [webpage](https://brew.sh))
* re-install all of the packages:

 ``` brew `cat installed.brew.pkgs.txt`
```

