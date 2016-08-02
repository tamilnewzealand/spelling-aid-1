#!/bin/bash
EQUALS_BREAK='=============================================================='
HEADING_BREAK='-------------------'
WORD_LIST='wordlist'
NUMBER_OF_WORDS=$(cat $WORD_LIST | wc -l)
MASTERED_LIST='.mastered'
FAULTED_LIST='.faulted'
FAILED_LIST='.failed'
LAST_FAIL_LIST='.lastFailed'

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
	a=$( randomNumberInRange $(cat $1 | wc -l) )
	b=$a

	while [ $a -eq $b ]
	do 
		b=$( randomNumberInRange $(cat $1 | wc -l) )
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
	a=$( randomNumberInRange $(cat $1 | wc -l) )
	b=$a

	while [ $a -eq $b ]
	do 
		b=$( randomNumberInRange $(cat $1 | wc -l) )
	done
	c=$b
	while [ $a -eq $c -o $b -eq $c ]
	do
		c=$( randomNumberInRange $(cat $1 | wc -l) )
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
					correctList $(sed -n "${i}p" "$1")
					
			else
				echo -n '   Incorrect, try once more: ' 
				incorrectTryOnceMore
				sayWord $(sed -n "${i}p" "$1")
				read currentWord
				if [ "$currentWord" == "$(sed -n "${i}p" "$1")" ];
				then
					faultedList $(sed -n "${i}p" "$1")
				else
					failedList $(sed -n "${i}p" "$1")
				fi
			fi
		
		wordNumber=$((wordNumber+1))
	done
	clear
	greeting
}
function correctList(){
	echo $1 >>$MASTERED_LIST 
	sed -i "/$1/d" "$LAST_FAIL_LIST"
}
function faultedList(){
	echo $1 >>$FAULTED_LIST 
	sed -i "/$1/d" "$LAST_FAIL_LIST"
}
function failedList(){
	echo $1 >>$FAILED_LIST 
	echo $1 >>$LAST_FAIL_LIST 
}
function newQuiz(){
	echo $HEADING_BREAK
	echo "New Spelling Quiz"
	echo $HEADING_BREAK
	test $WORD_LIST
}
function newReview(){
	$LAST_FAILED_LIST | sort -u > $LAST_FAILED_LIST
	echo $HEADING_BREAK
	echo "New Spelling Review"
	echo $HEADING_BREAK
	test $LAST_FAIL_LIST
	greeting

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
	rm -f $LAST_FAIL_LIST
	echo >$MASTERED_LIST
	echo >$FAULTED_LIST
	echo >$FAILED_LIST
	echo >$LAST_FAIL_LIST
	echo "Cleared statistics"
	enterSelection
	
	
}
function quit(){
	exit
}
greeting

