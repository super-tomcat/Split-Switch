# Split-Switch
Display a popup of buffer names to put in a new window after splitting.

![alt text](https://github.com/super-tomcat/split-switch/blob/main/split-switch_example_1.gif?raw=true)

Reason for writing this....

Every time i hit C-x 3 to split the current window i nearly always
have to then go into the new window and select what buffer i want in there.
Even if your using Helm or Ibuffer this usually involves a few keypresses.
It would be great if i could split the window and at the same time decide
what buffer i want in it, preferably via a popup, thus...
Split-Switch was born :-)

Installing into Emacs....
============================================================================

This program requires the excellent popup package that can be found here

https://github.com/auto-complete/popup-el

The version of popup used while writing and testing split switch was version:
popup-20200610.317

If you use Auto Complete in Emacs then you probably already have popup
installed, if not and you use Package in Emacs to install your packages
then you need to make sure that the line where you require this file
in your Emacs init file, appears AFTER the lines where you install the
popup package.

You then need to put the file (split-switch.el) in a folder where Emacs
can see it.
If you are not sure how to do this then you can do what i do...

I have created a new folder inside my Emacs (.emacs.d) folder
called: site-lisp

In this folder i put all my seperate .el files that i want to load and
use when Emacs starts.

Once you have created this folder, put the file: split-switch.el inside it.

To make Emacs see the files in this folder you need to add this line to
the top of your Emacs init.el file:

```(add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp"))```

You can now load any of the files in this folder, usually by adding something
like:

```(require 'split-switch)```

to your Emacs init file and then set any customization you need.

If you know how to you can also byte-compile the split-switch.el file, just
open it in Emacs and go: Emacs-Lisp > Byte Compile This File, from the Emacs
menu and its done.

Example Configuration....
============================================================================
Add these lines to the end of your Emacs init.el file.

Note that these will replace Emacs default keys for splitting the window on
the right and splitting it below.....

```
(require 'split-switch)
(global-set-key (kbd "C-x 3") 'split-switch-split-window-right)
(global-set-key (kbd "C-x 2") 'split-switch-split-window-below)
;; Sort by Modification Time but with Special Buffers at the top
(setq split-switch-buffer-name-sort-order 7)
```

Keys while in the popup:
===========================================
```
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

Isearch
=============================================
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
