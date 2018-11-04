    #!/bin/bash -e

    #
    #This is a random number guessing game
     
    #Declare variables and create scorefiles
    SCOREFILE="/tmp/scorefile"
    TMPFILE="/tmp/tmpscorefile"
    if [[ ! -f "$SCOREFILE" ]]; then
       touch "$SCOREFILE"
    fi
     
     
    ### BEGIN FUNCTIONS ###
     
    #Generate new statistics
    genstats () {
       cat "$SCOREFILE" | sort -k1n | head -10 >"$TMPFILE" && mv "$TMPFILE" "$SCOREFILE"
       HSCORETEN=$(cat "$SCOREFILE")
       HSCORENUM=$(head -1 "$SCOREFILE" | awk -F',' '{ print $1 }')
       HSCOREPER=$(head -1 "$SCOREFILE" | awk -F',' '{ print $2 }')
       HSCORETHR=$(tail -1 "$SCOREFILE" | awk -F',' '{ print $1 }')
       echo -e "The Top 10 scorers are:\n" && \
       awk -F',' 'BEGIN { printf "%-10s %-10s %-10s\n", "RANK","NAME","SCORE"
                         printf "%-10s %-10s %-10s\n", "----","----","-----" }  
                        { printf "%-10s %-10s %-10s\n", " "NR".",$2," "$1 }' "$SCOREFILE"
       echo ""                         
    }
     
       
    #Get player's guess and Validate (nested func)
    getguess () {
       valguess () {
          while ! [[ "$GUESS" -lt "101" ]] || ! [[ "$GUESS" -gt "0" ]]; do
            read -p ""$PLAYER", That was not a valid guess.  Please enter an integer between 1-100: " GUESS
          done  
       }      
     
       if [[ "$g" -eq "1" ]]; then # if this is the first guess
         read -p "Hi "$PLAYER"... Please enter your first guess: " GUESS
         valguess
         let FIRSTGUESS="$GUESS"
       else
         read -p "Enter a new guess: " GUESS
         valguess
         let NEWGUESS="$GUESS"
       fi
    }
     
     
    #Generate the random number
    gennumber () {
       let R=$RANDOM%100
    }
     
     
    #Calculate the difference between the players guesses as absolute value
    gdiff () {
       OLDGDIFF=$(($R - $OLDGUESS))   #calculate diff btwn oldguess and number
       NEWGDIFF=$(($R - $NEWGUESS))   #calculate diff btwn newguess and number
     
       if [[ "$OLDGDIFF" -lt 0 ]]; then
          let "ABSVAL_OLDGDIFF=( 0 - $OLDGDIFF )"              
       else
          let ABSVAL_OLDGDIFF="$OLDGDIFF"
       fi  
       if [[ "$NEWGDIFF" -lt 0 ]]; then
          let "ABSVAL_NEWGDIFF=( 0 - $NEWGDIFF )"              
       else
          let ABSVAL_NEWGDIFF="$NEWGDIFF"
       fi
    }
     
     
    #Calculate high scores
    calcscore () {
       if [[ "$g" -lt "$HSCORENUM" ]]; then
         echo -e "CONGRATULATIONS "$PLAYER"... You have the new high score!"  
         echo -e "The previous holder of this record was "$HSCOREPER"\n"
       elif [[ "$g" -eq "$HSCORENUM" ]]; then
         echo -e "Congratulations "$PLAYER"... You are tied with "$HSCOREPER" for 1st place!\n"  
       elif [[ "$g" -lt "$HSCORETHR" ]]; then
         echo -e "Congratulations "$PLAYER"... You made it into the Top 10 list!\n"
       else    
         echo -e "I'm sorry "$PLAYER", you did not make the Top 10 list this time. Please try again!\n"
       fi
       echo ""$g","$PLAYER"" >>"$SCOREFILE"  
       genstats
    }
     
     
    #Repeat game function
    repeat () {
      read -n 1 -p "Play Again? (Y/N): " REPEAT
      case $REPEAT in
        Y|y)
          echo ""  
          gennumber && playgame
          ;;
        N|n|*)
          echo -e "\n\nThanks for playing!\n"
          exit 0   
          ;;
      esac
    }
     
     
    #Play the game
    playgame () {
       #To see the number for debugging, uncomment the following line
       #echo "the random number is "$R""
       echo -e "\nThis is a guessing game...  You are to guess a number between 1-100...\n"
       genstats
       if [[ ! "$PLAYER" ]]; then
         read -p "Enter your name: " PLAYER
       fi  
       echo ""
       let g=1 && getguess
         
       if [[ "$FIRSTGUESS" = "$R" ]]; then
          echo -e "\n"$PLAYER", You must be very special... You guessed it on the first try!\n"    
          calcscore && repeat
       else
          let OLDGUESS="$FIRSTGUESS"           
          echo "Sorry, please try again..."
          let g=2 && getguess
     
          for ((g=2; NEWGUESS != "$R"; ++g)); do
             gdiff  # call func gdiff to calculate difference between guesses    
             if [[ "$ABSVAL_OLDGDIFF" -lt "$ABSVAL_NEWGDIFF" ]]; then      
                let OLDGUESS="$NEWGUESS"
                echo "You're getting colder..."
                getguess
             else
                let OLDGUESS="$NEWGUESS"  
                echo "You're getting warmer..."
                getguess
             fi  
          done
     
          echo -e "\n"$PLAYER"... You guessed it in "$g" tries!\n"
          calcscore && repeat
       fi
    }
     
    ### END FUNCTIONS ###
     
    # Generate the random number and start the game
    gennumber && playgame
