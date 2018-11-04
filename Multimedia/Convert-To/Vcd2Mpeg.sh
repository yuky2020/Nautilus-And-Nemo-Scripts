#!/bin/bash
# Made by ioccatflashdancedotcx
# Version 1.6, Thu Aug  4 00:43:44 CEST 2005

if [ -n "$(ls 2>/dev/null *001|grep *001)" ]; then
                rar x *01.rar
		if [ -n "$(ls 2>/dev/null *bin)" ]; then
                	for i in *bin ; do vcdxrip -p --bin-file="$i" ; done
                	mv *mpg cd.mpg
               		rm *cue *bin *.xml _cdi_cdi_* _extra_svcdinfo.txt &>/dev/null
		fi
fi

if [ -n "$(ls 2>/dev/null *01.rar|grep *01.rar)" ]; then
                rar x *01.rar
		if [ -n "$(ls 2>/dev/null *bin)" ]; then
                	for i in *bin ; do vcdxrip -p --bin-file="$i" ; done
                	mv *mpg cd.mpg
               		rm *cue *bin *.xml _cdi_cdi_* _extra_svcdinfo.txt &>/dev/null
		fi
fi

if [ -n "$(ls 2>/dev/null *.rar|grep *.rar)" ]; then
                rar x *rar
		if [ -n "$(ls 2>/dev/null *bin)" ]; then
	                for i in *bin ; do vcdxrip -p --bin-file="$i" ; done
	                mv *mpg cd.mpg
               		rm *cue *bin *.xml _cdi_cdi_* _extra_svcdinfo.txt &>/dev/null
		fi
fi

for cddir in CD1 CD2 CD3 CD4 CD5 CD6 Cd1 Cd2 Cd3 Cd4 Cd5 Cd6 cd1 cd2 cd3 cd4 cd5 cd6; do

if cd ${cddir} &>/dev/null; then

	if [ -n "$(ls 2>/dev/null *001|grep *001)" ]; then
		rar x *001
		if [ -n "$(ls 2>/dev/null *bin)" ]; then
			for i in *bin ; do vcdxrip -p --bin-file="$i" ; done
				if [ -n "$(ls 2>/dev/null avseq02.mpg)" ]; then
					rm avseq01.mpg
				fi
			mv *mpg ../${cddir}.mpg
               		rm *cue *bin *.xml _cdi_cdi_* _extra_svcdinfo.txt &>/dev/null
			cd ..
			for i in ${cddir}.mpg ; do mv -- $i `echo $i|tr A-Z a-z` ; done
		elif [ -n "$(ls 2>/dev/null *mpg)" ]; then
			mv *mpg ../${cddir}.mpg
			cd ..
			for i in ${cddir}.mpg ; do mv -- $i `echo $i|tr A-Z a-z` ; done
		elif [ -n "$(ls 2>/dev/null *avi)" ]; then
				mv *avi ../${cddir}.avi
				cd ..
				for i in ${cddir}.avi ; do mv -- $i `echo $i|tr A-Z a-z` ; done
		fi

	else

	if [ -n "$(ls 2>/dev/null *01.rar|grep *01.rar)" ]; then
		rar x *01.rar
		if [ -n "$(ls 2>/dev/null *bin)" ]; then
			for i in *bin ; do vcdxrip -p --bin-file="$i" ; done
				if [ -n "$(ls 2>/dev/null avseq02.mpg)" ]; then
					rm avseq01.mpg
				fi
			mv *mpg ../${cddir}.mpg
               		rm *cue *bin *.xml _cdi_cdi_* _extra_svcdinfo.txt &>/dev/null
			cd ..
			for i in ${cddir}.mpg ; do mv -- $i `echo $i|tr A-Z a-z` ; done
		elif [ -n "$(ls 2>/dev/null *mpg)" ]; then
			mv *mpg ../${cddir}.mpg
			cd ..
			for i in ${cddir}.mpg ; do mv -- $i `echo $i|tr A-Z a-z` ; done
		elif [ -n "$(ls 2>/dev/null *avi)" ]; then
				mv *avi ../${cddir}.avi
				cd ..
				for i in ${cddir}.avi ; do mv -- $i `echo $i|tr A-Z a-z` ; done
		fi

	else

	if [ -n "$(ls 2>/dev/null *.rar|grep *.rar)" ]; then
		rar x *rar
		if [ -n "$(ls 2>/dev/null *bin)" ]; then
			for i in *bin ; do vcdxrip -p --bin-file="$i" ; done
				if [ -n "$(ls 2>/dev/null avseq02.mpg)" ]; then
					rm avseq01.mpg
				fi
			mv *mpg ../${cddir}.mpg
               		rm *cue *bin *.xml _cdi_cdi_* _extra_svcdinfo.txt &>/dev/null
			cd ..
			for i in ${cddir}.mpg ; do mv -- $i `echo $i|tr A-Z a-z` ; done
		elif [ -n "$(ls 2>/dev/null *mpg)" ]; then
				mv *mpg ../${cddir}.mpg
				cd ..
				for i in ${cddir}.mpg ; do mv -- $i `echo $i|tr A-Z a-z` ; done
		elif [ -n "$(ls 2>/dev/null *avi)" ]; then
				mv *avi ../${cddir}.avi
				cd ..
				for i in ${cddir}.avi ; do mv -- $i `echo $i|tr A-Z a-z` ; done
		fi
	fi
	fi
	fi
fi
done

