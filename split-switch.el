;; 
;; SPLIT SWITCH for Emacs
;; Pick the buffer you want in a new split window via a popup.
;;
;; Copyright (C) 2020 Neil Higgins
;; Created: 03-Dec-2020
;; Author: Neil Higgins
;; Version: 1.0
;;
;; Reason for writing this....
;;
;; Every time i hit C-x 3 to split the current window i nearly always
;; have to then go into the new window and select what buffer i want in there.
;; Even if your using Helm or Ibuffer this usually involves a few keypresses.
;; It would be great if i could split the window and at the same time decide
;; what buffer i want in it, preferably via a popup, thus...
;; Split-Switch was born :-)
;;
;; This program requires the excellent popup package that can be found here
;; 
;; https://github.com/auto-complete/popup-el
;;
;; The version of popup used while writing and testing split switch was version:
;; popup-20200610.317
;; 
;; If you use Auto Complete in Emacs then you probably already have popup
;; installed, if not and you use Package in Emacs to install your packages
;; then you need to make sure that the line where you require this file
;; in your Emacs init file, appears AFTER the lines where you install the
;; popup package.
;;
;; You need to put this file (split-switch.el) in a folder where Emacs
;; can see it.
;; If you are not sure how to do this then you can do what i do...
;; I have created a new folder inside my Emacs (.emacs.d) folder
;; called: site-lisp
;; In this folder i put all my seperate .el files that i want to load and
;; use when Emacs starts.
;; Once you have created this folder, put this file inside it.
;; 
;; To make Emacs see the files in this folder you need to add this line to
;; the top of your Emacs init.el file:
;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp"))
;; 
;; You can now load any of the files in this folder, usually by adding something
;; like:
;; (require 'split-switch)
;; to your Emacs init file and then set any customization you need.
;;
;; Keys while in the popup:
;;
;; C-n - next item in popup
;; Cursor Down - next item in popup
;; C-p - previous item in popup
;; Cursor Up - previous item in popup
;; Enter - Select buffer for new window, close popup
;; C-enter - Select buffer for new window, move point into it, close popup
;; C-f - Find current buffer in popup
;; C-s - switch on Isearch (any key above switches it off) 
;; C-b - switch Isearch off
;; Cursor Left - switch Isearch off
;; Backspace - delete 1 Isearch character
;; C-h - same as Backspace, deletes 1 Isearch character
;; 
;; C-g - cancels the popup and closes it.
;; 
;; 
;; Isearch
;; When Isearch is on any characters you type will be searched for
;; and highlighted and only the buffer names that have them
;; characters will be shown in the popup.
;; If no chars are found then the popup may fully disappear.
;; If this happens then you can either press Backspace (or C-h) to delete
;; each character entered, when all characters entered have been deleted all the
;; buffer names will appear in the popup again.
;; Or you can also press C-b or Cursor Left to delete all characters entered in one
;; go and put the selection back at the top of the popup.
;; 
;; All characters you enter during an Isearch will be shown in the Minibuffer
;; next to the word... Pattern:
;;
;; Press Enter on any buffer name to put that buffer in the new window and
;; close the popup.
;; Point will stay in the current buffer.
;; If you want to move point into the new window after its created then press
;; Control-Enter instead of just Enter.
;;
;; Sometimes you may need to put the current buffer in the new window, and
;; depending on what sort you have set for the buffer names the current
;; buffer name may not be in view in the popup, however you can always
;; quickly find it and automatically move the popup cursor to it by pressing:
;; C-f
;; Note that if you are using Isearch and the current buffer is filtered
;; out then C-f will not work.
;; 
;; Press C-g to cancel and close the popup.
;;
;; Customization
;; =============================================
;; The following options can be customized, in Emacs press M-x and enter
;; customize-group then enter split-switch
;;
;; Popup Height - in lines - default = 20
;; Popup Width - in characters - default = 40
;; Popup Face - text and background colors of popup
;; Popup Isearch Match Face - text and background colors of matched text
;; Popup Isearch Cursor Color - cursor color to signal Isearch mode on
;; Sort Order - Various orders to initially show buffer names in popup
;;
;; 
;;
(require 'cl-lib)
(require 'popup)
;;
;; 
;;
(defgroup split-switch nil
  "Display a popup of buffer names to put in a new window after splitting."
  :prefix "split-switch"
  :link '(url-link "https://github.com/super-tomcat/Split-Switch"))
;;
;; 
(defcustom split-switch-popup-height 20
  "The height of the Split Switch popup menu."
  :type 'integer
  :group 'split-switch)
;;
;;
(defcustom split-switch-popup-width 40
  "The width in characters of the Split Switch popup menu."
  :type 'integer
  :group 'split-switch)
;;
;;
(defface split-switch-popup-face
  '((t (:inherit default :foreground "yellow" :background "blue")))
  "Split Switch popup background and foreground colors."
  :group 'split-switch)
;;
;;
(defface split-switch-isearch-match-face
  '((t (:inherit default :foreground "yellow" :background "DeepSkyBlue4")))
  "Split Switch face used to highlight isearch matches."
  :group 'split-switch)
;;
(defcustom split-switch-isearch-cursor-color "red"
  "The color of the cursor when Split Switch is in Isearch mode.
You will also see the prompt... Pattern: in the minibuffer when
Isearch is on."
  :type 'color
  :group 'split-switch
  )
;; 
;; 
(defcustom split-switch-buffer-name-sort-order 1
  "This setting determines the sort order of the buffer names in the popup.
Special buffers are those that begin and end with * such as *Messages*, 
*scratch*, etc. Modification Time is based on when a file was last modified,
and thus will not include Special Buffers or Dired Buffers etc. So if you
want the most recent buffers you have edited at the top of the popup then you
should set this to: Modification Time with Special Buffers at the Bottom."
  :type '(choice (const :tag "Ascending with Special Buffers at the Top" 1)
                (const :tag "Ascending with Special Buffers at the Bottom" 2)
                (const :tag "Ascending" 3)
                (const :tag "Descending with Special Buffers at the Top" 4)
                (const :tag "Descending with Special Buffers at the Bottom" 5)
                (const :tag "Descending" 6)
                (const :tag "Modification Time with Special Buffers at the Top" 7)
                (const :tag "Modification Time with Special Buffers at the Bottom" 8)
                (const :tag "Modification Time" 9)
                ) 
  :group 'split-switch)
;;
;; ===============================================================================
;; 
(defun split-switch-split-window-right (&optional size)
"Split Switch entry point for splitting the window on the right.
To setup a keybinding to this function you just need to put something
similar to this in your init file anywhere after Split Switch has been loaded:

(global-set-key (kbd \"C-x 3\") 'split-switch-split-window-right)

Or cut out the extra key like i do and bind it to C-3 like this:

(global-set-key (kbd \"C-3\") 'split-switch-split-window-right)
"
  (interactive)
  (my-split-right-popup-command)
  (if split-switch-picked-buffer-name
      (progn
        (let ((my-new-window (split-window-right size)))
          (set-window-buffer my-new-window (symbol-name split-switch-picked-buffer-name))
          (if split-switch-enter-new-window
              (select-window my-new-window))))))
;;
;; 
(defun split-switch-split-window-below (&optional size)
  "Split Switch entry point for splitting the window below.
To setup a keybinding to this function you just need to put something
similar to this in your init file anywhere after Split Switch has been loaded:

(global-set-key (kbd \"C-x 2\") 'split-switch-split-window-below)

Or cut out the extra key like i do and bind it to C-2 like this:

(global-set-key (kbd \"C-2\") 'split-switch-split-window-below)"
  (interactive)
  (my-split-right-popup-command)
  (if split-switch-picked-buffer-name
      (progn
        (let ((my-new-window (split-window-below size)))
          (set-window-buffer my-new-window (symbol-name split-switch-picked-buffer-name))
          (if split-switch-enter-new-window
              (select-window my-new-window))))))
;; 
;; ===============================================================================
;; 
(defvar split-switch-picked-buffer-name nil "Holds the Split Switch picked buffer name or nil")
(defvar split-switch-enter-new-window nil "Tells Split Switch if the user wants to move point into the new window")
;;
;; 
(defun split-switch-split-and-enter ()
  "Sets flag to signal moving point into the new window and executes pressing Enter key
to close the Popup"
  (interactive)
  (setq split-switch-enter-new-window t)
  (setq unread-command-events
      (mapcar (lambda (e) `(t . ,e))
              (listify-key-sequence (kbd "\r"))))
  )
;;
;; 
(defun split-switch-find-current-buffer ()
  "Moves the cursor to the current buffer name in the popup"
  (interactive)
  (let ((currentIndex nil))
    (setq currentIndex (cl-loop for name in (popup-list menu)
                                for y from 0
                                when (string= name (buffer-name (current-buffer)))
                                return y))
    (if currentIndex
        (progn
          (popup-select menu currentIndex)
          (if (not (and (>= currentIndex (popup-scroll-top menu)) (<= currentIndex (+ (popup-height menu) (popup-scroll-top menu)))))
              (popup-scroll-up menu (- (popup-scroll-top menu) currentIndex)))))))
;;
;; 
(defvar split-switch-isearch-keymap
  (let ((map (make-sparse-keymap)))
    (define-key map "\r"        'popup-select)
    (define-key map "\C-g"      'popup-isearch-close)
    (define-key map "\C-b"      'popup-isearch-close)
    ;(define-key map (kbd "\C-t") 'get-key-test)
    (define-key map "\C-f"      'split-switch-find-current-buffer)
    (define-key map (kbd "<C-return>") 'split-switch-split-and-enter)
    (define-key map [left]      'popup-isearch-close)
    (define-key map "\C-h"      'popup-isearch-delete)
    (define-key map (kbd "DEL") 'popup-isearch-delete)
    (define-key map (kbd "C-y") 'popup-isearch-yank)
    map))
;;
;; 
(defvar split-switch-main-keymap
  (let ((map (make-sparse-keymap)))
    (define-key map "\r"        'popup-select)
    (define-key map "\C-f"      'split-switch-find-current-buffer)
    (define-key map [right]     'popup-open)
    (define-key map "\C-b"      'popup-close)
    (define-key map [left]      'popup-close)

    (define-key map "\C-n"      'popup-next)
    (define-key map [down]      'popup-next)
    (define-key map "\C-p"      'popup-previous)
    (define-key map [up]        'popup-previous)

    (define-key map [next]      'popup-page-next)
    (define-key map [prior]     'popup-page-previous)
    ;;
    ;(define-key map (kbd "C-t") 'get-key-test)
    ;(define-key map (kbd "\C-?") 'split-switch-split-and-enter)
    (define-key map (kbd "<C-return>") 'split-switch-split-and-enter)
    (define-key map "\C-s"      'popup-isearch)

    (define-key map [mouse-1]   'popup-select)
    (define-key map [mouse-4]   'popup-previous)
    (define-key map [mouse-5]   'popup-next)
    map))
;;
;;
(defun my-split-right-popup-command ()
  "Main function for Split Switch"
  (interactive)
  (setq split-switch-enter-new-window nil)
  (let ((popup-colors (face-remap-add-relative 'popup-face 'split-switch-popup-face))
        (isearch-match (face-remap-add-relative 'popup-isearch-match 'split-switch-isearch-match-face))
        (split-switch-buffer-list nil)
        (inhibit-quit t))
    (dolist (x (buffer-list))
      (if (buffer-file-name x)
      (setq split-switch-buffer-list (append split-switch-buffer-list (list (list (buffer-name x) (decode-time (nth 5 (file-attributes (buffer-file-name x))))))))
                        (setq split-switch-buffer-list (append split-switch-buffer-list (list (list (buffer-name x) (make-decoded-time :second 1 :minute 1 :hour 1 :day 1 :month 1 :year 1970)))))))
    (dolist (x split-switch-buffer-list)
      (if (string-match "\\` \\*.*\\*\\'" (car x))
          (setq split-switch-buffer-list (remove x split-switch-buffer-list))))
    (cond ((or (eq split-switch-buffer-name-sort-order 1) (eq split-switch-buffer-name-sort-order 2) (eq split-switch-buffer-name-sort-order 3))
           (setq split-switch-buffer-list (sort split-switch-buffer-list (lambda (s1 s2) (string-version-lessp (downcase (car s1)) (downcase (car s2)))))))
          ((or (eq split-switch-buffer-name-sort-order 4) (eq split-switch-buffer-name-sort-order 5) (eq split-switch-buffer-name-sort-order 6))
           (setq split-switch-buffer-list (sort split-switch-buffer-list (lambda (s1 s2) (string-version-lessp (downcase (car s2)) (downcase (car s1)))))))
          (t (setq split-switch-buffer-list (sort split-switch-buffer-list (lambda (s1 s2) (time-less-p (encode-time (car (cdr s2))) (encode-time (car (cdr s1)))))))))
     (if (or (eq split-switch-buffer-name-sort-order 1) (eq split-switch-buffer-name-sort-order 4) (eq split-switch-buffer-name-sort-order 5) (eq split-switch-buffer-name-sort-order 7) (eq split-switch-buffer-name-sort-order 8))
        (progn
          (let* ((special-buffers nil))
            (dolist (x split-switch-buffer-list)
              (if (string-match "\\`\\*.*\\*\\'" (car x))
                  (progn
                    (push x special-buffers)
                    (setq split-switch-buffer-list (remove x split-switch-buffer-list))
                    )))
            (if (or (eq split-switch-buffer-name-sort-order 1) (eq split-switch-buffer-name-sort-order 4) (eq split-switch-buffer-name-sort-order 7))
                (progn
                  (if (eq split-switch-buffer-name-sort-order 1)
                      (setq special-buffers (nreverse special-buffers)))
                  (setq split-switch-buffer-list (append special-buffers split-switch-buffer-list)))
               (setq split-switch-buffer-list (append split-switch-buffer-list special-buffers))))))
     ;;
    (let ((split-switch-buffer-names-only nil))
      (dolist (x split-switch-buffer-list) (push (intern (car x)) split-switch-buffer-names-only))
      (setq split-switch-buffer-names-only (nreverse split-switch-buffer-names-only))
      (unless (with-local-quit
              (progn
                (setq split-switch-picked-buffer-name (popup-menu* split-switch-buffer-names-only
                                                                   :keymap split-switch-main-keymap
                                                                   :height split-switch-popup-height
                                                                   :width split-switch-popup-width
                                                                   :margin-left 1
                                                                   :margin-right 1
                                                                   :isearch-cursor-color split-switch-isearch-cursor-color
                                                                   :isearch nil
                                                                   :isearch-keymap split-switch-isearch-keymap
                                                                   :scroll-bar t))
                (face-remap-remove-relative popup-colors)
                (face-remap-remove-relative isearch-match)))
      (progn
        (face-remap-remove-relative popup-colors)
        (face-remap-remove-relative isearch-match)
        (setq split-switch-picked-buffer-name nil)
        (setq quit-flag t))))))
;;
;;
(provide 'split-switch)
;;
;; ============================================================================
;; Example Configuration....put these in your Emacs init file...
;; ============================================================================
;;(require 'split-switch)
;;(global-set-key (kbd "C-3") 'split-switch-split-window-right)
;;(global-set-key (kbd "C-2") 'split-switch-split-window-below)
;; Sort by Modification Time but with Special Buffers at the top
;;(setq split-switch-buffer-name-sort-order 7)
;;
;;



