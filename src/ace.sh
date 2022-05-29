$HOME/ace-0.9.34/ace -g $HOME/ace-0.9.34/erg-1214-x86-64-0.9.34.dat -1TF $1 >$*.out
cp $*.out .1.tmp
sed -f substitution-commands.txt .1.tmp > $*.out

