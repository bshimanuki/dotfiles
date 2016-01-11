export ZDOTDIR=~/.zsh
skip_global_compinit=1

# Custom Environmental Variables
export PATH=${PATH}:~/bin
export EDITOR=vim

## Android
export PATH=${PATH}:/opt/android-studio/sdk/tools
export PATH=${PATH}:/opt/android-studio/sdk/platform-tools
export PATH=${PATH}:/opt/android-studio/bin
export ANDROID_HOME=/opt/android-studio/sdk

## C++
export LD_LIBRARY_PATH=/usr/local/lib

## Java
export ECLIPSE_HOME=/opt/eclipse
export CLASSPATH=.:bin:lib/\*:/usr/share/java/\*

## Python
export PYTHONSTARTUP=~/.python/pythonrc.py
export WORKON_HOME=~/.python/venv
export VIRTUALENVWRAPPER_PYTHON=python3
export PIP_VIRTUALENV_BASE=$WORKON_HOME
# source virtualenvwrapper.sh in .zprofile

# Check system environmental variables in /etc/environment
