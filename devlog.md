Ok SO I forgot to create a devlog through git. 
Thankfully, I've only been working for a day or two, so it shouldn't be difficult to recreate.

March 4th, 2026, 12:00pm -- Pre-session 1
Things I know about this project
- User input
- Prefix notation
- Needs a history
- Input verification
- Functional style (racket)

Prefix notation involves stacks, which the cons operator does pretty neatly, so I think having a function
to parse a string input into two stacks (lists) for operators and operands, and then passing those
to a function which evaluates the strings is the best way to go.

March 4th, 2026, 2:40pm -- Post-session 1

The input for numbers being a string makes things a bit awkward. Right now, just for a proof of concept, I wrote
functions to take a single character, change it to an integer by subtracting its ascii code from the ascii code for 0,
and then turning it back after parsing. Other than that limitation, the function to create the stacks and the one to 
evaluate stacks works. 

March 5th, 2:30pm == Pre-session 2

I was talking to a friend about my issue with the string input, and I think what I'll do is handle each number as a list
of characters. Then I can have a function recursively go through the list, and use the length of the remaining list 
as a proxy for the 10s place I need to multiply that digit by. The way I'll process the initial string is I'll add a
parameter, numMake, that I'll put numbers into when I reach them. Then, once I hit an operator or whitespace, I reverse
numMake and cons it into the nums list. That way consecutive integers get treated as the same number. This will create
a bunch of empty lists in nums, but I can just filter those out before sending it to the evaluate-stacks function.
