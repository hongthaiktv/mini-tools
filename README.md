# Mini tools

Syntax: tmenu [default] [option 1] [option 2]... [option n]
        tmenu --color -s [OPTION SELECTED ARROW] color code.

--color	: Set color option for tmenu.
	  (--color with no argument to set default).
-s	: Silent - Do not echo message to terminal.
--help	: This help screen.

Exp: tmenu 'tmenu' 'tmenu' 'so' 'cool'
Will generate menu with 3 option and select 'tmenu' option as default.

Variable:
TMENU_RESULT: Get selected result.

Using 'source /path/tmenu.sh' to add to your script before call tmenu.
