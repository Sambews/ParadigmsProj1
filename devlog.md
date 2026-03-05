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
