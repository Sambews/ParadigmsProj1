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
