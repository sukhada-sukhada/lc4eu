#to run: python3 hin-wx.py <INPUT_file_in_WX>
#prerequsite: pip install wxconv
import sys
from wxconv import WXC
f = open(sys.argv[1], 'r')
fr = f.read()
con = WXC(order='utf2wx')
print(con.convert(fr))
