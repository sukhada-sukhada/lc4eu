$HOME/ace-0.9.34/ace -g $HOME/ace-0.9.34/erg-1214-x86-64-0.9.34.dat -TF $1  > $*.out
cp $*.out $HOME/lc4eu/src/ace/.1.tmp
sed -f $HOME/lc4eu/src/ace/substitution-commands.txt $HOME/lc4eu/src/ace/.1.tmp > $*.out
