export ZDOTDIR=~/.zsh
export fpath=($fpath ${ZDOTDIR:-$HOME}/.zfunc)
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
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib
export CXXFLAGS="${CXXFLAGS} -std=c++1z"

## Cuda
export CUDA_HOME=/usr/local/cuda
export PATH=${PATH}:$CUDA_HOME/bin
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$CUDA_HOME/lib64:$CUDA_HOME/extras/CUPTI/lib64:/usr/lib/nvidia-390

## Java
export ECLIPSE_HOME=/opt/eclipse
export CLASSPATH=${CLASSPATH}:.:bin:lib/\*:/usr/share/java/\*

## Python
export PYTHONSTARTUP=~/.python/pythonrc.py
export WORKON_HOME=~/.python/venv
export VIRTUALENVWRAPPER_PYTHON=python3
export PIP_VIRTUALENV_BASE=$WORKON_HOME
# source virtualenvwrapper.sh in .zprofile

# Check system environmental variables in /etc/environment
