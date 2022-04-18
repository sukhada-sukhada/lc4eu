System Pre-requisites:
------------------------
Download and Install ubuntu 20.04 from the below link (any version above 20.04 will work):
https://ubuntu.com/download/desktop

Update Ubuntu
---------------
Run the following command on terminal
  sudo apt-get update 

Install git:
-----------------
copy the following command on terminal:
sudo apt-get install git

To clone the language communicator tool from github copy the below command and paste on terminal:
git clone https://github.com/shastri0911/language_communicator.git

#language communicator
#Readme to generate english sentence using a CHL input 
-------------------------------------------------------

Pre-requisites:
--------------
1. pydelphin needs to be installed in $HOME/
2. Ace parser 0.34 version in $HOME/
    (Note:  Link: http://sweaglesw.org/linguistics/ace/download/
       download ace-0.9.34-x86-64.tar.gz and erg-1214-x86-64-0.9.34.dat.bz2 from the above link. 
       Keep the erg-1214-x86-64-0.9.34.dat.bz2 in ACE directory and extract it.
	)
3. Clips
    1. Download zip file : (https://sourceforge.net/projects/clipsrules/files/CLIPS/6.40_Beta_1/clips_core_source_640.zip/download)
    2. copy zip file in language_communicator folder
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
	export lang_comm=$HOME/language_communicator
	export PATH=$lang_comm/bin:$PATH

2. Save and quit the above file 
3. In terminal run following command.
	source ~/.bashrc

Compile:
-----------

a. cd $lang_comm/clips_core_source_640/core
b. make -f makefile
c. mv clips $lang_comm/bin/


4. RUN Language Communicator:
--------
How to Run:
1) generate a user csv for a sentence manually.
	{NOTE:THE FILES H_concept-to-mrs-rels.dat AND mrs-rel-features.dat SHOULD HAVE THE NECESSARY INFORMATION) 

2) Run the user csv file using following command:
     bash lc.sh <path of the user_csv> 
		(Note: user csv filenames are stored as numbers)
OR
    Run an existing user csv file using following command:
	bash lc.sh $HOME/language_communicator/verified_sent/1
	
	NOTE:
	**	Output is stored in the file name dir present inside tmp_dir
		(Ex: Output is stored in $HOME/language_communicator/tmp_dir/1/)
