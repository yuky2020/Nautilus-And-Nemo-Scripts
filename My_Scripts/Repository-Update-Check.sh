#!/bin/bash
# created by unknown
# updated and tweaked by Inameiname (11 October 2011)
#Dependency check
	DEPENDENCIES="zenity curl"
	for dep in $DEPENDENCIES
	do
		which $dep &> /dev/null
		if [ $? -ne '0' ]
		then
			echo "[ERR]: $dep Not Found in your path."
			exit
		fi
	done
#Cleans last usage
	OLD_FILES="repositories"
	for old in $OLD_FILES
	do
		if [ -f /tmp/$old ];
		then
			rm -fv -R /tmp/$old
		fi
	done
#Lists release, repos
	myrelease=$(grep 'DISTRIB_CODENAME' /etc/lsb-release | sed 's/DISTRIB_CODENAME=//' | head -1)
	#myrelease="saucy"
	repo_clean=$(ls /etc/apt/sources.list.d/ | grep -v .save)
	repo_list=$(cd /etc/apt/sources.list.d && cat $repo_clean /etc/apt/sources.list | grep deb\ http.* | sed -e 's/.*help\.ubuntu\.com.*//' -e 's/^#.*//' -e 's/deb\ //' -e 's/deb-src\ //' -e '/^$/d' | sort -u | awk '{print $1"|"$2}' | sed -e 's/\/|/|/' -e 's/-[a-z]*$//' | uniq && cd)
	#repo_list=$(cat dummy.sources.list | grep deb\ http.* | sed -e 's/.*help\.ubuntu\.com.*//' -e 's/^#.*//' -e 's/deb\ //' -e 's/deb-src\ //' -e '/^$/d' | sort -u | awk '{print $1"|"$2}' | sed -e 's/\/|/|/' -e 's/-[a-z]*$//' | uniq && cd)
	count_repos=$(echo $repo_list | wc -w)
	check_progress=$count_repos
	release_14="trusty"
	release_13="saucy"
	release_12="raring"
	release_11="quantal"
	release_10="precise"
	release_9="oneiric"
	release_8="natty"
	release_7="maverick"
	release_6="lucid"
	release_5="karmic"
	release_4="jaunty"
	release_3="intrepid"
	release_2="hardy"
	release_1="gutsy"
#Checks
	{
	for repo_0 in $repo_list
	        do
		repo="$(echo $repo_0 | sed 's/|.*//')"
		rir="$(echo $repo_0 | sed 's/.*|//')"
	        rir_list=$(curl --silent $repo/dists/ | grep -oi href\=\"[^\/].*/\" | sed -e 's/href\=\"//i' -e 's/\/\"//' -e 's/-.*//' -e 's/\ NAME.*//i' | sort -u | uniq)
		if [ '$rir_list' = '' ]
		then
			rir_list=$(curl --silent $repo/ | grep -oi href\=\"[^\/].*\" | sed -e 's/href\=\"//i' -e 's/\/\"//' -e 's/-.*//' -e 's/\ NAME.*//i' -e 's/\/index\.html\"//' -e 's/.*".*//' -e 's/http.*//' | sort -u | uniq)
		fi
		#(I guess one will find something more elegant here)
		if [ $(echo "$rir_list" | grep -o $myrelease) ]
	        then
	                echo "$myrelease " >> /tmp/repositories
	        fi
		if [ '$rir_list' = '' ]
		then
			echo "$myrelease " >> /tmp/repositories
		fi
	        if [ $(echo "$rir_list" | grep -oi $release_14) ]
	        then
	                r14="yes"
	                else
	                r14="no"
	        fi
	        if [ $(echo "$rir_list" | grep -oi $release_13) ]
	        then
	                r13="yes"
	                else
	                r13="no"
	        fi
	        if [ $(echo "$rir_list" | grep -oi $release_12) ]
	        then
	                r12="yes"
	                else
	                r12="no"
	        fi
	        if [ $(echo "$rir_list" | grep -oi $release_11) ]
	        then
	                r11="yes"
	                else
	                r11="no"
	        fi
	        if [ $(echo "$rir_list" | grep -oi $release_10) ]
	        then
	                r10="yes"
	                else
	                r10="no"
	        fi
	        if [ $(echo "$rir_list" | grep -oi $release_9) ]
	        then
	                r9="yes"
	                else
	                r9="no"
	        fi
	        if [ $(echo "$rir_list" | grep -oi $release_8) ]
	        then
	                r8="yes"
	                else
	                r8="no"
	        fi
	        if [ $(echo "$rir_list" | grep -oi $release_7) ]
	        then
	                r7="yes"
	                else
	                r7="no"
	        fi
	        if [ $(echo "$rir_list" | grep -oi $release_6) ]
	        then
	                r6="yes"
	                else
	                r6="no"
	        fi
	        if [ $(echo "$rir_list" | grep -oi $release_5) ]
		then
	                r5="yes"
	        	else
	                r5="no"
	        fi
	        if [ $(echo "$rir_list" | grep -oi $release_4) ]
		then
	                r4="yes"
	        	else
	                r4="no"
	        fi
	        if [ $(echo "$rir_list" | grep -oi $release_3) ]
		then
	                r3="yes"
	        	else
	                r3="no"
	        fi
	        if [ $(echo "$rir_list" | grep -oi $release_2) ]
		then
	                r2="yes"
	        	else
	                r2="no"
	        fi
	        if [ $(echo "$rir_list" | grep -oi $release_1) ]
		then
	                r1="yes"
	        	else
	                r1="no"
	        fi
		#results
		if [ "$rir" = "$release_14" ]
		then
			results="$repo [$r14] $r13 $r12 $r11 $r10 $r9 $r8 $r7 $r6 $r5 $r4 $r3 $r2 $r1"
		elif [ "$rir" = "$release_13" ]
		then
			results="$repo $r14 [$r13] $r12 $r11 $r10 $r9 $r8 $r7 $r6 $r5 $r4 $r3 $r2 $r1"
		elif [ "$rir" = "$release_12" ]
		then
			results="$repo $r14 $r13 [$r12] $r11 $r10 $r9 $r8 $r7 $r6 $r5 $r4 $r3 $r2 $r1"
		elif [ "$rir" = "$release_11" ]
		then
			results="$repo $r14 $r13 $r12 [$r11] $r10 $r9 $r8 $r7 $r6 $r5 $r4 $r3 $r2 $r1"
		elif [ "$rir" = "$release_10" ]
		then
			results="$repo $r14 $r13 $r12 $r11 [$r10] $r9 $r8 $r7 $r6 $r5 $r4 $r3 $r2 $r1"
		elif [ "$rir" = "$release_9" ]
		then
			results="$repo $r14 $r13 $r12 $r11 $r10 [$r9] $r8 $r7 $r6 $r5 $r4 $r3 $r2 $r1"
		elif [ "$rir" = "$release_8" ]
		then
			results="$repo $r14 $r13 $r12 $r11 $r10 $r9 [$r8] $r7 $r6 $r5 $r4 $r3 $r2 $r1"
		elif [ "$rir" = "$release_7" ]
		then
			results="$repo $r14 $r13 $r12 $r11 $r10 $r9 $r8 [$r7] $r6 $r5 $r4 $r3 $r2 $r1"
		elif [ "$rir" = "$release_6" ]
		then
			results="$repo $r14 $r13 $r12 $r11 $r10 $r9 $r8 $r7 [$r6] $r5 $r4 $r3 $r2 $r1"
		elif [ "$rir" = "$release_5" ]
		then
			results="$repo $r14 $r13 $r12 $r11 $r10 $r9 $r8 $r7 $r6 [$r5] $r4 $r3 $r2 $r1"
		elif [ "$rir" = "$release_4" ]
		then
			results="$repo $r14 $r13 $r12 $r11 $r10 $r9 $r8 $r7 $r6 $r5 [$r4] $r3 $r2 $r1"
		elif [ "$rir" = "$release_3" ]
		then
			results="$repo $r14 $r13 $r12 $r11 $r10 $r9 $r8 $r7 $r6 $r5 $r4 [$r3] $r2 $r1"
		elif [ "$rir" = "$release_2" ]
		then
			results="$repo $r14 $r13 $r12 $r11 $r10 $r9 $r8 $r7 $r6 $r5 $r4 $r3 [$r2] $r1"
		elif [ "$rir" = "$release_1" ]
		then
			results="$repo $r14 $r13 $r12 $r11 $r10 $r9 $r8 $r7 $r6 $r5 $r4 $r3 $r2 [$r1]"
		else
			echo "$myrelease " >> /tmp/repositories
			results="$repo [yes] [yes] [yes] [yes] [yes] [yes] [yes] [yes] [yes] [yes] [yes] [yes] [yes] [yes]"

		fi
		#finds status and stores results
 		if [ $(echo "$results" | grep -o "\[no\]" | uniq) ]
	        then
	                status="Error"
		fi
	        if [ $(echo "$results" | grep -o "\[yes\]" | uniq) ]
		then
	                status="Ok"
		fi
#		if [ $(echo "$results" | grep -o "\[yes\]" | uniq) ] && [ "$rir" \< "$myrelease" ] && [ -n $(echo "$results" | grep -o "\[yes\]\ \[yes\]\ \[yes\]\ \[yes\]\ \[yes\]\ \[yes\]\ \[yes\]\ \[yes\]\ \[yes\]\ \[yes\]\ \[yes\]\ \[yes\]\ \[yes\]\ \[yes\]" | uniq) ] && [ echo "rir_list" | $(awk '{print $14 $13 $12 $11 $10 $9 $8 $7 $6 $5 $4 $3 $2 $1}' | grep $myrelease) ]
#		then
#			status="Upgradeable"
#		fi
#		if [ $(echo "$results" | grep -o "\[yes\]" | uniq) ] && [ "$rir" \> "$myrelease" ] && [ -n $(echo "$results" | grep -o "\[yes\]\ \[yes\]\ \[yes\]\ \[yes\]\ \[yes\]\ \[yes\]\ \[yes\]\ \[yes\]\ \[yes\]\ \[yes\]\ \[yes\]\ \[yes\]\ \[yes\]\ \[yes\]" | uniq) ] && [ echo "rir_list" | $(awk '{print $14 $13 $12 $11 $10 $9 $8 $7 $6 $5 $4 $3 $2 $1}' | grep $myrelease) ]
#		then
#			status="Downgradeable"
#	        fi
		#TODO should be $status $repo $r14 $r13 $r12 $r11 $r10 $r9 $r8 $r7 $r6 $r5 $r4 $r3 $r2 $r1
		echo "$status $results" >> /tmp/repositories
		#Zenity progressbar
        	percent=$((100-$check_progress*100/$count_repos))
        	check_progress=$(($check_progress-1))
        	echo $percent
		done
	} | zenity --progress --percentage=0 --title="Repositories" --text="Scanning repositories..." --auto-close
#Displays nicely
	if [ "$(cat /tmp/repositories | grep -c $myrelease)" = "$count_repos" ]
	then
		zeni_text="All the repositories you use support the $myrelease release."
	elif [ "$(cat /tmp/repositories | grep -c $myrelease)" = "1" ]
	then
		zeni_text="Only $(cat /tmp/repositories | grep -c $myrelease) of your $count_repos activated repositories supports the $myrelease release."
	else
		zeni_text="$(($count_repos - $(cat /tmp/repositories | grep -c $myrelease))) of your $count_repos activated repositories don't support the $myrelease release."
	fi
	if [ "$((100+$count_repos*25))" -gt "600" ]
	then
		window_height="600"
	else
		window_height="$((100+$count_repos*22))"
	fi
	zenity --title "Repositories" --text "$zeni_text" --width 800 --height $window_height --list --column "Status" --column "Repository" --column "$release_14" --column "$release_13" --column "$release_12" --column "$release_11" --column "$release_10" --column "$release_9" --column "$release_8" --column "$release_7" --column "$release_6" --column "$release_5" --column "$release_4" --column "$release_3" --column "$release_2" --column "$release_1" $(cat /tmp/repositories | sed s/$myrelease//)
