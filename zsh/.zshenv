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
export CUDA_PATH=$CUDA_HOME
export PATH=${PATH}:$CUDA_HOME/bin
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$CUDA_HOME/lib64:$CUDA_HOME/extras/CUPTI/lib64:/usr/lib/nvidia-390

## Java
export ECLIPSE_HOME=/opt/eclipse
export CLASSPATH=${CLASSPATH}:.:bin:lib/\*:/usr/share/java/\*

## Python
export PYENV_ROOT=~/.pyenv
export PATH=${PATH}:$PYENV_ROOT/bin
export PYTHONSTARTUP=~/.python/pythonrc.py
export WORKON_HOME=~/.python/venv
export VIRTUALENVWRAPPER_PYTHON=python3
export PIP_VIRTUALENV_BASE=$WORKON_HOME
# source virtualenvwrapper.sh in .zprofile

## Ruby
export RBENV_HOME=$HOME/.rbenv
export PATH=$RBENV_HOME/shims:${PATH}:$RBENV_HOME/bin:$RBENV_HOME/plugins/ruby-build/bin
