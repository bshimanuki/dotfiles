set spell
set formatprg=clang-format
let g:pyclewn_args="--prefix=L"
nmap <C-F9> :w <CR>:make %:r CXXFLAGS:="-Wall -g" <CR>
nmap <C-F10> :!%:r <CR>
nmap <C-F11> :Pyclewn<CR>:Lfile %:r<CR>:Lmapkeys<CR>

"make and run
command! CXX make %:r CXXFLAGS:="-g -Wall -Wextra -std=c++1z"
command! CXXfast make %:r CXXFLAGS:="-O2 -Wall -Wextra -std=c++1z"
command! -nargs=* Crun !"%:p:r" <args>
