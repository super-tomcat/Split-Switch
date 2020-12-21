# Split-Switch

Coming Soon :-)

Display a popup of buffer names to put in a new window after splitting.

![alt text](https://github.com/super-tomcat/split-switch/blob/main/split-switch_example_1.gif?raw=true)

Reason for writing this....

Every time i hit C-x 3 to split the current window i nearly always
have to then go into the new window and select what buffer i want in there.
Even if your using Helm or Ibuffer this usually involves a few keypresses.
It would be great if i could split the window and at the same time decide
what buffer i want in it, preferably via a popup, thus...
Split-Switch was born :-)

This program requires the excellent popup package that can be found here

https://github.com/auto-complete/popup-el

The version of popup used while writing and testing split switch was version:
popup-20200610.317

If you use Auto Complete in Emacs then you probably already have popup
installed, if not and you use Package in Emacs to install your packages
then you need to make sure that the line where you require this file
in your Emacs init file, appears AFTER the lines where you install the
popup package.
If you are not sure, then just add the lines that require this file and
setup the keybindings to it, to the very end of your init file and
everything should work.

```
Keys while in the popup:

C-n - next item in popup
Cursor Down - next item in popup
C-p - previous item in popup
Cursor Up - previous item in popup
Enter - Select buffer for new window, close popup
C-enter - Select buffer for new window, move point into it, close popup
C-f - Find current buffer in popup
C-s - switch on Isearch (any key above switches it off) 
C-b - switch Isearch off
Cursor Left - switch Isearch off
Backspace - delete 1 Isearch character
C-h - same as Backspace, deletes 1 Isearch character

C-g - cancels the popup and closes it.
```

Isearch

When Isearch is on any characters you type will be searched for
and highlighted and only the buffer names that have them
characters will be shown in the popup.

If no chars are found then the popup may fully disappear.

If this happens then you can either press Backspace (or C-h) to delete
each character entered, when all characters entered have been deleted all the
buffer names will appear in the popup again.

Or you can also press C-b or Cursor Left to delete all characters entered in one
go and put the selection back at the top of the popup.

All characters you enter during an Isearch will be shown in the Minibuffer
next to the word... Pattern:

Press Enter on any buffer name to put that buffer in the new window and
close the popup.

Point will stay in the current buffer.

If you want to move point into the new window after its created then press
Control-Enter instead of just Enter.

Sometimes you may need to put the current buffer in the new window, and
depending on what sort you have set for the buffer names the current
buffer name may not be in view in the popup, however you can always
quickly find it and automatically move the popup cursor to it by pressing:
C-f
Note that if you are using Isearch and the current buffer is filtered
out then C-f will not work.

Press C-g at anytime to cancel and close the popup.

Customization
=============================================
The following options can be customized, in Emacs press M-x and enter
```customize-group``` then enter ```split-switch```
```
Popup Height - in lines - default = 20
Popup Width - in characters - default = 40
Popup Face - text and background colors of popup
Popup Isearch Match Face - text and background colors of matched text
Popup Isearch Cursor Color - cursor color to signal Isearch mode on
Sort Order - Various orders to initially show buffer names in popup
```
