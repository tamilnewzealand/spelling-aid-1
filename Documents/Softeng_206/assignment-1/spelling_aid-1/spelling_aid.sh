#!/bin/bash
EQUALS_BREAK='=============================================================='
HEADING_BREAK='-------------------'
WORD_LIST='./wordlist'
NUMBER_OF_WORDS=$(cat $WORD_LIST | wc -l)
MASTERED_LIST='./mastered'
FAULTED_LIST='./faulted'
FAILED_LIST='./failed'

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
		n)
			newQuiz
			;;
		r)
			;;
		v)
			;;
		c)
			;;
		q)
			quit
			;;
		*)
			echo 'Invalid input. Please try again'
			enterSelection
			;;	
	esac
}

function readOption(){
	read $option
}
function newQuiz(){
	chooseWords
	
}
function randomNumberInRange(){
	NUMBER=$1
	RANDOM_NUMBER=$((RANDOM%NUMBER+1))
	return RANDOM_NUMBER
}
function chooseWords(){
	n1=$( randomNumberInRange NUMBER_OF_WORDS )
	n2=$n1

	while [ $n1 -eq $n2 ]
	do 
		n2=$( randomNumberInRange NUMBER_OF_WORDS )
	done
	n3=$n1
	while [ $n1 -eq $n3 -o $n2 -eq $n3 ]
	do
		n3=$( randomNumberInRange NUMBER_OF_WORDS )
	done
}
function sayWord(){
	echo "$1 ... ... $1 ..." | festival --tts
}
function incorrectTryOnceMore(){
	incorrect
	echo "... try once more" | festival --tts		
	sayWord;
}
function correct(){
	echo "Correct" | festival --tts
}
function incorrect(){
	echo "Incorrect" | festival --tts		
}
function quit(){
	exit
}
echo `NUMBER_OF_WORDS`
greeting

