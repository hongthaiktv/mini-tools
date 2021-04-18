# Mini tools

tmenu - Linux Bash terminal menu generation
-------------------------------------------

```
Syntax: tmenu [default] [option 1] [option 2]... [option n]
        tmenu --color -s [OPTION SELECTED ARROW] color code.
```

<p>--color	: Set color option for tmenu.<br>
	  (--color with no argument to set default).</p>

-s	: Silent - Do not echo message to terminal.

--help	: This help screen.

Exp: tmenu 'tmenu' 'tmenu' 'so' 'cool'
Will generate menu with 3 option and select 'tmenu' option as default.
Press 'q' to quit tmenu.

Variable:
TMENU_RESULT: Get selected result.

Using 'source /path/tmenu.sh' to add to your script before call tmenu.
