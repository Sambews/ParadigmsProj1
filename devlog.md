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

March 5th 2026, 2:30pm == Pre-session 2

I was talking to a friend about my issue with the string input, and I think what I'll do is handle each number as a list
of characters. Then I can have a function recursively go through the list, and use the length of the remaining list 
as a proxy for the 10s place I need to multiply that digit by. The way I'll process the initial string is I'll add a
parameter, numMake, that I'll put numbers into when I reach them. Then, once I hit an operator or whitespace, I reverse
numMake and cons it into the nums list. That way consecutive integers get treated as the same number. This will create
a bunch of empty lists in nums, but I can just filter those out before sending it to the evaluate-stacks function


-- This gets me fully up to date with where I was when I started reconstructing this devlog --


March 5th 2026, 5:21pm == Post-session 2

My method for handling numbers greater than 2 digits worked pretty well. I can't really handle doubles, 
but I'm not sure that I have to. I added some error handling, but I still need to check for a divide by 0 error.
I implemented the user input loop, so all I have left other than that last error is to implement the history. I'll
think about that later though.



March 5th 2026, 10:28pm == Pre-session 3
I'm feeling sick and tired in very literal senses so I doubt I'll actually get much done, but I'm planning on
implementing the check for the history call (i.e. processing the $number). I'll implement the history itself
another time

March 5th 2026, 10:47pm == Post-session 3
Ok yeah I've decided I'm not doing anything. 
I think I'll need to convert calls to the history into their numbers as soon as I recieve them to ensure they
go into the stack at the right position. I'm not super sure how I'll go about that given the way I'm processing
numbers though. Maybe when I find a $ I put it into numMake, and then when I'm flushing numMake to nums, I check 
to see if there's a $, and if there is a helper function decides what should go into nums based on the history.
Maybe I'll think of a better solution after some sleep. We'll see tomorrow.


March 6th 2026, 1:17pm == Pre-session 4
I'm feeling much better now. I like the thoughts I had last night with how I'll process the history. Thinking about it,
it almost doesn't even need to be its own function since I can just use list-ref at whatever the number is,
but I think error handling (making sure it's a number, making sure the history goes that far back, etc) means 
it'll be clunky enough to merit its own function. Also, I remembered I need to implement batch mode. I'll take a look at that last though.

These functions are getting really messy, but at this point it'd be more of a hassle to make them their own function calls, so I'm just really sorry.

I'm realizing that the way my functions call each other doesn't really work with a history, since my main function prints out the result of the 
evaluate stacks function. So it's a new function call every time. Maybe I'll have the evaluate stacks function print out the result of the calculation
and return the history, so that the main function can pass the history into the next create stacks function. It's not a super scalable solution, 
but this project doesn't have a long term so I think it'll be fine.

Handling the logic has proved to be extremely bulky, I am so incredibly sorry. I'll do my best to comment well, but it's not the most readable program.
Also I realized that having the evaluate-stacks print the result doesn't work because of scopes, but I can just have main print the most recent
thing on the history.


March 6th 2026, 3:26pm == Post-session 4

It took a lot of debugging, largely due to my extremely sloppy (both in what it does and how it's written) parser, but the history seems to work 
perfectly fine now. The only thing I have left is to implement batch mode vs interactive mode and checking for the divide by 0 error.


March 6th 2026, 5:05pm == Pre-session 5
Hopefully this is the last session. I plan on implementing batch mode (which should be as simple as a handful of cond statements before output),
check for divide by 0, and then I should be done


March 6th 2026, 8:45pm == Post-session 5
Everything seems to be working fine. Checking for divide by 0 somehow uncovered a bunch of dormant logic issues that took a ton of debugging and rewriting, but it works now. Time to write the readme and submit.
