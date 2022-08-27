System Pre-requisites:
------------------------
Download and Install ubuntu 20.04 or above version from the following link:
        https://ubuntu.com/download/desktop

Update Ubuntu
---------------
Run the following command on terminal:
        sudo apt-get update 

Install git:
-----------------
copy the following command on terminal:
        sudo apt-get install git

To clone the language communicator tool from github copy the following command and paste it on the terminal:
        git clone https://github.com/sukhada-sukhada/lc4eu

#Language Communicator
#Readme to generate English sentences using a USR csv input 
-------------------------------------------------------

Pre-requisites:
--------------
1. pydelphin needs to be installed in $HOME
2. Ace parser 0.34 version in $HOME
    (Note:  Link: http://sweaglesw.org/linguistics/ace/download/
       download ace-0.9.34-x86-64.tar.gz and erg-1214-x86-64-0.9.34.dat.bz2 from the above link. 
       Keep the erg-1214-x86-64-0.9.34.dat.bz2 in ACE directory and extract it.
	)
3. CLIPS
    1. Download zip file : (https://sourceforge.net/projects/clipsrules/files/CLIPS/6.40_Beta_1/clips_core_source_640.zip/download)
    2. copy the zip file in lc4eu folder
    3. unzip clips_core_source_640.zip

 
Set path::
-------------
Set pydelphin and language_communicator path in ~/.bashrc:
------------------------------------------------------------
Run following command to open the bashrc file:
        gedit ~/.bashrc
   OR
        vi ~/.bashrc

1. Copy and paste the following lines at the end of ~/.bashrc 

        export PYDELPHIN=$HOME/pydelphin
        export lang_comm=$HOME/lc4eu
        export PATH=$lang_comm/bin:$PATH

2. Save and close the ~/.bashrc file 
3. On terminal run following command:
        source ~/.bashrc

Compile:
-----------
Run the following commands on terminal:
        cd $lang_comm/clips_core_source_640/core
        make -f makefile
        mv clips $lang_comm/bin/


4. Run Language Communicator Tool:
--------
To Run:
Create a USR csv for a sentence or use an existing USR csv file from the folder "$HOME/lc4eu/verified_sent".
	 
Run the USR csv file using following command:
        bash lc.sh <path of the USR_csv> 
		(Note: USR csv filenames are stored as numbers)

        bash lc.sh $HOME/lc4eu/verified_sent/1
	
NOTE:
Intermediate output files are stored in a folder, inside the folder tmp_dir, named on input file name.
	(For example, the output of the above command is stored in: $HOME/lc4eu/tmp_dir/1/)
		
