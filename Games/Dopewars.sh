#!/bin/bash

tty -s; if [ $? -ne 0 ]; then gnome-terminal -e "$0"; exit; fi

MENUINPUT="" # This is re-used for every 'read' input, so if you ever need to store it's contents outside of a loop you'll need to create more dedicated 'read' variables or store the input somewhere else.
BANK="0"
DAYCOUNTER="1" # The next day function sets this - never write to it, only read it!
BUYALLOW="1" # Set this to '0' to disable buying drugs. These serve no purpose (yet) other than to run the buy/sell/loan while loops infinetly until broken.
SELLALLOW="1" # Set this to '0' to disable selling drugs.
LOANALLOW="1" # Set this to '0' to disable taking out loans.

MAXCAPACITY="50" # Initial maximum capacity
USEDCAPACITY="" # Stores the total of all drug quantaties currently.
FREECAPACITY="" # Stores MAXCAPACITY-USEDCAPACITY. Lazy programming on my part...
TOTALWORTH=""

QUANTITY_CANNABIS="0" # Initial starting quantities!
QUANTITY_COCAINE="0"
QUANTITY_ECSTACY="0"
QUANTITY_HEROIN="0"
QUANTITY_LSD="0"
QUANTITY_PCP="0"
QUANTITY_SPEED="0"

BUYINGTEMP_CANNABIS="" # These need to be here because 'if' conditions are so shite they don't accept arithmetic. LATER NOTE: It's probably more that I don't know how to do it :-P.
BUYINGTEMP_COCAINE=""
BUYINGTEMP_ECSTACY=""
BUYINGTEMP_HEROIN=""
BUYINGTEMP_LSD=""
BUYINGTEMP_PCP=""
BUYINGTEMP_SPEED=""

PRICE_CANNABIS=$((RANDOM%9+3)) # Initial random prices!
PRICE_COCAINE=$((RANDOM%35+20))
PRICE_ECSTACY=$((RANDOM%90+60))
PRICE_HEROIN=$((RANDOM%3000+1500))
PRICE_LSD=$((RANDOM%800+700))
PRICE_PCP=$((RANDOM%1100+850))
PRICE_SPEED=$((RANDOM%450+250))

USERPRICE_CANNABIS="$PRICE_CANNABIS" # This needs something because a weighted average calculation is performed on it right away and will probably screw up if it's empty, so we assign the initial quantity with the initial random generated price.
USERPRICE_COCAINE="$PRICE_COCAINE"
USERPRICE_ECSTACY="$PRICE_ECSTACY"
USERPRICE_HEROIN="$PRICE_HEROIN"
USERPRICE_LSD="$PRICE_LSD"
USERPRICE_PCP="$PRICE_PCP"
USERPRICE_SPEED="$PRICE_SPEED"

LOANACTIVE="0"	# This is strictly turned on/off by the Loan/NewDay sections respectively.
LOANDAILYPAYMENT=""
LOANDURATIONDAYS=""

# This stuff is specifically executed before the main loop:

clear
echo "Welcome to 'BASHdeal'!"; echo

let USEDCAPACITY=$QUANTITY_CANNABIS	# You could manually enter this data into the variables above, but i'm too lazy so I just let it calculate the values the first time the game runs.
let FREECAPACITY=$MAXCAPACITY-$USEDCAPACITY

echo "*** To get started, you'll need to borrow some money with a loan. ***"; echo

# Main loop:

while [ $BANK -ge 0 ]; do
	echo "Day "$DAYCOUNTER". Your bank balance is currently \$"$BANK"."; echo
	echo "b - Buy drugs."
	echo "l - Take out a loan."
	echo "i - View your current inventory."
	echo "n - Go to the next day."
	echo "q - Quit the game."
	echo "s - Sell drugs."; echo
	read MENUINPUT
	case "$MENUINPUT" in
	"b" | "B" )										# 'Buy drugs' from main menu
		while [ $BUYALLOW -eq 1 ]; do
			clear
			echo "BUY DRUGS:"; echo
			echo "Current price of Cannabis: \$"$PRICE_CANNABIS"."
			echo "Current price of Cocaine: \$"$PRICE_COCAINE"."
			echo "Current price of Ecstacy: \$"$PRICE_ECSTACY"."
			echo "Current price of Heroin: \$"$PRICE_HEROIN"."
			echo "Current price of LSD: \$"$PRICE_LSD"."
			echo "Current price of PCP: \$"$PRICE_PCP"."; echo
			echo "a - Buy Cannabis."
			echo "c - Buy Cocaine."
			echo "e - Buy Ecstacy."
			echo "h - Buy Heroin."
			echo "l - Buy LSD."
			echo "p - Buy PCP."
			echo "s - Buy Speed."; echo
			echo "r - Return to main menu."; echo
			read MENUINPUT; echo
			case "$MENUINPUT" in
			"a" | "A" )								
				if [ $BANK -ge $PRICE_CANNABIS ]; then						# HOW THE BUY MODULE WORKS:
					echo "How much Cannabis would you like to buy? (Press any non-numeric key to cancel.)"; echo
					read MENUINPUT; echo
					if [[ $MENUINPUT == [1-9]* ]]; then					# Check whether read input is a number (and is more than 0)
						if [ $MENUINPUT -le $FREECAPACITY ]; then
							let BUYINGTEMP_CANNABIS=$PRICE_CANNABIS*$MENUINPUT		# Store the current price of Cannabis x the amount the user wants in BUYINGTEMP_CANNABIS
							if [ $BANK -ge $BUYINGTEMP_CANNABIS ]; then			# If the user has enough in the bank to buy the amount they want at the current price then...
								if [ $QUANTITY_CANNABIS -eq 0 ]; then		#	This is done because we don't want to perform the weighted average calc on an empty variable
									let USERPRICE_CANNABIS=$PRICE_CANNABIS	#	And if it IS empty, we simply assign it the current price.
								else
									USERPRICE_CANNABIS=$(( ( ( QUANTITY_CANNABIS * $USERPRICE_CANNABIS ) + ( $MENUINPUT * $PRICE_CANNABIS ) ) / ( $QUANTITY_CANNABIS + $MENUINPUT ) ))
								fi							
								let QUANTITY_CANNABIS=$QUANTITY_CANNABIS+$MENUINPUT	# Change the user quantity to the amount they want
								let BANK=$BANK-$PRICE_CANNABIS*$MENUINPUT		# Take the amount they bought x the current price out of their bank
								let USEDCAPACITY=$QUANTITY_CANNABIS+$QUANTITY_COCAINE+$QUANTITY_ECSTACY+$QUANTITY__HEROIN+$QUANTITY_LSD+$QUANTITY_PCP+$QUANTITY_SPEED	
								let FREECAPACITY=$MAXCAPACITY-$USEDCAPACITY # Work out free capacity - because we like to show the user their available free cap if they input too much!
								echo "You bought $MENUINPUT unit(s) of Cannabis."; echo
								echo "Press any key to return to the buy menu."; echo
								read MENUINPUT
								clear
							elif [ $BANK -lt $BUYINGTEMP_CANNABIS ]; then			# If they can't afford BUYINGTEMP_CANNABIS (amount they requested x current price) then...
								echo "You can't afford that much Cannabis!"; echo
								echo "Press any key to return to the buy menu."; echo
								read MENUINPUT
								clear
							fi
						elif [ $MENUINPUT -gt $FREECAPACITY ]; then	# If the amount they enter to buy is more than they can store (notice this 'if' is one of the last to be checked).
							echo "You don't have enough free capacity for that Cannabis! Your current free capacity is "$FREECAPACITY""; echo
							echo "Press any key to return to the buy menu."; echo
							read MENUINPUT
							clear
						fi
					else									# If the read input is 0 or not a number, ignore it and clear.
						clear
					fi
				elif [ $BANK -lt $PRICE_CANNABIS ]; then				# If they don't have enough in the bank to even buy one then stop them in their tracks!
					echo "You can't afford any Cannabis!"; echo
					echo "Press any key to return to the buy menu."; echo
					read MENUINPUT
					clear
				fi
				;;	
				"c" | "C" )
				if [ $BANK -ge $PRICE_COCAINE ]; then						
					echo "How much Cocaine would you like to buy? (Press any non-numeric key to cancel.)"; echo
					read MENUINPUT; echo
					if [[ $MENUINPUT == [1-9]* ]]; then					
						if [ $MENUINPUT -le $FREECAPACITY ]; then
							let BUYINGTEMP_COCAINE=$PRICE_COCAINE*$MENUINPUT	
							if [ $BANK -ge $BUYINGTEMP_COCAINE ]; then		
								if [ $QUANTITY_COCAINE -eq 0 ]; then		
									let USERPRICE_COCAINE=$PRICE_COCAINE	
								else
									USERPRICE_COCAINE=$(( ( ( QUANTITY_COCAINE * $USERPRICE_COCAINE ) + ( $MENUINPUT * $PRICE_COCAINE ) ) / ( $QUANTITY_COCAINE + $MENUINPUT ) ))
								fi							
								let QUANTITY_COCAINE=$QUANTITY_COCAINE+$MENUINPUT	
								let BANK=$BANK-$PRICE_COCAINE*$MENUINPUT		
								let USEDCAPACITY=$QUANTITY_CANNABIS+$QUANTITY_COCAINE+$QUANTITY_ECSTACY+$QUANTITY__HEROIN+$QUANTITY_LSD+$QUANTITY_PCP+$QUANTITY_SPEED	
								let FREECAPACITY=$MAXCAPACITY-$USEDCAPACITY 
								echo "You bought $MENUINPUT unit(s) of Cocaine."; echo
								echo "Press any key to return to the buy menu."; echo
								read MENUINPUT
								clear
							elif [ $BANK -lt $BUYINGTEMP_COCAINE ]; then			
								echo "You can't afford that much Cocaine!"; echo
								echo "Press any key to return to the buy menu."; echo
								read MENUINPUT
								clear
							fi
						elif [ $MENUINPUT -gt $FREECAPACITY ]; then	
							echo "You don't have enough free capacity for that Cocaine! Your current free capacity is "$FREECAPACITY""; echo
							echo "Press any key to return to the buy menu."; echo
							read MENUINPUT
							clear
						fi
					else								
						clear
					fi
				elif [ $BANK -lt $PRICE_COCAINE ]; then				
					echo "You can't afford any Cocaine!"; echo
					echo "Press any key to return to the buy menu."; echo
					read MENUINPUT
					clear
				fi
				;;
				"e" | "E" )
				if [ $BANK -ge $PRICE_ECSTACY ]; then						
					echo "How much Ecstacy would you like to buy? (Press any non-numeric key to cancel.)"; echo
					read MENUINPUT; echo
					if [[ $MENUINPUT == [1-9]* ]]; then					
						if [ $MENUINPUT -le $FREECAPACITY ]; then
							let BUYINGTEMP_ECSTACY=$PRICE_ECSTACY*$MENUINPUT	
							if [ $BANK -ge $BUYINGTEMP_ECSTACY ]; then		
								if [ $QUANTITY_ECSTACY -eq 0 ]; then		
									let USERPRICE_ECSTACY=$PRICE_ECSTACY	
								else
									USERPRICE_ECSTACY=$(( ( ( QUANTITY_ECSTACY * $USERPRICE_ECSTACY ) + ( $MENUINPUT * $PRICE_ECSTACY ) ) / ( $QUANTITY_ECSTACY + $MENUINPUT ) ))
								fi							
								let QUANTITY_ECSTACY=$QUANTITY_ECSTACY+$MENUINPUT	
								let BANK=$BANK-$PRICE_ECSTACY*$MENUINPUT		
								let USEDCAPACITY=$QUANTITY_CANNABIS+$QUANTITY_COCAINE+$QUANTITY_ECSTACY+$QUANTITY__HEROIN+$QUANTITY_LSD+$QUANTITY_PCP+$QUANTITY_SPEED	
								let FREECAPACITY=$MAXCAPACITY-$USEDCAPACITY 
								echo "You bought $MENUINPUT unit(s) of Ecstacy."; echo
								echo "Press any key to return to the buy menu."; echo
								read MENUINPUT
								clear
							elif [ $BANK -lt $BUYINGTEMP_ECSTACY ]; then			
								echo "You can't afford that much Ecstacy!"; echo
								echo "Press any key to return to the buy menu."; echo
								read MENUINPUT
								clear
							fi
						elif [ $MENUINPUT -gt $FREECAPACITY ]; then	
							echo "You don't have enough free capacity for that Ecstacy! Your current free capacity is "$FREECAPACITY""; echo
							echo "Press any key to return to the buy menu."; echo
							read MENUINPUT
							clear
						fi
					else								
						clear
					fi
				elif [ $BANK -lt $PRICE_ECSTACY ]; then				
					echo "You can't afford any Ecstacy!"; echo
					echo "Press any key to return to the buy menu."; echo
					read MENUINPUT
					clear
				fi
				;;
				"h" | "H" )
				if [ $BANK -ge $PRICE_HEROIN ]; then						
					echo "How much Heroin would you like to buy? (Press any non-numeric key to cancel.)"; echo
					read MENUINPUT; echo
					if [[ $MENUINPUT == [1-9]* ]]; then					
						if [ $MENUINPUT -le $FREECAPACITY ]; then
							let BUYINGTEMP_HEROIN=$PRICE_HEROIN*$MENUINPUT	
							if [ $BANK -ge $BUYINGTEMP_HEROIN ]; then		
								if [ $QUANTITY_HEROIN -eq 0 ]; then		
									let USERPRICE_HEROIN=$PRICE_HEROIN	
								else
									USERPRICE_HEROIN=$(( ( ( QUANTITY_HEROIN * $USERPRICE_HEROIN ) + ( $MENUINPUT * $PRICE_HEROIN ) ) / ( $QUANTITY_HEROIN + $MENUINPUT ) ))
								fi							
								let QUANTITY_HEROIN=$QUANTITY_HEROIN+$MENUINPUT	
								let BANK=$BANK-$PRICE_HEROIN*$MENUINPUT		
								let USEDCAPACITY=$QUANTITY_CANNABIS+$QUANTITY_COCAINE+$QUANTITY_ECSTACY+$QUANTITY__HEROIN+$QUANTITY_LSD+$QUANTITY_PCP+$QUANTITY_SPEED	
								let FREECAPACITY=$MAXCAPACITY-$USEDCAPACITY 
								echo "You bought $MENUINPUT unit(s) of Heroin."; echo
								echo "Press any key to return to the buy menu."; echo
								read MENUINPUT
								clear
							elif [ $BANK -lt $BUYINGTEMP_HEROIN ]; then			
								echo "You can't afford that much Heroin!"; echo
								echo "Press any key to return to the buy menu."; echo
								read MENUINPUT
								clear
							fi
						elif [ $MENUINPUT -gt $FREECAPACITY ]; then	
							echo "You don't have enough free capacity for that Heroin! Your current free capacity is "$FREECAPACITY""; echo
							echo "Press any key to return to the buy menu."; echo
							read MENUINPUT
							clear
						fi
					else								
						clear
					fi
				elif [ $BANK -lt $PRICE_HEROIN ]; then				
					echo "You can't afford any Heroin!"; echo
					echo "Press any key to return to the buy menu."; echo
					read MENUINPUT
					clear
				fi
				;;
				"l" | "L" )
				if [ $BANK -ge $PRICE_LSD ]; then						
					echo "How much LSD would you like to buy? (Press any non-numeric key to cancel.)"; echo
					read MENUINPUT; echo
					if [[ $MENUINPUT == [1-9]* ]]; then					
						if [ $MENUINPUT -le $FREECAPACITY ]; then
							let BUYINGTEMP_LSD=$PRICE_LSD*$MENUINPUT	
							if [ $BANK -ge $BUYINGTEMP_LSD ]; then		
								if [ $QUANTITY_LSD -eq 0 ]; then		
									let USERPRICE_LSD=$PRICE_LSD	
								else
									USERPRICE_LSD=$(( ( ( QUANTITY_LSD * $USERPRICE_LSD ) + ( $MENUINPUT * $PRICE_LSD ) ) / ( $QUANTITY_LSD + $MENUINPUT ) ))
								fi							
								let QUANTITY_LSD=$QUANTITY_LSD+$MENUINPUT	
								let BANK=$BANK-$PRICE_LSD*$MENUINPUT		
								let USEDCAPACITY=$QUANTITY_CANNABIS+$QUANTITY_COCAINE+$QUANTITY_ECSTACY+$QUANTITY__HEROIN+$QUANTITY_LSD+$QUANTITY_PCP+$QUANTITY_SPEED	
								let FREECAPACITY=$MAXCAPACITY-$USEDCAPACITY 
								echo "You bought $MENUINPUT unit(s) of LSD."; echo
								echo "Press any key to return to the buy menu."; echo
								read MENUINPUT
								clear
							elif [ $BANK -lt $BUYINGTEMP_LSD ]; then			
								echo "You can't afford that much LSD!"; echo
								echo "Press any key to return to the buy menu."; echo
								read MENUINPUT
								clear
							fi
						elif [ $MENUINPUT -gt $FREECAPACITY ]; then	
							echo "You don't have enough free capacity for that LSD! Your current free capacity is "$FREECAPACITY""; echo
							echo "Press any key to return to the buy menu."; echo
							read MENUINPUT
							clear
						fi
					else								
						clear
					fi
				elif [ $BANK -lt $PRICE_LSD ]; then				
					echo "You can't afford any LSD!"; echo
					echo "Press any key to return to the buy menu."; echo
					read MENUINPUT
					clear
				fi
				;;
				"p" | "P" )
				if [ $BANK -ge $PRICE_PCP ]; then						
					echo "How much PCP would you like to buy? (Press any non-numeric key to cancel.)"; echo
					read MENUINPUT; echo
					if [[ $MENUINPUT == [1-9]* ]]; then					
						if [ $MENUINPUT -le $FREECAPACITY ]; then
							let BUYINGTEMP_PCP=$PRICE_PCP*$MENUINPUT	
							if [ $BANK -ge $BUYINGTEMP_PCP ]; then		
								if [ $QUANTITY_PCP -eq 0 ]; then		
									let USERPRICE_PCP=$PRICE_PCP	
								else
									USERPRICE_PCP=$(( ( ( QUANTITY_PCP * $USERPRICE_PCP ) + ( $MENUINPUT * $PRICE_PCP ) ) / ( $QUANTITY_PCP + $MENUINPUT ) ))
								fi							
								let QUANTITY_PCP=$QUANTITY_PCP+$MENUINPUT	
								let BANK=$BANK-$PRICE_PCP*$MENUINPUT		
								let USEDCAPACITY=$QUANTITY_CANNABIS+$QUANTITY_COCAINE+$QUANTITY_ECSTACY+$QUANTITY__HEROIN+$QUANTITY_LSD+$QUANTITY_PCP+$QUANTITY_SPEED	
								let FREECAPACITY=$MAXCAPACITY-$USEDCAPACITY 
								echo "You bought $MENUINPUT unit(s) of PCP."; echo
								echo "Press any key to return to the buy menu."; echo
								read MENUINPUT
								clear
							elif [ $BANK -lt $BUYINGTEMP_PCP ]; then			
								echo "You can't afford that much PCP!"; echo
								echo "Press any key to return to the buy menu."; echo
								read MENUINPUT
								clear
							fi
						elif [ $MENUINPUT -gt $FREECAPACITY ]; then	
							echo "You don't have enough free capacity for that PCP! Your current free capacity is "$FREECAPACITY""; echo
							echo "Press any key to return to the buy menu."; echo
							read MENUINPUT
							clear
						fi
					else								
						clear
					fi
				elif [ $BANK -lt $PRICE_PCP ]; then				
					echo "You can't afford any PCP!"; echo
					echo "Press any key to return to the buy menu."; echo
					read MENUINPUT
					clear
				fi
				;;
				"r" | "R" )
					clear
					break
				;;
				"s" | "S" )
				if [ $BANK -ge $PRICE_SPEED ]; then						
					echo "How much Speed would you like to buy? (Press any non-numeric key to cancel.)"; echo
					read MENUINPUT; echo
					if [[ $MENUINPUT == [1-9]* ]]; then					
						if [ $MENUINPUT -le $FREECAPACITY ]; then
							let BUYINGTEMP_SPEED=$PRICE_SPEED*$MENUINPUT	
							if [ $BANK -ge $BUYINGTEMP_SPEED ]; then		
								if [ $QUANTITY_SPEED -eq 0 ]; then		
									let USERPRICE_SPEED=$PRICE_SPEED	
								else
									USERPRICE_SPEED=$(( ( ( QUANTITY_SPEED * $USERPRICE_SPEED ) + ( $MENUINPUT * $PRICE_SPEED ) ) / ( $QUANTITY_SPEED + $MENUINPUT ) ))
								fi							
								let QUANTITY_SPEED=$QUANTITY_SPEED+$MENUINPUT	
								let BANK=$BANK-$PRICE_SPEED*$MENUINPUT		
								let USEDCAPACITY=$QUANTITY_CANNABIS+$QUANTITY_COCAINE+$QUANTITY_ECSTACY+$QUANTITY__HEROIN+$QUANTITY_LSD+$QUANTITY_PCP+$QUANTITY_SPEED	
								let FREECAPACITY=$MAXCAPACITY-$USEDCAPACITY 
								echo "You bought $MENUINPUT unit(s) of Speed."; echo
								echo "Press any key to return to the buy menu."; echo
								read MENUINPUT
								clear
							elif [ $BANK -lt $BUYINGTEMP_SPEED ]; then			
								echo "You can't afford that much Speed!"; echo
								echo "Press any key to return to the buy menu."; echo
								read MENUINPUT
								clear
							fi
						elif [ $MENUINPUT -gt $FREECAPACITY ]; then	
							echo "You don't have enough free capacity for that Speed! Your current free capacity is "$FREECAPACITY""; echo
							echo "Press any key to return to the buy menu."; echo
							read MENUINPUT
							clear
						fi
					else								
						clear
					fi
				elif [ $BANK -lt $PRICE_SPEED ]; then				
					echo "You can't afford any Speed!"; echo
					echo "Press any key to return to the buy menu."; echo
					read MENUINPUT
					clear
				fi
				;;
			esac		# End of case statement for drug letter select
		done		# End of while loop for 'BUYALLOW' true		
		;;
		"i" | "I" )										# 'Inventory' from main menu
			clear
			TOTALWORTH=$(( ( USERPRICE_CANNABIS * $QUANTITY_CANNABIS ) + ( $USERPRICE_COCAINE * $QUANTITY_COCAINE ) + ( $USERPRICE_ECSTACY * $QUANTITY_ECSTACY ) + ( $USERPRICE_HEROIN * $QUANTITY_HEROIN ) + ( $USERPRICE_LSD * $QUANTITY_LSD) + ( $USERPRICE_PCP * $QUANTITY_PCP ) + ( $USERPRICE_SPEED * $QUANTITY_SPEED ) ))
			echo "INVENTORY:"; echo
			echo "Maximum Capacity "$MAXCAPACITY" - Used Capacity "$USEDCAPACITY" - Free Capacity "$FREECAPACITY""; echo
			echo "Owned Cannabis $QUANTITY_CANNABIS - Price \$"$USERPRICE_CANNABIS""
			echo "Owned Cocaine $QUANTITY_COCAINE - Price \$"$USERPRICE_COCAINE""
			echo "Owned Ecstacy $QUANTITY_ECSTACY - Price \$"$USERPRICE_ECSTACY""
			echo "Owned Heroin $QUANTITY_HEROIN - Price \$"$USERPRICE_HEROIN""
			echo "Owned LSD $QUANTITY_LSD - Price \$"$USERPRICE_LSD""
			echo "Owned PCP $QUANTITY_PCP - Price \$"$USERPRICE_PCP""
			echo "Owned Speed $QUANTITY_SPEED - Price \$"$USERPRICE_SPEED""; echo
			echo "Total Worth \$"$TOTALWORTH""; echo			
			echo "Press any key to return to the main menu."; echo
			read MENUINPUT
			clear
		;;
		"l" | "L" )										# 'Loan' from main menu
		while [ $LOANALLOW -eq 1 ]; do
			clear
			echo "LOANS:"; echo
			echo "Loan Option 1: Borrow \$40 at %10 for 2 days. A total of \$44 must be repayed."
			echo "Loan Option 2: Borrow \$180 at %20 for 4 days. A total of \$216 must be repayed."
			echo "Loan Option 3: Borrow \$300 at %35 for 7 days. A total of \$405 must be repayed."; echo
			echo "1 - Take out Loan Option 1."
			echo "2 - Take out Loan Option 2."
			echo "3 - Take out Loan Option 3."; echo
			echo "r - Return to main menu."; echo
			if [[ $LOANACTIVE == "0" ]]; then
				echo "You are not currently in debt."; echo
			elif [[ $LOANACTIVE == "1" ]]; then
				echo "YOU ARE CURRENTLY IN DEBT"
				echo "Daily Interest Payment: \$"$LOANDAILYPAYMENT""
				echo "Daily Payments Remaining: "$LOANDURATIONDAYS""; echo
				echo "Press any key to return to the main menu."; echo
				read MENUINPUT
				clear
				break
			fi
			read MENUINPUT; echo
			case "$MENUINPUT" in
			"1" )
				if [[ $LOANACTIVE = "0" ]]; then
					echo "Are you sure you wish to take out this loan? Press 'y' to confirm, or any other key to go back."; echo
					read MENUINPUT
						if [ $MENUINPUT = "y" ] || [ $MENUINPUT = "Y" ]; then
							let LOANACTIVE="1"
							let LOANDAILYPAYMENT="2"
							let LOANDURATIONDAYS="2"
							let BANK=$BANK+"40"
						fi
#				elif [[ $LOANACTIVE = "1" ]]; then								# NOTE - I WROTE THIS DEFENSIVE CODE THEN REALISED IT WOULD NEVER BE RUN...
#					echo "You may not take out additional loans if you are currently in debt."
#					echo "Press any key to return to the main menu."; echo
#					read MENUINPUT
#					clear
#					break
				fi
			;;
			"2" )
				if [[ $LOANACTIVE = "0" ]]; then
					echo "Are you sure you wish to take out this loan? Press 'y' to confirm, or any other key to go back."; echo
					read MENUINPUT
						if [ $MENUINPUT = "y" ] || [ $MENUINPUT = "Y" ]; then
							let LOANACTIVE="1"
							let LOANDAILYPAYMENT="9"
							let LOANDURATIONDAYS="4"
							let BANK=$BANK+"180"
					fi
#				elif [[ $LOANACTIVE = "1" ]]; then
#					echo "You may not take out additional loans if you are currently in debt."
#					echo "Press any key to return to the main menu."; echo
#					read MENUINPUT
#					clear
#					break
				fi
			;;
			"3" )
				if [[ $LOANACTIVE = "0" ]]; then
					echo "Are you sure you wish to take out this loan? Press 'y' to confirm, or any other key to go back."; echo
					read MENUINPUT
						if [ $MENUINPUT = "y" ] || [ $MENUINPUT = "Y" ]; then
							let LOANACTIVE="1"
							let LOANDAILYPAYMENT="15"
							let LOANDURATIONDAYS="7"
							let BANK=$BANK+"250"
						fi
#				elif [[ $LOANACTIVE = "1" ]]; then
#					echo "You may not take out additional loans if you are currently in debt."
#					echo "Press any key to return to the main menu."; echo
#					read MENUINPUT
#					clear
#					break
				fi
			;;
			"r" |"R" )
				clear
				break
			;;
			esac
		done
		;;
		"n" | "N" )										# 'Next day' from main menu
			echo; echo "Are you sure you want to go to the next day? Press 'y' to confirm, or any other key to go back."; echo
			read MENUINPUT
			if [ $MENUINPUT = "y" ] || [ $MENUINPUT = "Y" ]; then
				let DAYCOUNTER=$((DAYCOUNTER+1))	# Next day counter
				PRICE_CANNABIS=$((RANDOM%9+3))		# Assign new random values to all drugs
				PRICE_COCAINE=$((RANDOM%35+20))
				PRICE_ECSTACY=$((RANDOM%90+60))
				PRICE_HEROIN=$((RANDOM%3000+1500))
				PRICE_LSD=$((RANDOM%800+700))
				PRICE_PCP=$((RANDOM%1100+850))
				PRICE_SPEED=$((RANDOM%450+250))
				if [[ $LOANACTIVE == 1 ]]; then					# LOAN CODE FOR NEW DAY STARTS HERE
					let BANK=$BANK-$LOANDAILYPAYMENT
					let LOANDURATIONDAYS=$LOANDURATIONDAYS-1
						if [[ LOANDURATIONDAYS -eq 0 ]]; then
							let LOANACTIVE="0"
						fi
				fi								# LOAN CODE FOR NEW DAY ENDS HERE
			fi
			clear
		;;
		"q" | "Q" )										# 'Quit' from main menu
			echo; echo "Are you sure you want to quit? Press 'y' to confirm, or any other key to go back."; echo
			read MENUINPUT
			if [ $MENUINPUT = "y" ]  || [ $MENUINPUT = "Y" ]; then
				break
			fi
			clear 
		;;
		"s" | "S" )										# 'Sell drugs' from main menu
			while [ $SELLALLOW -eq 1 ] ; do
				clear
				echo "SELL DRUGS:"; echo
				echo "Current price of Cannabis: \$"$PRICE_CANNABIS"."
				echo "Current price of Cocaine: \$"$PRICE_COCAINE"."
				echo "Current price of Heroin: \$"$PRICE_ECSTACY"."
				echo "Current price of Ecstacy: \$"$PRICE_HEROIN"."
				echo "Current price of LSD: \$"$PRICE_LSD"."
				echo "Current price of PCP: \$"$PRICE_PCP"."; echo
				echo "a - Sell Cannabis."
				echo "c - Sell Cocaine."
				echo "e - Sell Ecstacy."
				echo "h - Sell Heroin."
				echo "l - Sell LSD."
				echo "p - Sell PCP."
				echo "s - Sell Speed."; echo
				echo "r - Return to main menu."; echo
				read MENUINPUT; echo
				case "$MENUINPUT" in
					"a" | "A" )									# HOW THE SELL MODULE WORKS
						if [ $QUANTITY_CANNABIS -gt 0 ]; then						# If the user has more than 0 Cannabis...
							echo "How much Cannabis would you like to sell? (Press any non-numeric key to cancel.)"; echo			# Ask them how much they want to sell.
							read MENUINPUT; echo
							if [[ $MENUINPUT == [1-9]* ]]; then					# Check if user read input is numeric and higher than 0 
								if [ $MENUINPUT -le $QUANTITY_CANNABIS ]; then				# If they input less than/equal their current quantity...
									let QUANTITY_CANNABIS=$QUANTITY_CANNABIS-$MENUINPUT		# That's cool so decrease their quantity by the amount they sold
									if [ $QUANTITY_CANNABIS -eq 0 ]; then		#	If the user sells all of their drug, we don't want the previous price showing up.
										let USERPRICE_CANNABIS=0		#	And if they DO sell it all (e.g. quantity is 0), then set price to '0' to show it's empty.
									fi
									let BANK=$BANK+$PRICE_CANNABIS*$MENUINPUT			# And increase their bank by the amount sold x current price.
									let USEDCAPACITY=$QUANTITY_CANNABIS+$QUANTITY_COCAINE+$QUANTITY_ECSTACY+$QUANTITY__HEROIN+$QUANTITY_LSD+$QUANTITY_PCP+$QUANTITY_SPEED	
									let FREECAPACITY=$MAXCAPACITY-$USEDCAPACITY	# FREECAPACITY is recalculated when selling too.
									echo "You sold $MENUINPUT unit(s) of Cannabis."; echo
									echo "Press any key to return to the sell menu."; echo
									read MENUINPUT
									clear
								elif [ $MENUINPUT -gt $QUANTITY_CANNABIS ]; then			# If the user inputs a number to sell more than they actually have.
									echo "You don't have that much Cannabis to sell."; echo		# Deny it!
									echo "Press any key to return to the sell menu."; echo
									read MENUINPUT
									clear
								fi
							else									# If the read input was not numeric or it was 0, then do nothing
								clear
							fi
						else										# If they have 0 quantity of Cannabis, stop them dead!
							echo "You don't have any Cannabis to sell!"; echo
							echo "Press any key to return to the sell menu."; echo
							read MENUINPUT
							clear
						fi
				;;
				"c" | "C" )
						if [ $QUANTITY_COCAINE -gt 0 ]; then						
							echo "How much Cocaine would you like to sell? (Press any non-numeric key to cancel.)"; echo	.
							read MENUINPUT; echo
							if [[ $MENUINPUT == [1-9]* ]]; then			 
								if [ $MENUINPUT -le $QUANTITY_COCAINE ]; then	
									let QUANTITY_COCAINE=$QUANTITY_COCAINE-$MENUINPUT	
									if [ $QUANTITY_COCAINE -eq 0 ]; then		
										let USERPRICE_COCAINE=0		
									fi
									let BANK=$BANK+$PRICE_COCAINE*$MENUINPUT	
									let USEDCAPACITY=$QUANTITY_CANNABIS+$QUANTITY_COCAINE+$QUANTITY_ECSTACY+$QUANTITY__HEROIN+$QUANTITY_LSD+$QUANTITY_PCP+$QUANTITY_SPEED	
									let FREECAPACITY=$MAXCAPACITY-$USEDCAPACITY	
									echo "You sold $MENUINPUT unit(s) of Cocaine."; echo
									echo "Press any key to return to the sell menu."; echo
									read MENUINPUT
									clear
								elif [ $MENUINPUT -gt $QUANTITY_COCAINE ]; then	
									echo "You don't have that much Cocaine to sell."; echo
									echo "Press any key to return to the sell menu."; echo
									read MENUINPUT
									clear
								fi
							else								
								clear
							fi
						else									
							echo "You don't have any Cocaine to sell!"; echo
							echo "Press any key to return to the sell menu."; echo
							read MENUINPUT
							clear
						fi
				;;
				"e" | "E" )
						if [ $QUANTITY_ECSTACY -gt 0 ]; then						
							echo "How much Ecstacy would you like to sell? (Press any non-numeric key to cancel.)"; echo	.
							read MENUINPUT; echo
							if [[ $MENUINPUT == [1-9]* ]]; then			 
								if [ $MENUINPUT -le $QUANTITY_ECSTACY ]; then	
									let QUANTITY_ECSTACY=$QUANTITY_ECSTACY-$MENUINPUT	
									if [ $QUANTITY_ECSTACY -eq 0 ]; then		
										let USERPRICE_ECSTACY=0		
									fi
									let BANK=$BANK+$PRICE_ECSTACY*$MENUINPUT	
									let USEDCAPACITY=$QUANTITY_CANNABIS+$QUANTITY_COCAINE+$QUANTITY_ECSTACY+$QUANTITY__HEROIN+$QUANTITY_LSD+$QUANTITY_PCP+$QUANTITY_SPEED	
									let FREECAPACITY=$MAXCAPACITY-$USEDCAPACITY	
									echo "You sold $MENUINPUT unit(s) of Ecstacy."; echo
									echo "Press any key to return to the sell menu."; echo
									read MENUINPUT
									clear
								elif [ $MENUINPUT -gt $QUANTITY_ECSTACY ]; then	
									echo "You don't have that much Ecstacy to sell."; echo
									echo "Press any key to return to the sell menu."; echo
									read MENUINPUT
									clear
								fi
							else								
								clear
							fi
						else									
							echo "You don't have any Ecstacy to sell!"; echo
							echo "Press any key to return to the sell menu."; echo
							read MENUINPUT
							clear
						fi
				;;
				"h" | "H" )
						if [ $QUANTITY_HEROIN -gt 0 ]; then						
							echo "How much Heroin would you like to sell? (Press any non-numeric key to cancel.)"; echo	.
							read MENUINPUT; echo
							if [[ $MENUINPUT == [1-9]* ]]; then			 
								if [ $MENUINPUT -le $QUANTITY_HEROIN ]; then	
									let QUANTITY_HEROIN=$QUANTITY_HEROIN-$MENUINPUT	
									if [ $QUANTITY_HEROIN -eq 0 ]; then		
										let USERPRICE_HEROIN=0		
									fi
									let BANK=$BANK+$PRICE_HEROIN*$MENUINPUT	
									let USEDCAPACITY=$QUANTITY_CANNABIS+$QUANTITY_COCAINE+$QUANTITY_ECSTACY+$QUANTITY__HEROIN+$QUANTITY_LSD+$QUANTITY_PCP+$QUANTITY_SPEED	
									let FREECAPACITY=$MAXCAPACITY-$USEDCAPACITY	
									echo "You sold $MENUINPUT unit(s) of Heroin."; echo
									echo "Press any key to return to the sell menu."; echo
									read MENUINPUT
									clear
								elif [ $MENUINPUT -gt $QUANTITY_HEROIN ]; then	
									echo "You don't have that much Heroin to sell."; echo
									echo "Press any key to return to the sell menu."; echo
									read MENUINPUT
									clear
								fi
							else								
								clear
							fi
						else									
							echo "You don't have any Heroin to sell!"; echo
							echo "Press any key to return to the sell menu."; echo
							read MENUINPUT
							clear
						fi
				;;
				"l" | "L" )
						if [ $QUANTITY_LSD -gt 0 ]; then						
							echo "How much LSD would you like to sell? (Press any non-numeric key to cancel.)"; echo	.
							read MENUINPUT; echo
							if [[ $MENUINPUT == [1-9]* ]]; then			 
								if [ $MENUINPUT -le $QUANTITY_LSD ]; then	
									let QUANTITY_LSD=$QUANTITY_LSD-$MENUINPUT	
									if [ $QUANTITY_LSD -eq 0 ]; then		
										let USERPRICE_LSD=0		
									fi
									let BANK=$BANK+$PRICE_LSD*$MENUINPUT	
									let USEDCAPACITY=$QUANTITY_CANNABIS+$QUANTITY_COCAINE+$QUANTITY_ECSTACY+$QUANTITY__HEROIN+$QUANTITY_LSD+$QUANTITY_PCP+$QUANTITY_SPEED	
									let FREECAPACITY=$MAXCAPACITY-$USEDCAPACITY	
									echo "You sold $MENUINPUT unit(s) of LSD."; echo
									echo "Press any key to return to the sell menu."; echo
									read MENUINPUT
									clear
								elif [ $MENUINPUT -gt $QUANTITY_LSD ]; then	
									echo "You don't have that much LSD to sell."; echo
									echo "Press any key to return to the sell menu."; echo
									read MENUINPUT
									clear
								fi
							else								
								clear
							fi
						else									
							echo "You don't have any LSD to sell!"; echo
							echo "Press any key to return to the sell menu."; echo
							read MENUINPUT
							clear
						fi
				;;
				"p" | "P" )
						if [ $QUANTITY_PCP -gt 0 ]; then						
							echo "How much PCP would you like to sell? (Press any non-numeric key to cancel.)"; echo	.
							read MENUINPUT; echo
							if [[ $MENUINPUT == [1-9]* ]]; then			 
								if [ $MENUINPUT -le $QUANTITY_PCP ]; then	
									let QUANTITY_PCP=$QUANTITY_PCP-$MENUINPUT	
									if [ $QUANTITY_PCP -eq 0 ]; then		
										let USERPRICE_PCP=0		
									fi
									let BANK=$BANK+$PRICE_PCP*$MENUINPUT	
									let USEDCAPACITY=$QUANTITY_CANNABIS+$QUANTITY_COCAINE+$QUANTITY_ECSTACY+$QUANTITY__HEROIN+$QUANTITY_LSD+$QUANTITY_PCP+$QUANTITY_SPEED	
									let FREECAPACITY=$MAXCAPACITY-$USEDCAPACITY	
									echo "You sold $MENUINPUT unit(s) of PCP."; echo
									echo "Press any key to return to the sell menu."; echo
									read MENUINPUT
									clear
								elif [ $MENUINPUT -gt $QUANTITY_PCP ]; then	
									echo "You don't have that much PCP to sell."; echo
									echo "Press any key to return to the sell menu."; echo
									read MENUINPUT
									clear
								fi
							else								
								clear
							fi
						else									
							echo "You don't have any PCP to sell!"; echo
							echo "Press any key to return to the sell menu."; echo
							read MENUINPUT
							clear
						fi
				;;
				"r" | "R" )
				clear
				break
				;;
				"s" | "S" )
						if [ $QUANTITY_SPEED -gt 0 ]; then						
							echo "How much Speed would you like to sell? (Press any non-numeric key to cancel.)"; echo	.
							read MENUINPUT; echo
							if [[ $MENUINPUT == [1-9]* ]]; then			 
								if [ $MENUINPUT -le $QUANTITY_SPEED ]; then	
									let QUANTITY_SPEED=$QUANTITY_SPEED-$MENUINPUT	
									if [ $QUANTITY_SPEED -eq 0 ]; then		
										let USERPRICE_SPEED=0		
									fi
									let BANK=$BANK+$PRICE_SPEED*$MENUINPUT	
									let USEDCAPACITY=$QUANTITY_CANNABIS+$QUANTITY_COCAINE+$QUANTITY_ECSTACY+$QUANTITY__HEROIN+$QUANTITY_LSD+$QUANTITY_PCP+$QUANTITY_SPEED	
									let FREECAPACITY=$MAXCAPACITY-$USEDCAPACITY	
									echo "You sold $MENUINPUT unit(s) of Speed."; echo
									echo "Press any key to return to the sell menu."; echo
									read MENUINPUT
									clear
								elif [ $MENUINPUT -gt $QUANTITY_SPEED ]; then	
									echo "You don't have that much Speed to sell."; echo
									echo "Press any key to return to the sell menu."; echo
									read MENUINPUT
									clear
								fi
							else								
								clear
							fi
						else									
							echo "You don't have any Speed to sell!"; echo
							echo "Press any key to return to the sell menu."; echo
							read MENUINPUT
							clear
						fi
				;;
			esac		# End of case statement for sell drug letter select
		
		done		# End of while loop for SELLALLOW true
		;;
		* )
			clear	# This must always be at the end of the case statement so the while loop can check through all prior commands. For some reason, the 'buy' and 'sell' case menus don't need this!
		;;
	esac # Case statement for main menu. Don't touch it!
done # While loop for main game. Don't touch it!


# Once user selects 'quit', loop is broken and the following happens:

clear
echo "Quitting as requested. Thanks for playing BASHdeal!"
