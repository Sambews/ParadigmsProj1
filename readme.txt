Keyton Smith 
kss230009
CS 4337.003 Project #1

This project consistens of a single file, proj.rkt. Notable functions are as follows

charL->num takes a list of characters and converts it into a number. This is
to allow numbers to be stored as character lists.

get-history is essentially list-ref but with specific error handling to make
sure the reference isn't greater than the size of the history or negative

create-stacks takes a string, converts it to a list, and then processes it
character by character.

If the character is an operator, it adds it to the ops list.
If the character is a number or a $, it adds it to the temporary numMake list.
This will end up as a list of characters, which is how numbers are stored.

If the character is a non-number, including $, it flushes numMake. If there's
a $, it calls get-history with the number in num-make as the index and puts
the resulting number into nums. If there's no $, it simply puts the number
into nums. 

After the string has been fully processed, create-stacks will call
evaluate-stacks

evaluate-stacks takes a list of operators, a list of operands, and the history
list. For each operator it takes two operands, performs the operation, and
then puts it back into the operands list. Once there are no operators and only
one operand, the updated history with the resulting number is returned.

main takes a string from the user and calls create-stacks. Once main recieves the updated history list, it displays the latest addition
to it.

input should only contain the following characters:
0123456789-*+/$ and whitespace. DECIMALS ARE NOT SUPPORTED, which I
acknowledge as a limitation of the project when considering the
specifications. 

The program can be run in the command line by calling 'racket proj.rkt'
To run in batch mode, which eliminates all output except for the result, call
'racket proj.rkt -b'
or  'racket proj.rkt --batch'

