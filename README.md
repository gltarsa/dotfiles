# Unix ~/bin and dotfiles
=======

Various configuration files, configurations and utility scripts that I keep in
my local `~/bin` and link into my home directory.  I use this to quickly
re-create my command line environment on new machines.  It has been used
profitably in a variety of Mac OS and Linux (Ubuntu, RHEL, ...) environments.

## Installation

These files will need to live in your `~/bin` directory and these instructions
assume that you do not have a `~/.bin` directory currently.  If you do, then
merging your contents with this is left as an exercise for the reader. :-)

```
git clone https://github.com/gltarsa/dotfiles.git
mv dotfiles bin
cd bin
bash ~/bin/homedir --help
bash ~/bin/homedir --all
```
Finally, start `vim` and execute the following comamnd to install all the vim
plugins:

```
:PluginInstall
```

## Dependencies
You will need to install [Universal
Ctags](https://github.com/universal-ctags/ctags) aka (Exuberant Ctags) in order
for the vim Vundle plugin for easy-tags to work.  For the mac: `brew ctags` is
sufficient.  If you don't want this feature, then remove the "easytags" line
from the `~/.vimrc` file.

Non-Mac OS X users: consider using
[Linuxbrew](https://github.com/Linuxbrew/linuxbrew) for your local
configuration manager.


