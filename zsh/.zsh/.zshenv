export ZDOTDIR=~/.zsh
export fpath=("${ZDOTDIR:-$HOME}/.zfunc" "${fpath[@]}")
export skip_global_compinit=1

# Custom Environmental Variables
export PATH=${PATH}:~/bin
export EDITOR=vim

# fzf
export PATH=${PATH}:~/.vim/plugged/fzf/bin

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
export CUDA_PATH=${CUDA_HOME}
export PATH=${PATH}:${CUDA_HOME}/bin
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${CUDA_HOME}/lib64:${CUDA_HOME}/extras/CUPTI/lib64:/usr/lib/nvidia-390

## Java
export ECLIPSE_HOME=/opt/eclipse
export CLASSPATH=${CLASSPATH}:.:bin:lib/\*:/usr/share/java/\*

## Python
export PYENV_ROOT=~/.pyenv
export POETRY_ROOT=~/.poetry
export PATH=${PYENV_ROOT}/shims:${PATH}:${PYENV_ROOT}/bin:${POETRY_ROOT}/bin
export PYTHONSTARTUP=~/.python/pythonrc.py
export WORKON_HOME=~/.python/venv
export VIRTUALENVWRAPPER_PYTHON=python3
export PIP_VIRTUALENV_BASE=${WORKON_HOME}
# source virtualenvwrapper.sh in .zprofile

## Ruby
export RBENV_HOME=~/.rbenv
export PATH=${RBENV_HOME}/shims:${PATH}:${RBENV_HOME}/bin:${RBENV_HOME}/plugins/ruby-build/bin

if [ -n "$ZSH_ENV" ]; then source "$ZSH_ENV"; fi
