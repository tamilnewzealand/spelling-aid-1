#!/bin/bash
EQUALS_BREAK='=============================================================='
HEADING_BREAK='-------------------'
WORD_LIST='./wordlist'
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
	echo 'Enter a selection [n/r/v/c/q]: '
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
	echo $RANDOM % $1 +1
}
function chooseWords(){
	n1=$(randomNumberInRange \(wc -l $WORD_LIST\))
	n2=$n1
	while [ $n1 -eq $n2 ]
	do 
		n2=$(randomNumberInRange \(wc -l $WORD_LIST\))
	done
	n3=$n1
	while [ $n1 -eq $n3 || $n2 -eq $n3 ]
	do
		n3=$(randomNumberInRange \(wc -l $WORD_LIST\))
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

greeting
chooseWords
