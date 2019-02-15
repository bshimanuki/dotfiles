# allow local .gdbinit
set auto-load safe-path /

python
import os
import sys
sys.path.insert(0,os.path.expanduser('~/.gdb/pretty_printers'))
from stl_printers import register_libstdcxx_printers
register_libstdcxx_printers (None)
import boost_printers
boost_printers.register_printers()
# from libwx.v28.printers import register_libwx_printers
# register_libwx_printers (None)
end

source ~/.gdb/pwndbg/gdbinit.py
