setlocal spell
let b:pyclewn_args="--prefix=L"
nmap <C-F9> :w<CR>:CXX<CR>
nmap <C-F10> :Crun<CR>
nmap <C-F11> :Pyclewn<CR>:Lfile %:r<CR>:Lmapkeys<CR>

"make and run
command! CXX make %:r CXXFLAGS:="-g -Wall -Wextra -std=c++1z"
command! CXXfast make %:r CXXFLAGS:="-O3 -Wall -Wextra -std=c++1z"
command! -nargs=* Crun !"%:p:r" <args>
