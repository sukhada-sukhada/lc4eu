#to run: python3 wx-hin.py <INPUT_file_in_WX>

import sys
from wxconv import WXC
f = open(sys.argv[1], 'r')
fr = f.read()
con = WXC(order='wx2utf', lang='hin')
print(con.convert(fr))
