#!/bin/bash
EQUALS_BREAK='=============================================================='
HEADING_BREAK='-------------------'
WORD_LIST='wordlist'
NUMBER_OF_WORDS=$(cat $WORD_LIST | wc -l)
MASTERED_LIST='.mastered'
FAULTED_LIST='.faulted'
FAILED_LIST='.failed'
LAST_FAIL_LIST='.lastFailed'
REVIEW_LIST='.review'

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
			viewStatistics
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
#calls required test function as per number of possible words to test
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
	ifStatementInTest $1 1
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
			ifStatementInTest $1 $i
		
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
			ifStatementInTest $1 $i
		
		wordNumber=$((wordNumber+1))
	done
	clear
	greeting
}
#says the word at the given line number, and compares it to the typed word by the user as required by the test
#result of comparison determines how test proceeds
function ifStatementInTest(){
	#$1 argument is the file
	#$2 argument is line number of word
	sayWord $(sed -n "${2}p" "$1")
	declare -l currentWord
	read currentWord
	if [ "$currentWord" == "$(sed -n "${2}p" "$1")" ];
	then
		masteredList $(sed -n "${2}p" "$1")
			
	else
		echo -n '   Incorrect, try once more: ' 
		incorrectTryOnceMore $(sed -n "${2}p" "$1")
		sayWord $(sed -n "${2}p" "$1")
		read currentWord
		if [ "$currentWord" == "$(sed -n "${2}p" "$1")" ];
		then
			faultedList $(sed -n "${2}p" "$1")
		else
			failedList $(sed -n "${2}p" "$1")
		fi
	fi
}
#sends mastered words to the correct lists
function masteredList(){
	correct
	echo $1 >>$MASTERED_LIST 
	sed -i "/$1/d" "$LAST_FAIL_LIST"
}
#sends faulted words to the correct lists
function faultedList(){
	correct
	echo $1 >>$FAULTED_LIST 
	sed -i "/$1/d" "$LAST_FAIL_LIST"
}
#sends fail words to the correct lists
function failedList(){
	incorrect
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
	
	echo $HEADING_BREAK
	echo "New Spelling Review"
	echo $HEADING_BREAK
	sort $LAST_FAIL_LIST | uniq >$REVIEW_LIST
	sed -i '/^$/d' $REVIEW_LIST
	test $REVIEW_LIST
	greeting

}
function sayWord(){
	echo "$1;" | festival --tts 
}
function incorrectTryOnceMore(){
	incorrect
	echo "Try once more" | festival --tts
	sayWord $1
		
}
function correct(){
	echo "Correct. " | festival --tts
}
function incorrect(){
	echo "Incorrect. " | festival --tts		
}
function viewStatistics(){
	echo -e "Word\t\tMast\tFault\tFail"
	while read line; 
	do
		if [ `grep -c "$line" "$MASTERED_LIST"` -ne 0 ] || [ `grep -c "$line" "$FAULTED_LIST"` -ne 0 ] || [ `grep -c "$line" "$FAILED_LIST"` -ne 0 ]
		then
			echo -en "$line     "
			echo -en "\t`grep -c "$line" "$MASTERED_LIST"`"
			echo -en "\t`grep -c "$line" "$FAULTED_LIST"`"
			echo -en "\t`grep -c "$line" "$FAILED_LIST"`\n"
		fi
	done <$WORD_LIST
	greeting
}
function clearStatistics(){
	rm -f $MASTERED_LIST
	rm -f $FAULTED_LIST
	rm -f $FAILED_LIST
	rm -f $LAST_FAIL_LIST
	rm -f $REVIEW_LIST
	echo >$MASTERED_LIST
	echo >$FAULTED_LIST
	echo >$FAILED_LIST
	echo >$LAST_FAIL_LIST
	echo >$REVIEW_LIST
	echo "Cleared statistics"
	enterSelection
	
}
function quit(){
	clear
	echo $HEADING_BREAK
	echo "Thank You!"
	echo ' 0  0 '
	echo '      '
	echo '   o  '
	echo $HEADING_BREAK
	sleep 0.5s
	clear
	echo $HEADING_BREAK
	echo "Thank You!"
	echo ' 0  0 '
	echo '   >  '
	echo '   _  '
	echo $HEADING_BREAK
	sleep 0.5s
	clear
	echo $HEADING_BREAK
	echo "Thank You!"
	echo ' 0  0 '
	echo '   >  '
	echo '  \_/ '
	echo $HEADING_BREAK
	sleep 0.5s
	clear
	echo $HEADING_BREAK
	echo "Thank You!"
	echo ' ^  ^ '
	echo '   >  '
	echo '  \_/ '
	echo $HEADING_BREAK
	sleep 0.5s
	clear
	echo $HEADING_BREAK
	echo "Thank You!"
	echo ' ^  ^  /^\/^\ '
	echo '   >   \    / '
	echo '  \_/   \  /  '
	echo '         \/   '
	echo $HEADING_BREAK
	exit
}
greeting

