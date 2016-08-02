#!/bin/bash
EQUALS_BREAK='=============================================================='
HEADING_BREAK='-------------------'
WORD_LIST='wordlist'
NUMBER_OF_WORDS=$(cat $WORD_LIST | wc -l)
MASTERED_LIST='.mastered'
FAULTED_LIST='.faulted'
FAILED_LIST='.failed'
STATISTICS='.statistics'

function greeting(){
	echo $EQUALS_BREAK
	echo 'Welcome to the Spelling Aid'
	echo $EQUALS_BREAK
	echo -e 'Please select from one of the following options: \n'
	echo -e '\t (n)ew spelling quiz'
	echo -e '\t (r)eview mistakes'
	echo -e '\t (v)iew statistics'
	echo -e '\t (c)lear statistics'
	echo -e '\t (q)uit application'
	enterSelection
}

function enterSelection(){
	echo -n 'Enter a selection [n/r/v/c/q]: '
	read option
	case $option in
		n|N)
			newQuiz
			;;
		r|R)
			newReview
			;;
		v|V)

			;;
		c|C)
			clearStatistics
			;;
		q|Q)
			quit
			;;
		*)
			echo 'Invalid input. Please try again'
			enterSelection
			;;	
	esac
}
function randomNumberInRange(){
	NUMBER=$1
	RANDOM_NUMBER=$((RANDOM % $NUMBER+1))
	echo $RANDOM_NUMBER
}
function test(){
	if [ $(grep -c ^ $1) -ge 3 ];
	then
		test3OrMoreWord $1
	elif [ $(grep -c ^ $1) -eq 2 ];
	then
		test2Word $1
	elif [ $(grep -c ^ $1) -eq 1 ];
	then
		test1Word $1
	else
		echo "There are no words to use for that test"
	fi
	
}
function test1Word(){
	echo -n "Spell word 1 of 1: " 
	sayWord $(sed -n "${i}p" "$1")
	read currentWord
	if [ "$currentWord" == "$(sed -n "${i}p" "$1")" ];
	then
		correct
		echo $(sed -n "1p" "$1") >>$MASTERED_LIST 
	else
		echo -n '   Incorrect, try once more: ' 
		incorrectTryOnceMore
		sayWord $(sed -n "1p" "$1")
		read currentWord
		if [ "$currentWord" == "$(sed -n "${i}p" "$1")" ];
		then
			echo $(sed -n "1p" "$1") >>$FAULTED_LIST
		else
			echo $(sed -n "1p" "$1") >>$FAILED_LIST
		fi
	fi	
	clear
	greeting
}
function test2Word(){
	a=$( randomNumberInRange NUMBER_OF_WORDS )
	b=$a

	while [ $a -eq $b ]
	do 
		b=$( randomNumberInRange NUMBER_OF_WORDS )
	done


	wordNumber=1
	for i in $a $b;
		do
			echo -n "Spell word $wordNumber of 2: " 
			sayWord $(sed -n "${i}p" "$1")
			read currentWord
			if [ "$currentWord" == "$(sed -n "${i}p" "$1")" ];
			then
					correct
					echo $(sed -n "${i}p" "$1") >>$MASTERED_LIST 
			else
				echo -n '   Incorrect, try once more: ' 
				incorrectTryOnceMore
				sayWord $(sed -n "${i}p" "$1")
				read currentWord
				if [ "$currentWord" == "$(sed -n "${i}p" "$1")" ];
				then
					echo $(sed -n "${i}p" "$1") >>$FAULTED_LIST
				else
					echo $(sed -n "${i}p" "$1") >>$FAILED_LIST
				fi
			fi
		
		wordNumber=$((wordNumber+1))
	done
	clear
	greeting
}
function test3OrMoreWord(){
	a=$( randomNumberInRange NUMBER_OF_WORDS )
	b=$a

	while [ $a -eq $b ]
	do 
		b=$( randomNumberInRange NUMBER_OF_WORDS )
	done
	c=$b
	while [ $a -eq $c -o $b -eq $c ]
	do
		c=$( randomNumberInRange NUMBER_OF_WORDS )
	done
	wordNumber=1
	for i in $a $b $c;
		do
			echo -n "Spell word $wordNumber of 3: " 
			sayWord $(sed -n "${i}p" "$1")
			declare -l currentWord
			read currentWord
			if [ "$currentWord" == "$(sed -n "${i}p" "$1")" ];
			then
					correct
					echo $(sed -n "${i}p" "$1") >>$MASTERED_LIST 
			else
				echo -n '   Incorrect, try once more: ' 
				incorrectTryOnceMore
				sayWord $(sed -n "${i}p" "$1")
				read currentWord
				if [ "$currentWord" == "$(sed -n "${i}p" "$1")" ];
				then
					echo $(sed -n "${i}p" "$1") >>$FAULTED_LIST
				else
					echo $(sed -n "${i}p" "$1") >>$FAILED_LIST
				fi
			fi
		
		wordNumber=$((wordNumber+1))
	done
	clear
	greeting
}

function newQuiz(){
	echo $HEADING_BREAK
	echo "New Spelling Quiz"
	echo $HEADING_BREAK
	test $WORD_LIST
}
function newReview(){
	#cat $FAILED_LIST | sort -u > .uniqueFailed
	echo $HEADING_BREAK
	echo "New Spelling Review"
	echo $HEADING_BREAK
	test $FAILED_LIST

}
function sayWord(){
	echo "$1; $1 " | festival --tts 
}
function incorrectTryOnceMore(){
	incorrect
	echo "Try once more" | festival --tts		
}
function correct(){
	echo "Correct. " | festival --tts
}
function incorrect(){
	echo "Incorrect. " | festival --tts		
}
function viewStatistics(){
	echo "to be implemented"
	greeting
}
function clearStatistics(){
	rm -f $MASTERED_LIST
	rm -f $FAULTED_LIST
	rm -f $FAILED_LIST
	rm -f $STATISTICS
	echo >$MASTERED_LIST
	echo >$FAULTED_LIST
	echo >$FAILED_LIST
	cp $WORD_LIST $STATISTICS
	echo "Cleared statistics"
	enterSelection
	
	
}
function quit(){
	exit
}
greeting

