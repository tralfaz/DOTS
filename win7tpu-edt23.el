;;; tpu-edt.el --- Emacs emulating TPU emulating EDT

;; Copyright (C) 1993, 1994, 1995 Free Software Foundation, Inc.

;; Author: Rob Riepel <riepel@networking.stanford.edu>
;; Maintainer: Rob Riepel <riepel@networking.stanford.edu>
;; Version: 4.2
;; Keywords: emulations

;; This file is part of GNU Emacs.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;; TPU-edt is based on tpu.el by Jeff Kowalski and Bob Covey.

;;; Commentary:

;; %% TPU-edt -- Emacs emulating TPU emulating EDT

;; %% Contents

;;  % Introduction
;;  % Differences Between TPU-edt and DEC TPU/edt
;;  % Starting TPU-edt
;;  % Customizing TPU-edt using the Emacs Initialization File
;;  % Regular Expressions in TPU-edt


;; %% Introduction

;;    TPU-edt emulates the popular DEC VMS editor EDT (actually, it emulates
;;    DEC TPU's EDT emulation, hence the name TPU-edt).  TPU-edt features the
;;    following TPU/edt functionality:

;;     .  EDT keypad
;;     .  On-line help
;;     .  Repeat counts
;;     .  Scroll margins
;;     .  Learn sequences
;;     .  Free cursor mode
;;     .  Rectangular cut and paste
;;     .  Multiple windows and buffers
;;     .  TPU line-mode REPLACE command
;;     .  Wild card search and substitution
;;     .  Configurable through an initialization file
;;     .  History recall of search strings, file names, and commands

;;    Please note that TPU-edt does NOT emulate TPU.  It emulates TPU's EDT
;;    emulation.  Very few TPU line-mode commands are supported.

;;    TPU-edt, like its VMS cousin, works on VT-series terminals with DEC
;;    style keyboards.  VT terminal emulators, including xterm with the
;;    appropriate key translations, work just fine too.

;;    TPU-edt works with X-windows.  This is accomplished through a TPU-edt X
;;    key map.  The TPU-edt module tpu-mapper creates this map and stores it
;;    in a file.  Tpu-mapper will be run automatically the first time you
;;    invoke the X-windows version of emacs, or you can run it by hand.  See
;;    the commentary in tpu-mapper.el for details.


;; %% Differences Between TPU-edt and DEC TPU/edt

;;    In some cases, Emacs doesn't support text highlighting, so selected
;;    regions are not shown in inverse video.  Emacs uses the concept of "the
;;    mark".  The mark is set at one end of a selected region; the cursor is
;;    at the other.  The letter "M" appears in the mode line when the mark is
;;    set.  The native emacs command ^X^X (Control-X twice) exchanges the
;;    cursor with the mark; this provides a handy way to find the location of
;;    the mark.

;;    In TPU the cursor can be either bound or free.  Bound means the cursor
;;    cannot wander outside the text of the file being edited.  Free means
;;    the arrow keys can move the cursor past the ends of lines.  Free is the
;;    default mode in TPU; bound is the only mode in EDT.  Bound is the only
;;    mode in the base version of TPU-edt; optional extensions add an
;;    approximation of free mode, see the commentary in tpu-extras.el for
;;    details.

;;    Like TPU, emacs uses multiple buffers.  Some buffers are used to hold
;;    files you are editing; other "internal" buffers are used for emacs' own
;;    purposes (like showing you help).  Here are some commands for dealing
;;    with buffers.

;;       Gold-B   moves to next buffer, including internal buffers
;;       Gold-N   moves to next buffer containing a file
;;       Gold-M   brings up a buffer menu (like TPU "show buffers")

;;    Emacs is very fond of throwing up new windows.  Dealing with all these
;;    windows can be a little confusing at first, so here are a few commands
;;    to that may help:

;;       Gold-Next_Scr  moves to the next window on the screen
;;       Gold-Prev_Scr  moves to the previous window on the screen
;;       Gold-TAB       also moves to the next window on the screen

;;       Control-x 1    deletes all but the current window
;;       Control-x 0    deletes the current window

;;    Note that the buffers associated with deleted windows still exist!

;;    Like TPU, TPU-edt has a "command" function, invoked with Gold-KP7 or
;;    Do.  Most of the commands available are emacs commands.  Some TPU
;;    commands are available, they are: replace, exit, quit, include, and
;;    Get (unfortunately, "get" is an internal emacs function, so we are
;;    stuck with "Get" - to make life easier, Get is available as Gold-g).

;;    TPU-edt supports the recall of commands, file names, and search
;;    strings.  The history of strings recalled differs slightly from
;;    TPU/edt, but it is still very convenient.

;;    Help is available!  The traditional help keys (Help and PF2) display
;;    a small help file showing the default keypad layout, control key
;;    functions, and Gold key functions.  Pressing any key inside of help
;;    splits the screen and prints a description of the function of the
;;    pressed key.  Gold-PF2 invokes the native emacs help, with its
;;    zillions of options.

;;    Thanks to emacs, TPU-edt has some extensions that may make your life
;;    easier, or at least more interesting.  For example, Gold-r toggles
;;    TPU-edt rectangular mode.  In rectangular mode, Remove and Insert work
;;    on rectangles.  Likewise, Gold-* toggles TPU-edt regular expression
;;    mode.  In regular expression mode Find, Find Next, and the line-mode
;;    replace command work with regular expressions.  [A regular expression
;;    is a pattern that denotes a set of strings; like VMS wildcards.]

;;    Emacs also gives TPU-edt the undo and occur functions.  Undo does
;;    what it says; it undoes the last change.  Multiple undos in a row
;;    undo multiple changes.  For your convenience, undo is available on
;;    Gold-u.  Occur shows all the lines containing a specific string in
;;    another window.  Moving to that window, and typing ^C^C (Control-C
;;    twice) on a particular line moves you back to the original window
;;    at that line.  Occur is on Gold-o.

;;    Finally, as you edit, remember that all the power of emacs is at
;;    your disposal.  It really is a fantastic tool.  You may even want to
;;    take some time and read the emacs tutorial; perhaps not to learn the
;;    native emacs key bindings, but to get a feel for all the things
;;    emacs can do for you.  The emacs tutorial is available from the
;;    emacs help function: "Gold-PF2 t"


;; %% Starting TPU-edt

;;    All you have to do to start TPU-edt, is turn it on.  This can be
;;    done from the command line when running emacs.

;;        prompt> emacs -f tpu-edt

;;    If you've already started emacs, turn on TPU-edt using the tpu-edt
;;    command.  First press `M-x' (that's usually `ESC' followed by `x')
;;    and type `tpu-edt' followed by a carriage return.

;;    If you like TPU-edt and want to use it all the time, you can start
;;    TPU-edt using the emacs initialization file, .emacs.  Simply create
;;    a .emacs file in your home directory containing the line:

;;        (tpu-edt)

;;    That's all you need to do to start TPU-edt.


;; %% Customizing TPU-edt using the Emacs Initialization File

;;    The following is a sample emacs initialization file.  It shows how to
;;    invoke TPU-edt, and how to customize it.

;;    ; .emacs - a sample emacs initialization file

;;    ; Turn on TPU-edt
;;    (tpu-edt)

;;    ; Set scroll margins 10% (top) and 15% (bottom).
;;    (tpu-set-scroll-margins "10%" "15%")       

;;    ; Load the vtxxx terminal control functions.
;;    (load "vt-control" t)

;;    ; TPU-edt treats words like EDT; here's how to add word separators.
;;    ; Note that backslash (\) and double quote (") are quoted with '\'.
;;    (tpu-add-word-separators "]\\[-_,.\"=+()'/*#:!&;$")

;;    ; Emacs is happy to save files without a final newline; other Unix
;;    ; programs hate that!  Here we make sure that files end with newlines.
;;    (setq require-final-newline t)

;;    ; Emacs uses Control-s and Control-q.  Problems can occur when using
;;    ; emacs on terminals that use these codes for flow control (Xon/Xoff
;;    ; flow control).  These lines disable emacs' use of these characters.
;;    (global-unset-key "\C-s")
;;    (global-unset-key "\C-q")

;;    ; The emacs universal-argument function is very useful.
;;    ; This line maps universal-argument to Gold-PF1.
;;    (define-key GOLD-SS3-map "P" 'universal-argument)          ; Gold-PF1

;;    ; Make KP7 move by paragraphs, instead of pages.
;;    (define-key SS3-map "w" 'tpu-paragraph)                    ; KP7

;;    ; Repeat the preceding mappings for X-windows.
;;    (cond
;;     (window-system
;;      (global-set-key [kp_7] 'tpu-paragraph)                   ; KP7
;;      (define-key GOLD-map [kp_f1] 'universal-argument)))      ; GOLD-PF1

;;    ; Display the TPU-edt version.
;;    (tpu-version)


;; %% Regular Expressions in TPU-edt

;;    Gold-* toggles TPU-edt regular expression mode.  In regular expression
;;    mode, find, find next, replace, and substitute accept emacs regular
;;    expressions.  A complete list of emacs regular expressions can be found
;;    using the emacs "info" command (it's somewhat like the VMS help
;;    command).  Try the following sequence of commands:

;;        DO info             <enter info mode>
;;        m emacs             <select the "emacs" topic>
;;        m regexs            <select the "regular expression" topic>

;;    Type "q" to quit out of info mode.

;;    There is a problem in regular expression mode when searching for empty
;;    strings, like beginning-of-line (^) and end-of-line ($).  When searching
;;    for these strings, find-next may find the current string, instead of the
;;    next one.  This can cause global replace and substitute commands to loop
;;    forever in the same location.  For this reason, commands like

;;        replace "^" "> "       <add "> " to beginning of line>
;;        replace "$" "00711"    <add "00711" to end of line>

;;    may not work properly.

;;    Commands like those above are very useful for adding text to the
;;    beginning or end of lines.  They might work on a line-by-line basis, but
;;    go into an infinite loop if the "all" response is specified.  If the
;;    goal is to add a string to the beginning or end of a particular set of
;;    lines TPU-edt provides functions to do this.

;;        Gold-^  Add a string at BOL in region or buffer
;;        Gold-$  Add a string at EOL in region or buffer

;;    There is also a TPU-edt interface to the native emacs string replacement
;;    commands.  Gold-/ invokes this command.  It accepts regular expressions
;;    if TPU-edt is in regular expression mode.  Given a repeat count, it will
;;    perform the replacement without prompting for confirmation.

;;    This command replaces empty strings correctly, however, it has its
;;    drawbacks.  As a native emacs command, it has a different interface
;;    than the emulated TPU commands.  Also, it works only in the forward
;;    direction, regardless of the current TPU-edt direction.

;;; Set Options:
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)


(defconst default-justification 'full
  "*Method of justifying text not otherwise specified.
Possible values are `left', `right', `full', `center', or `none'.
The requested kind of justification is done whenever lines are filled.
The `justification' text-property  can locally override this variable.
This variable automatically becomes buffer-local when set in any fashion.")

;(menu-bar-mode -1)
(setq compile-command '"gmake debug")
(setq find-file-not-true-dirname-list t)
(setq find-file-existing-other-name t)
(setq auto-save-interval 1024)
(setq scroll-conservatively 1)
(setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 88 96 104 112 120))
(setq-default indent-tabs-mode nil)   ; indent using spaces only

;Alist of filename patterns vs corresponding major mode functions.
;Each element looks like (REGEXP . FUNCTION).
;Visiting a file whose name matches REGEXP causes FUNCTION to be called.")
(setq auto-mode-alist (mapcar 'purecopy
   '( ("\\.text\\'" . text-mode)
      ("\\.c\\'" . c-mode)       ("\\.h\\'" . c-mode)
      ("\\.m\\'" . c-mode)
      ("\\.cc\\'" . c++-mode)    ("\\.hh\\'" . c++-mode)
      ("\\.cpp\\'" . c++-mode)   ("\\.hpp\\'" . c++-mode)
      ("\\.cxx\\'" . c++-mode)
      ("\\.C\\'" . c++-mode)     ("\\.H\\'" . c++-mode)
      ("\\.java\\'" . java-mode)
      ("\\.tex\\'" . TeX-mode)
      ("\\.ltx\\'" . LaTeX-mode)
      ("\\.el\\'" . emacs-lisp-mode)
      ("\\.mm\\'" . nroff-mode)
      ("\\.me\\'" . nroff-mode)
      ("\\.ms\\'" . nroff-mode)
      ("\\.man\\'" . nroff-mode)
      ("\\.scm\\'" . scheme-mode)
      ("\\.l\\'" . lisp-mode) ("\\.lisp\\'" . lisp-mode)
      ("\\.f\\'" . fortran-mode) ("\\.for\\'" . fortran-mode)
      ("\\.mss\\'" . scribe-mode)
      ("\\.pl\\'" . prolog-mode)
      ("\\.py\\'" . python-mode)
      ("\\.mak\\'" . makefile-mode) ("[Mm]akefile" . makefile-mode)
      ("\\.s\\'" . asm-mode)
      ("ChangeLog\\'" . change-log-mode)
      ("ChangeLog.[0-9]+\\'" . change-log-mode)
      ("\\$CHANGE_LOG\\$\\.TXT" . change-log-mode)
      ("\\.[12345678]\\'" . nroff-mode)
      ("\\.TeX\\'" . TeX-mode)
      ("\\.sty\\'" . LaTeX-mode) ("\\.bbl\\'" . LaTeX-mode)
      ("\\.bib\\'" . bibtex-mode)
      ("\\.article\\'" . text-mode) ("\\.letter\\'" . text-mode)
      ("\\.texinfo\\'" . texinfo-mode) ("\\.texi\\'" . texinfo-mode)
      ("\\.lsp\\'" . lisp-mode)
      ("\\.awk\\'" . awk-mode)
      ("\\.prolog\\'" . prolog-mode)
      ("\\.tar\\'" . tar-mode)
      ("^/tmp/Re" . text-mode) ("/Message[0-9]*\\'" . text-mode) ("^/tmp/fol/" . text-mode)
      ("\\.y\\'" . c-mode)
      ("\\.lex\\'" . c-mode)
      ("\\.oak\\'" . scheme-mode)
      ("\\.scm.[0-9]*\\'" . scheme-mode)
      ("\\.sgm\\'" . sgml-mode)
      ("\\.sgml\\'" . sgml-mode)
      ("\\.dtd\\'" . sgml-mode)
      ("[]>:/]\\..*emacs\\'" . emacs-lisp-mode)
      ("\\.ml\\'" . lisp-mode))))

; C-mode
(setq my-c-style
    '( (c-comment-only-line-offset . 4)
       (c-cleanup-list . 
           (scope-operator empty-defun-braces defun-close-semi))
       (c-offsets-alist . (
           (arglist-close . c-lineup-arglist)
           (defun-block-intro . 0)
	   (func-decl-cont . 4)
           (inclass . 0)
           (substatement . 4)
           (substatement-open . 4)
           (statement-block-intro . 0)
           )
       )
    )
)

;(defun my-c-mode-hook nil
;  ""
;  (setq indent-tabs-mode nil)
  ;(c-add-style "my-style" my-c-style t)
;)

;(add-hook 'c-mode-common-hook my-c-mode-hook)
(add-hook 'c-mode-common-hook
     (function (lambda () (c-add-style "my-style" my-c-style t))))


;;; Code:


;;;
;;;  Version Information
;;;
(defconst tpu-version "4.2" "TPU-edt version number.")


;;;
;;;  User Configurable Variables
;;;
(defconst tpu-have-ispell t
  "*If non-nil (default), TPU-edt uses ispell for spell checking.")

(defconst tpu-kill-buffers-silently nil
  "*If non-nil, TPU-edt kills modified buffers without asking.")

(defvar tpu-percent-scroll 75
  "*Percentage of the screen to scroll for next/previous screen commands.")

(defvar tpu-pan-columns 16
  "*Number of columns the tpu-pan functions scroll left or right.")

(defvar picture-killed-rectangle nil
  "Saved text for tpu-paste.")

;;;
;;;  Emacs version identifiers - currently referenced by
;;;
;;;     o tpu-mark              o tpu-set-mark
;;;     o tpu-string-prompt     o tpu-regexp-prompt
;;;     o tpu-edt-on            o tpu-load-xkeys
;;;     o tpu-update-mode-line  o mode line section
;;;
(defconst tpu-emacs19-p (not (string-lessp emacs-version "19"))
  "Non-nil if we are running Lucid Emacs or version 19.")

(defconst tpu-lucid-emacs19-p
  (and tpu-emacs19-p (string-match "Lucid" emacs-version))
  "Non-nil if we are running Lucid Emacs version 19.")


;;;
;;;  Global Keymaps
;;;
;XTPU;(defvar CSI-map (make-sparse-keymap)
;XTPU;  "Maps the CSI function keys on the VT100 keyboard.
;XTPU;CSI is DEC's name for the sequence <ESC>[.")

;XTPU;(defvar SS3-map (make-sparse-keymap)
;XTPU;  "Maps the SS3 function keys on the VT100 keyboard.
;XTPU;SS3 is DEC's name for the sequence <ESC>O.")

(defvar GOLD-map (make-keymap)
  "Maps the function keys on the VT100 keyboard preceded by PF1.
GOLD is the ASCII 7-bit escape sequence <ESC>OP.")

;XTPU;(defvar GOLD-CSI-map (make-sparse-keymap)
;XTPU;  "Maps the function keys on the VT100 keyboard preceded by GOLD-CSI.")

;XTPU;(defvar GOLD-SS3-map (make-sparse-keymap)
;XTPU;  "Maps the function keys on the VT100 keyboard preceded by GOLD-SS3.")

(defvar tpu-global-map nil "TPU-edt global keymap.")
(defvar tpu-original-global-map (copy-keymap global-map)
  "Original global keymap.")

(and tpu-lucid-emacs19-p
     (defvar minibuffer-local-ns-map (make-sparse-keymap)
       "Hack to give Lucid Emacs the same maps as ordinary Emacs."))


;;;
;;;  Global Variables
;;;
(defvar tpu-edt-mode nil
  "If non-nil, TPU-edt mode is active.")

(defvar tpu-last-replaced-text ""
  "Last text deleted by a TPU-edt replace command.")
(defvar tpu-last-deleted-region ""
  "Last text deleted by a TPU-edt remove command.")
(defvar tpu-last-deleted-lines ""
  "Last text deleted by a TPU-edt line-delete command.")
(defvar tpu-last-deleted-words ""
  "Last text deleted by a TPU-edt word-delete command.")
(defvar tpu-last-deleted-char ""
  "Last character deleted by a TPU-edt character-delete command.")

(defvar tpu-searching-forward t
  "If non-nil, TPU-edt is searching in the forward direction.")
(defvar tpu-search-last-string ""
  "Last text searched for by the TPU-edt search commands.")

(defvar tpu-regexp-p nil
  "If non-nil, TPU-edt uses regexp search and replace routines.")
(defvar tpu-rectangular-p nil
  "If non-nil, TPU-edt removes and inserts rectangles.")
(defvar tpu-advance t
  "True when TPU-edt is operating in the forward direction.")
(defvar tpu-reverse nil
  "True when TPU-edt is operating in the backward direction.")
(defvar tpu-control-keys nil
  "If non-nil, control keys are set to perform TPU functions.")
(defvar tpu-xkeys-file nil
  "File containing TPU-edt X key map.")

(defvar tpu-rectangle-string nil
  "Mode line string to identify rectangular mode.")
(defvar tpu-direction-string nil
  "Mode line string to identify current direction.")

(defvar tpu-add-at-bol-hist nil
  "History variable for tpu-edt-add-at-bol function.")
(defvar tpu-add-at-eol-hist nil
  "History variable for tpu-edt-add-at-eol function.")
(defvar tpu-regexp-prompt-hist  nil
  "History variable for search and replace functions.")


;;;
;;;  Buffer Local Variables
;;;
(defvar tpu-newline-and-indent-p nil
  "If non-nil, Return produces a newline and indents.")
(make-variable-buffer-local 'tpu-newline-and-indent-p)

(defvar tpu-newline-and-indent-string nil
  "Mode line string to identify AutoIndent mode.")
(make-variable-buffer-local 'tpu-newline-and-indent-string)

(defvar tpu-saved-delete-func nil
  "Saved value of the delete key.")
(make-variable-buffer-local 'tpu-saved-delete-func)

(defvar tpu-buffer-local-map nil
  "TPU-edt buffer local key map.")
(make-variable-buffer-local 'tpu-buffer-local-map)


;;;
;;;  Mode Line - Modify the mode line to show the following
;;;
;;;     o  If the mark is set.
;;;     o  Direction of motion.
;;;     o  Active rectangle mode.
;;;
(defvar tpu-original-mode-line mode-line-format)
(defvar tpu-original-mm-alist minor-mode-alist)

(defvar tpu-mark-flag " ")
(make-variable-buffer-local 'tpu-mark-flag)

(defun tpu-set-mode-line (for-tpu)
  "Set the mode for TPU-edt, or reset it to default Emacs."
  (cond ((not for-tpu)
	 (setq mode-line-format tpu-original-mode-line)
	 (setq minor-mode-alist tpu-original-mm-alist))
	(t
	 (setq-default mode-line-format
		       (list (purecopy "-")
			     'mode-line-mule-info
			     'mode-line-modified
			     'mode-line-frame-identification
			     'mode-line-buffer-identification
			     (purecopy "  ")
			     'global-mode-string
			     (purecopy "  ")
			     'tpu-mark-flag
			     (purecopy " %[(")
			     'mode-name 'mode-line-process 'minor-mode-alist
			     (purecopy "%n")
			     (purecopy ")%]--")
			     (purecopy '(line-number-mode "L%l--"))
			     (purecopy '(column-number-mode "C%c--"))
			     (purecopy '(-3 . "%p"))
			     (purecopy "-%-")))
	 (or (assq 'tpu-newline-and-indent-p minor-mode-alist)
	     (setq minor-mode-alist
		   (cons '(tpu-newline-and-indent-p
			   tpu-newline-and-indent-string)
			 minor-mode-alist)))
	 (or (assq 'tpu-rectangular-p minor-mode-alist)
	     (setq minor-mode-alist
		   (cons '(tpu-rectangular-p tpu-rectangle-string)
			 minor-mode-alist)))
	 (or (assq 'tpu-direction-string minor-mode-alist)
	     (setq minor-mode-alist
		   (cons '(tpu-direction-string tpu-direction-string)
			 minor-mode-alist))))))

(defun tpu-update-mode-line nil
  "Make sure mode-line in the current buffer reflects all changes."
  (setq tpu-mark-flag (if (tpu-mark) "M" " "))
  (cond (tpu-emacs19-p (force-mode-line-update))
	(t (set-buffer-modified-p (buffer-modified-p)) (sit-for 0))))

(cond (tpu-lucid-emacs19-p
       (add-hook 'zmacs-deactivate-region-hook 'tpu-update-mode-line)
       (add-hook 'zmacs-activate-region-hook 'tpu-update-mode-line))
      (tpu-emacs19-p
       (add-hook 'activate-mark-hook 'tpu-update-mode-line)
       (add-hook 'deactivate-mark-hook 'tpu-update-mode-line)))


;;;
;;;  Match Markers -
;;;
;;;     Set in:  Search
;;;
;;;     Used in: Replace, Substitute, Store-Text, Cut/Remove,
;;;              Append, and Change-Case
;;;
(defvar tpu-match-beginning-mark (make-marker))
(defvar tpu-match-end-mark (make-marker))

(defun tpu-set-match nil
  "Set markers at match beginning and end."
  ;; Add one to beginning mark so it stays with the first character of
  ;;   the string even if characters are added just before the string.
  (setq tpu-match-beginning-mark (copy-marker (1+ (match-beginning 0))))
  (setq tpu-match-end-mark (copy-marker (match-end 0))))

(defun tpu-unset-match nil
  "Unset match beginning and end markers."
  (set-marker tpu-match-beginning-mark nil)
  (set-marker tpu-match-end-mark nil))

(defun tpu-match-beginning nil
  "Returns the location of the last match beginning."
  (1- (marker-position tpu-match-beginning-mark)))

(defun tpu-match-end nil
  "Returns the location of the last match end."
  (marker-position tpu-match-end-mark))

(defun tpu-check-match nil
  "Returns t if point is between tpu-match markers.
Otherwise sets the tpu-match markers to nil and returns nil."
  ;; make sure 1- marker is in this buffer
  ;;           2- point is at or after beginning marker
  ;;           3- point is before ending marker, or in the case of
  ;;              zero length regions (like bol, or eol) that the
  ;;              beginning, end, and point are equal.
  (cond ((and
	  (equal (marker-buffer tpu-match-beginning-mark) (current-buffer))
	  (>= (point) (1- (marker-position tpu-match-beginning-mark)))
	  (or
	   (< (point) (marker-position tpu-match-end-mark))
	   (and (= (1- (marker-position tpu-match-beginning-mark))
		   (marker-position tpu-match-end-mark))
		(= (marker-position tpu-match-end-mark) (point))))) t)
	(t
	 (tpu-unset-match) nil)))

(defun tpu-show-match-markers nil
  "Show the values of the match markers."
  (interactive)
  (if (markerp tpu-match-beginning-mark)
      (let ((beg (marker-position tpu-match-beginning-mark)))
	(message "(%s, %s) in %s -- current %s in %s"
		 (if beg (1- beg) nil)
		 (marker-position tpu-match-end-mark)
		 (marker-buffer tpu-match-end-mark)
		 (point) (current-buffer)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; tpu-find-balance-point                                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tpu-find-balance-point ()
  "Go to the matching parenthesis {}()[]."
  (interactive)
  (cond
    ((looking-at "[\(\[{]")
      (forward-sexp 1)
      (backward-char) )
    ((looking-at "[])}]")
      (forward-char)
      (backward-sexp 1) )
  ) 
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; tpu-toggle-line-trunc                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tpu-toggle-line-trunc ()
  "Toggle between rightside window borde line truncation and line wrap mode."
  (interactive)
  (setq truncate-lines (not truncate-lines))
  (redraw-display)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; tpu-indent-code-left                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tpu-indent-code-left ()
  "Shift region of code one indentation level to the left."
  (interactive)
  (indent-rigidly (mark) (point) -4)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; tpu-indent-code-right                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tpu-indent-code-right ()
  "Shift region of code one indentation level to the right."
  (interactive)
  (indent-rigidly (mark) (point) 4)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; tpu-insert-func-tmpl                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tpu-insert-func-tmpl (name)
  "Insert a commented function template appropriate for the current major
mode using the supplied argument as the function name."
  (interactive "sFunction Name: ")
  (if (equal mode-name "C")
      (save-excursion
        (insert "/******************************************************************************\n")
        (insert (concat "* FUNCTION: " name "\t\t\t\t\t\t\t\t      *\n"))
        (insert "******************************************************************************/\n")
        (insert (concat "int " name "\n\n"))
        (insert "    (/* Arguments */\n    int   arg1,\n    int   arg2)\n\n")
        (insert "{   /* Local Variables */\n\n")
        (insert (concat "/* BEGIN " name " */\n"))
        (insert (concat "}/* END " name " */\n"))
      ))
)


;;;
;;;  Utilities
;;;
(defun tpu-caar (thingy) (car (car thingy)))
(defun tpu-cadr (thingy) (car (cdr thingy)))

(defun tpu-mark nil
  "TPU-edt version of the mark function.
Return the appropriate value of the mark for the current
version of Emacs."
  (cond (tpu-lucid-emacs19-p (mark (not zmacs-regions)))
	(tpu-emacs19-p (and mark-active (mark (not transient-mark-mode))))
	(t (mark))))

(defun tpu-set-mark (pos)
  "TPU-edt verion of the `set-mark' function.
Sets the mark at POS and activates the region according to the
current version of Emacs."
  (set-mark pos)
  (and tpu-lucid-emacs19-p pos (zmacs-activate-region)))

(defun tpu-string-prompt (prompt history-symbol)
  "Read a string with PROMPT."
  (if tpu-emacs19-p
      (read-from-minibuffer prompt nil nil nil history-symbol)
    (read-string prompt)))

(defvar tpu-last-answer nil "Most recent response to tpu-y-or-n-p.")

(defun tpu-y-or-n-p (prompt &optional not-yes)
  "Prompt for a y or n answer with positive default.
Optional second argument NOT-YES changes default to negative.
Like Emacs `y-or-n-p', but also accepts space as y and DEL as n."
  (message "%s[%s]" prompt (if not-yes "n" "y"))
  (let ((doit t))
    (while doit
      (setq doit nil)
      (let ((ans (read-char)))
	(cond ((or (= ans ?y) (= ans ?Y) (= ans ?\ ))
	       (setq tpu-last-answer t))
	      ((or (= ans ?n) (= ans ?N) (= ans ?\C-?))
	       (setq tpu-last-answer nil))
	      ((= ans ?\r) (setq tpu-last-answer (not not-yes)))
	      (t
	       (setq doit t) (beep)
	       (message "Please answer y or n.  %s[%s]"
			prompt (if not-yes "n" "y")))))))
  tpu-last-answer)

(defun tpu-local-set-key (key func)
  "Replace a key in the TPU-edt local key map.
Create the key map if necessary."
  (cond ((not (keymapp tpu-buffer-local-map))
	 (setq tpu-buffer-local-map (if (current-local-map)
					(copy-keymap (current-local-map))
				      (make-sparse-keymap)))
	 (use-local-map tpu-buffer-local-map)))
  (local-set-key key func))

(defun tpu-current-line nil
  "Return the vertical position of point in the selected window.
Top line is 0.  Counts each text line only once, even if it wraps."
  (+ (count-lines (window-start) (point)) (if (= (current-column) 0) 1 0) -1))


;;;
;;;  Breadcrumbs
;;;
(defvar tpu-breadcrumb-plist nil
  "The set of user-defined markers (breadcrumbs), as a plist.")

(defun tpu-drop-breadcrumb (num)
  "Drops a breadcrumb that can be returned to later with goto-breadcrumb."
  (interactive "p")
  (put tpu-breadcrumb-plist num (list (current-buffer) (point)))
  (message "Mark %d set." num))

(defun tpu-goto-breadcrumb (num)
  "Returns to a breadcrumb set with drop-breadcrumb."
  (interactive "p")
  (cond ((get tpu-breadcrumb-plist num)
	 (switch-to-buffer (car (get tpu-breadcrumb-plist num)))
	 (goto-char (tpu-cadr (get tpu-breadcrumb-plist num)))
	 (message "mark %d found." num))
	(t
	 (message "mark %d not found." num))))


;;;
;;;  Miscellaneous
;;;
(defun tpu-change-case (num)
  "Change the case of the character under the cursor or region.
Accepts a prefix argument of the number of characters to invert."
  (interactive "p")
  (cond ((tpu-mark)
	 (let ((beg (region-beginning)) (end (region-end)))
	   (while (> end beg)
	     (funcall (if (= (downcase (char-after beg)) (char-after beg))
			  'upcase-region 'downcase-region)
		      beg (1+ beg))
	     (setq beg (1+ beg)))
	   (tpu-unselect t)))
	((tpu-check-match)
	 (let ((beg (tpu-match-beginning)) (end (tpu-match-end)))
	   (while (> end beg)
	     (funcall (if (= (downcase (char-after beg)) (char-after beg))
			  'upcase-region 'downcase-region)
		      beg (1+ beg))
	     (setq beg (1+ beg)))
	   (tpu-unset-match)))
	(t
	 (while (> num 0)
	   (funcall (if (= (downcase (following-char)) (following-char))
			'upcase-region 'downcase-region)
		    (point) (1+ (point)))
	   (forward-char (if tpu-reverse -1 1))
	   (setq num (1- num))))))

(defun tpu-fill (num)
  "Fill paragraph or marked region.
With argument, fill and justify."
  (interactive "P")
  (cond ((tpu-mark)
	 (fill-region (point) (tpu-mark) num)
	 (tpu-unselect t))
	(t
	 (fill-paragraph num))))

(defun tpu-version nil
  "Print the TPU-edt version number."
  (interactive)
  (message
   "TPU-edt version %s by Rob Riepel (riepel@networking.stanford.edu)"
   tpu-version))

(defun tpu-reset-screen-size (height width)
  "Sets the screen size."
  (interactive "nnew screen height: \nnnew screen width: ")
  (set-frame-height (selected-frame) height)
  (set-frame-width (selected-frame) width))

(defun tpu-toggle-newline-and-indent nil
  "Toggle between 'newline and indent' and 'simple newline'."
  (interactive)
  (cond (tpu-newline-and-indent-p
         (setq tpu-newline-and-indent-string "")
         (setq tpu-newline-and-indent-p nil)
         (tpu-local-set-key "\C-m" 'newline))
        (t
         (setq tpu-newline-and-indent-string " AutoIndent")
         (setq tpu-newline-and-indent-p t)
         (tpu-local-set-key "\C-m" 'newline-and-indent)))
  (tpu-update-mode-line)
  (and (interactive-p)
       (message "Carriage return inserts a newline%s"
		(if tpu-newline-and-indent-p " and indents." "."))))

(defun tpu-spell-check nil
  "Checks the spelling of the region, or of the entire buffer if no
 region is selected."
  (interactive)
  (cond (tpu-have-ispell
	 (if (tpu-mark) (ispell-region (tpu-mark) (point)) (ispell-buffer)))
	(t
	 (if (tpu-mark) (ispell-region (tpu-mark) (point)) (ispell-buffer))))
  (if (tpu-mark) (tpu-unselect t)))

(defun tpu-toggle-overwrite-mode nil
  "Switches in and out of overwrite mode"
  (interactive)
  (cond (overwrite-mode
	 (tpu-local-set-key "\177" tpu-saved-delete-func)
	 (overwrite-mode 0))
	(t
	 (setq tpu-saved-delete-func (local-key-binding "\177"))
	 (tpu-local-set-key "\177" 'picture-backward-clear-column)
	 (overwrite-mode 1))))

(defun tpu-special-insert (num)
  "Insert a character or control code according to
its ASCII decimal value."
  (interactive "P")
  (if overwrite-mode (delete-char 1))
  (insert (if num num 0)))

(defun tpu-quoted-insert (num)
  "Read next input character and insert it.
This is useful for inserting control characters."
  (interactive "*p")
  (let ((char (read-char)) )
    (if overwrite-mode (delete-char num))
    (insert-char char num)))


;;;
;;;  TPU line-mode commands
;;;
(defun tpu-include (file)
  "TPU-like include file"
  (interactive "fInclude file: ")
  (save-excursion
    (insert-file-contents file)
    (message "")))

(defun tpu-get (file)
  "TPU-like get file"
  (interactive "FFile to get: ")
  (find-file file))

(defun tpu-what-line nil
  "Tells what line the point is on,
 and the total number of lines in the buffer."
  (interactive)
  (if (eobp)
      (message "You are at the End of Buffer.  The last line is %d."
	       (count-lines 1 (point-max)))
    (message "Line %d of %d"
	     (count-lines 1 (1+ (point)))
	     (count-lines 1 (point-max)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; tpu-what-position                                                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tpu-what-position ()
  "Print info on cursor position (on screen and within buffer)."
  (interactive)
  (if (eobp)
      (message "You are at the End of Buffer.  The last line is %d."
               (count-lines 1 (point-max)))
; ELSE     
      (let* ((char (following-char))
	 (beg (point-min))
	 (end (point-max))
         (pos (point))
	 (total (buffer-size))
	 (percent (if (> total 50000)
		      ;; Avoid overflow from multiplying by 100!
		      (/ (+ (/ total 200) (1- pos)) (max (/ total 100) 1))
		    (/ (+ (/ total 2) (* 100 (1- pos))) (max total 1))))
	 (hscroll (if (= (window-hscroll) 0)
		      ""
		    (format " Hscroll=%d" (window-hscroll))))
	 (col (current-column))
	 (line (count-lines 1 (1+ pos)))
	 (last (count-lines 1 end)) )
	(message "Char: %s (0%o)  point=%d of %d(%d%%)  column %d %s  Line: %d (%d)"
		 (single-key-description char) char pos total percent col 
		 hscroll line last)))
)

(defun tpu-exit nil
  "Exit the way TPU does, save current buffer and ask about others."
  (interactive)
  (if (not (eq (recursion-depth) 0))
      (exit-recursive-edit)
    (progn (save-buffer) (save-buffers-kill-emacs))))

(defun tpu-quit nil
  "Quit the way TPU does, ask to make sure changes should be abandoned."
  (interactive)
  (let ((list (buffer-list))
	(working t))
    (while (and list working)
      (let ((buffer (car list)))
	(if (and (buffer-file-name buffer) (buffer-modified-p buffer))
            (if (tpu-y-or-n-p
		 "Modifications will not be saved, continue quitting? ")
		(kill-emacs t) (setq working nil)))
	(setq list (cdr list))))
    (if working (kill-emacs t))))


;;;
;;;  Command and Function Aliases
;;;
;;;###autoload
(fset 'tpu-edt-mode 'tpu-edt-on)
(fset 'TPU-EDT-MODE 'tpu-edt-on)

;;;###autoload
(fset 'tpu-edt 'tpu-edt-on)
(fset 'TPU-EDT 'tpu-edt-on)

(fset 'exit 'tpu-exit)
(fset 'EXIT 'tpu-exit)

(fset 'Get 'tpu-get)
(fset 'GET 'tpu-get)

(fset 'include 'tpu-include)
(fset 'INCLUDE 'tpu-include)

(fset 'quit 'tpu-quit)
(fset 'QUIT 'tpu-quit)

(fset 'spell 'tpu-spell-check)
(fset 'SPELL 'tpu-spell-check)

(fset 'what\ line 'tpu-what-line)
(fset 'WHAT\ LINE 'tpu-what-line)

(fset 'replace 'tpu-lm-replace)
(fset 'REPLACE 'tpu-lm-replace)

;; Apparently TPU users really expect to do M-x help RET to get help.
;; So it is really necessary to redefine this.
(fset 'help 'tpu-help)
(fset 'HELP 'tpu-help)

(fset 'set\ cursor\ free 'tpu-set-cursor-free)
(fset 'SET\ CURSOR\ FREE 'tpu-set-cursor-free)

(fset 'set\ cursor\ bound 'tpu-set-cursor-bound)
(fset 'SET\ CURSOR\ BOUND 'tpu-set-cursor-bound)

(fset 'set\ scroll\ margins 'tpu-set-scroll-margins)
(fset 'SET\ SCROLL\ MARGINS 'tpu-set-scroll-margins)


;; Around emacs version 18.57, function line-move was renamed to
;; next-line-internal.  If we're running under an older emacs,
;; make next-line-internal equivalent to line-move.

(if (not (fboundp 'next-line-internal)) (fset 'next-line-internal 'line-move))


;;;
;;;  Help
;;;
;(defconst tpu-help-keypad-map "\f
;          _______________________    _______________________________
;         | HELP  |      Do       |  |       |       |       |       |
;         |KeyDefs|               |  |       |       |       |       |
;         |_______|_______________|  |_______|_______|_______|_______|
;          _______________________    _______________________________
;         | Find  |Insert |Remove |  | Gold  | HELP  |FndNxt | Del L |
;         |       |       |Sto Tex|  |  key  |E-Help | Find  |Undel L|
;         |_______|_______|_______|  |_______|_______|_______|_______|
;         |Select |Pre Scr|Nex Scr|  | Page  | Sect  |Append | Del W |
;         | Reset |Pre Win|Nex Win|  |  Do   | Fill  |Replace|Undel W|
;         |_______|_______|_______|  |_______|_______|_______|_______|
;                 |Move up|          |Forward|Reverse|Remove | Del C |
;                 |  Top  |          |Bottom |  Top  |Insert |Undel C|
;          _______|_______|_______   |_______|_______|_______|_______|
;         |Mov Lef|Mov Dow|Mov Rig|  | Word  |  EOL  | Char  |       |
;         |StaOfLi|Bottom |EndOfLi|  |ChngCas|Del EOL|SpecIns| Enter |
;         |_______|_______|_______|  |_______|_______|_______|       |
;                                    |     Line      |Select | Subs  |
;                                    |   Open Line   | Reset |       |
;                                    |_______________|_______|_______|
;")
(defconst tpu-help-keypad-map "\f
          _______________________    _______________________________
         | HELP  |      Do       |  |       |       |       |       |
         |KeyDefs|               |  |       |       |       |       |
         |_______|_______________|  |_______|_______|_______|_______|
          _______________________    _______________________________
         | Find  |Insert |Remove |  | Gold  | HELP  |FndNxt | Del L |
         |       |       |Sto Tex|  |  key  |E-Help | Find  |Undel L|
         |_______|_______|_______|  |_______|_______|_______|_______|
         |Select |Scr Dwn|Scr  Up|  |Pre Scr|Nxt Scr| Store |       |
         | Reset |Pre Win|Nxt Win|  |  Do   | Fill  | Paste | Del W |
         |_______|_______|_______|  |_______|_______|_______|       |
                 |Move up|          |Forward|Reverse|Remove |       |
                 |  Top  |          |Bottom |  Top  | Paste |Undel W|
          _______|_______|_______   |_______|_______|_______|_______|
         |Mov Lef|Mov Dow|Mov Rig|  | Word  |  EOL  | Del C |       |
         |StaOfLi|Bottom |EndOfLi|  |ChngCas|Del EOL|Undel C| Other |
         |_______|_______|_______|  |_______|_______|_______|  Win  |
                                    |     Line      |Select |       |
                                    |   Open Line   | Reset | Subs  |
                                    |_______________|_______|_______|
")

(defconst tpu-help-text "
\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\f

      Control Characters

      ^A  Beginning of line
      ^B  Back one character

      ^D  Delete current character
      ^E  End of line
      ^F  Forward one character
      ^G  Cancel current operation
      ^H  Help on emacs

      ^J  Insert New line and indent
      ^K  Kill line
      ^L  Center current line
      ^M  New line
      ^N  Next line
      ^O  Open a new line
      ^P  Previous line
      ^Q  Quoted character insert
      ^R  Incremental search in reverse
      ^S  Incremental search forward
      ^T  Transpose previous two characters                                   \f
      ^U  Enter repeat count
      ^V  Scroll up
      ^W  Window refresh

      ^Y  Yank from cut/paste buffer
      ^Z  Suspend emacs
      ^X^X  exchange point and mark - useful for checking region boundaries
\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\f
       Gold-<key> Functions

       a     Toggle Newline and Newline+Indent mode
       A     Display the ASCII character table
       b     Goto or create a specific buffer.
       B     Display the buffer list menu
       c     Create or load specified file
       C     Compile start
       [dD]  Execute supplied shell command and put output in buffer
       e     Exit emacs and ask about unsaved buffers
       E     Exit - save current buffer and ask about others
       [fF]  Find and load, or create, specified file
       g     Goto a specific line number
       G     TPU style: get file
       [hH]  <Not Defined>
       i     Insert a file in this buffer
       I     TPU style: Insert a file in this buffer
       [jJ]  Toggle line truncation/line wrap mode
       k     Cut rectangle between mark and point
       K     Yank rectangle
       l     List buffers in new window
       L     What line is this                                                \f
       m     Ask if each modified buffer should be saved
       M     Buffer Menu - display a list of all buffers
       n     goto Next compliation error
       N     Next File Buffer - display next buffer containing a file
       o     Switch to specified buffer in other window
       O     Occur - show following lines containing REGEXP
       p     Print region contents as with Unix command `lpr'
       P     Print buffer contents as with Unix command `lpr'
       q     TPU style: Quit - exit without saving anything
       Q     Exit the Emacs job and kill it
       r     Replace string interactively
       R     Replace string non-interactively
       s     Save buffer if modified
       S     <Undefined>
       t     Trim trailing white space from every line in the buffer
       T     Template function insert according to language
       [uU]  Undo - undo the last edit
       v     Visit another file in another window
       V     Show what version of TPU-EDT this is
       w     Write current buffer to specified file
       W     Save current buffer if modified
       x     Execute last saved keyboard macro via PF1-[ & PF1-]              \f
       X     Exit - save all modified buffers and exit

       !     Goto matching brace, bracket or parenthesis
       @     Where is the cursor in the current buffer
       $     Add text to the end of each line in the region or buffer
       %     Goto a supplied percentage point in the current buffer
       ^     Move point to location stored in a register
       *     Toggle TPU regular expression search mode
       -     Delete the current window point is in if more than one window
       _     Split current window in half one above the other
       =     Save current pointer to a lettered register
       +     Split current window in half one above the other
       |     Split current window in half one beside the other
       \     Previous Buffer - display the previous buffer (all buffers)
       /     Next Buffer     - display the next buffer (all buffers)
       [     Start keyboard macro recording
       ]     End keyboard macro recording, execute via PF1-x
       }     Set right fill column to current column of point
       ;     Justify current line within fill column
       :     Justify and fill current region within fill column
       ~     Exchange point with mark
       <     Indent current region one code level to the left                 \f
       >     Indent current region one code level to the right
       ,     Drop a breadcrumb that can be returned to later
       `     Returns to a breadcrumb

       C-A   Toggle insert/overstrike mode

    M-x help-for-help <CR> p <CR>

  Where `M-x' might be any of `Gold-KP7', 'Do', or 'ESC-x'.

  When you successfully invoke this part of the Emacs help facility, you
  will see a buffer named `*Finder*' listing a number of topics.  Look for
  tpu-edt under `emulations'.

\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\f

   *** No more help, use P to view previous screen")

(defconst tpuC-ascii-table
" +----------------------+-----------------+-----------------+-----------------+
 | NUL ( ) 000 000 X00 | ( ) 032 040 X20 | (@) 064 100 X40 | (`) 096 140 X60 |
 | SOH () 001 001 X01 | (!) 033 041 X21 | (A) 065 101 X41 | (a) 097 141 X61 |
 | STX () 002 002 X02 | (\") 034 042 X22 | (B) 066 102 X42 | (b) 098 142 X62 |
 | ETX () 003 003 X03 | (#) 035 043 X23 | (C) 067 103 X43 | (c) 099 143 X63 |
 | EOT () 004 004 X04 | ($) 036 044 X24 | (D) 068 104 X44 | (d) 100 144 X64 |
 | ENQ () 005 005 X05 | (%) 037 045 X25 | (E) 069 105 X45 | (e) 101 145 X65 |
 | ACK () 006 006 X06 | (&) 038 046 X26 | (F) 070 106 X46 | (f) 102 146 X66 |
 | BEL () 007 007 X07 | (') 039 047 X27 | (G) 071 107 X47 | (g) 103 147 X67 |
 | BS  () 008 010 X08 | (() 040 050 X28 | (H) 072 110 X48 | (h) 104 150 X68 |
 | HT  (^I) 009 011 X09 | ()) 041 051 X29 | (I) 073 111 X49 | (i) 105 151 X69 |
 | LF  (^J) 010 012 X0A | (*) 042 052 X2A | (J) 074 112 X4A | (j) 106 152 X6A |
 | VT  () 011 013 X0B | (+) 043 053 X2B | (K) 075 113 X4B | (k) 107 153 X6B |
 | FF  () 012 014 X0C | (,) 044 054 X2C | (L) 076 114 X4C | (l) 108 154 X6C |
 | CR  () 013 015 X0D | (-) 045 055 X2D | (M) 077 115 X4D | (m) 109 155 X6D |
 | SO  () 014 016 X0E | (.) 046 056 X2E | (N) 078 116 X4E | (n) 110 156 X6E |
 | SI  () 015 017 X0F | (/) 047 057 X2F | (O) 079 117 X4F | (o) 111 157 X6F |
 | DLE () 016 020 X10 | (0) 048 060 X30 | (P) 080 120 X50 | (p) 112 160 X70 |
 | DC1 () 017 021 X11 | (1) 049 061 X31 | (Q) 081 121 X51 | (q) 113 161 X71 |
 | DC2 () 018 022 X12 | (2) 050 062 X32 | (R) 082 122 X52 | (r) 114 162 X72 |
 | DC3 () 019 023 X13 | (3) 051 063 X33 | (S) 083 123 X53 | (s) 115 163 X73 |
 | DC4 () 020 024 X14 | (4) 052 064 X34 | (T) 084 124 X54 | (t) 116 164 X74 |
 | NAK () 021 025 X15 | (5) 053 065 X35 | (U) 085 125 X55 | (u) 117 165 X75 |
 | SYN () 022 026 X16 | (6) 054 066 X36 | (V) 086 126 X56 | (v) 118 166 X76 |
 | ETB () 023 027 X17 | (7) 055 067 X37 | (W) 087 127 X57 | (w) 119 167 X77 |
 | CAN () 024 030 X18 | (8) 056 070 X38 | (X) 088 130 X58 | (x) 120 170 X78 |
 | EM  () 025 031 X19 | (9) 057 071 X39 | (Y) 089 131 X59 | (y) 121 171 X79 |
 | SUB () 026 032 X1A | (:) 058 072 X3A | (Z) 090 132 X5A | (z) 122 172 X7A |
 | ESC () 027 033 X1B | (;) 059 073 X3B | ([) 091 133 X5B | ({) 123 173 X7B |
 | FS  () 028 034 X1C | (<) 060 074 X3C | (\\) 092 134 X5C | (|) 124 174 X7C |
 | GS  () 029 035 X1D | (=) 061 075 X3D | (]) 093 135 X5D | (}) 125 175 X7D |
 | RS  () 030 036 X1E | (>) 062 076 X3E | (^) 094 136 X5E | (~) 126 176 X7E |
 | US  () 031 037 X1F | (?) 063 077 X3F | (_) 095 137 X5F | ()127 177 X7F |
 +----------------------+-----------------+-----------------+-----------------+")

(defvar tpu-help-enter (format "%s" "\eOM"))    ; tpu-help enter key symbol
(defvar tpu-help-return (format "%s" "\r"))     ; tpu-help enter key symbol
(defvar tpu-help-N "N")                         ; tpu-help "N" symbol
(defvar tpu-help-n "n")                         ; tpu-help "n" symbol
(defvar tpu-help-P "P")                         ; tpu-help "P" symbol
(defvar tpu-help-p "p")                         ; tpu-help "p" symbol

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; tpu-ascii-table                                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tpu-ascii-table nil
  "Display the ASCII table."
  (interactive)
;  (save-window-excursion
    ;; Create and fill ASCII table buffer if necessary
    (if (not (get-buffer "*ASCII Table*"))
        (progn
	(generate-new-buffer "*ASCII Table*")
        (switch-to-buffer "*ASCII Table*")
        (insert tpuC-ascii-table)
	(setq buffer-read-only t))
    ;ELSE
        (switch-to-buffer "*ASCII Table*")
        );ENDIF
    (tpu-move-to-beginning)
;    (forward-line 1)
;    (tpu-line-to-top-of-window)
;    )
)


(defun tpu-help nil
  "Display TPU-edt help."
  (interactive)
  ;; Save current window configuration
  (save-window-excursion
    ;; Create and fill help buffer if necessary
    (if (not (get-buffer "*TPU-edt Help*"))
	(progn (generate-new-buffer "*TPU-edt Help*")
	       (switch-to-buffer "*TPU-edt Help*")
	       (insert tpu-help-keypad-map)
	       (insert tpu-help-text)
	       (setq buffer-read-only t)))

    ;; Display the help buffer
    (switch-to-buffer "*TPU-edt Help*")
    (delete-other-windows)
    (tpu-move-to-beginning)
    (forward-line 1)
    (tpu-line-to-top-of-window)

    ;; Prompt for keys to describe, based on screen state (split/not split)
    (let ((key nil) (fkey nil) (split nil))
      (while (not (equal tpu-help-return fkey))
	(if split
	    (setq key
		  (read-key-sequence
		   "Press the key you want help on (RET=exit, ENTER=redisplay, N=next, P=prev): "))
	  (setq key
		(read-key-sequence
		 "Press the key you want help on (RET to exit, N next screen, P prev screen): ")))

	;; Process the read key
	;;
	;;    ENTER   -  Display just the help window
	;;    N or n  -  Next help or describe-key screen
	;;    P or p  -  Previous help or describe-key screen
	;;    RETURN  -  Exit from TPU-help
	;;    default -  describe the key
	;;
	(setq fkey (format "%s" key))
	(cond ((equal tpu-help-enter fkey)
	       (setq split nil)
	       (delete-other-windows))
	      ((or (equal tpu-help-N fkey) (equal tpu-help-n fkey))
	       (cond (split
	              (condition-case nil
	        	  (scroll-other-window 8)
	        	(error nil)))
	             (t
	              (forward-page)
	              (forward-line 1)
	              (tpu-line-to-top-of-window))))
	      ((or (equal tpu-help-P fkey) (equal tpu-help-p fkey))
	       (cond (split
	              (condition-case nil
	        	  (scroll-other-window -8)
	        	(error nil)))
	             (t
	              (backward-page)
	              (forward-line 1)
	              (tpu-line-to-top-of-window))))
	      ((not (equal tpu-help-return fkey))
	       (setq split t)
	       (describe-key key)
	       ;; If the key is undefined, leave the
	       ;;   message in the mini-buffer for 3 seconds
	       (if (not (key-binding key)) (sit-for 3))))))))


;;;
;;;  Auto-insert
;;;
(defun tpu-insert-escape nil
  "Inserts an escape character, and so becomes the escape-key alias."
  (interactive)
  (insert "\e"))

(defun tpu-insert-formfeed nil
  "Inserts a formfeed character."
  (interactive)
  (insert "\C-L"))


;;;
;;;  Define key
;;;
(defvar tpu-saved-control-r nil "Saved value of Control-r.")

(defun tpu-end-define-macro-key (key)
  "Ends the current macro definition"
  (interactive "kPress the key you want to use to do what was just learned: ")
  (end-kbd-macro nil)
  (global-set-key key last-kbd-macro)
  (global-set-key "\C-r" tpu-saved-control-r))

(defun tpu-define-macro-key nil
  "Bind a set of keystrokes to a single key, or key combination."
  (interactive)
  (setq tpu-saved-control-r (global-key-binding "\C-r"))
  (global-set-key "\C-r" 'tpu-end-define-macro-key)
  (start-kbd-macro nil))


;;;
;;;  Buffers and Windows
;;;
(defun tpu-kill-buffer nil
  "Kills the current buffer.  If tpu-kill-buffers-silently is non-nil,
kills modified buffers without asking."
  (interactive)
  (if tpu-kill-buffers-silently (set-buffer-modified-p nil))
  (kill-buffer (current-buffer)))

(defun tpu-save-all-buffers-kill-emacs nil
  "Save all buffers and exit emacs."
  (interactive)
  (let ((delete-old-versions t))
    (save-buffers-kill-emacs t)))

(defun tpu-write-current-buffers nil
  "Save all modified buffers without exiting."
  (interactive)
  (save-some-buffers t))

(defun tpu-next-buffer nil
  "Go to next buffer in ring."
  (interactive)
  (switch-to-buffer (car (reverse (buffer-list)))))

(defun tpu-next-file-buffer nil
  "Go to next buffer in ring that is visiting a file or directory."
  (interactive)
  (let ((list (tpu-make-file-buffer-list (buffer-list))))
    (setq list (delq (current-buffer) list))
    (if (not list) (error "No other buffers."))
    (switch-to-buffer (car (reverse list)))))

(defun tpu-make-file-buffer-list (buffer-list)
  "Returns names from BUFFER-LIST excluding those beginning with a space or star."
  (delq nil (mapcar '(lambda (b)
                       (if (or (= (aref (buffer-name b) 0) ? )
                               (= (aref (buffer-name b) 0) ?*)) nil b))
                    buffer-list)))

(defun tpu-next-window nil
  "Move to the next window."
  (interactive)
  (if (one-window-p) (message "There is only one window on screen.")
    (other-window 1)))

(defun tpu-previous-window nil
  "Move to the previous window."
  (interactive)
  (if (one-window-p) (message "There is only one window on screen.")
    (select-window (previous-window))))


;;;
;;;  Search
;;;
(defun tpu-toggle-regexp nil
  "Switches in and out of regular expression search and replace mode."
  (interactive)
  (setq tpu-regexp-p (not tpu-regexp-p))
  (tpu-set-search)
  (and (interactive-p)
       (message "Regular expression search and substitute %sabled."
		(if tpu-regexp-p "en" "dis"))))

(defun tpu-regexp-prompt (prompt)
  "Read a string, adding 'RE' to the prompt if tpu-regexp-p is set."
  (let ((re-prompt (concat (if tpu-regexp-p "RE ") prompt)))
    (if tpu-emacs19-p
	(read-from-minibuffer re-prompt nil nil nil 'tpu-regexp-prompt-hist)
      (read-string re-prompt))))

(defun tpu-search nil
  "Search for a string or regular expression.
The search is performed in the current direction."
  (interactive)
  (tpu-set-search)
  (tpu-search-internal ""))

(defun tpu-search-forward nil
  "Search for a string or regular expression.
The search is begins in the forward direction."
  (interactive)
  (setq tpu-searching-forward t)
  (tpu-set-search t)
  (tpu-search-internal ""))

(defun tpu-search-reverse nil
  "Search for a string or regular expression.
The search is begins in the reverse direction."
  (interactive)
  (setq tpu-searching-forward nil)
  (tpu-set-search t)
  (tpu-search-internal ""))

(defun tpu-search-again nil
  "Search for the same string or regular expression as last time.
The search is performed in the current direction."
  (interactive)
  (tpu-search-internal tpu-search-last-string))

;;  tpu-set-search defines the search functions used by the TPU-edt internal
;;  search function.  It should be called whenever the direction changes, or
;;  the regular expression mode is turned on or off.  It can also be called
;;  to ensure that the next search will be in the current direction.  It is
;;  called from:

;;       tpu-advance                   tpu-backup
;;       tpu-toggle-regexp             tpu-toggle-search-direction (t)
;;       tpu-search                    tpu-lm-replace
;;       tpu-search-forward (t)        tpu-search-reverse (t)
;;       tpu-search-forward-exit (t)   tpu-search-backward-exit (t)

(defun tpu-set-search (&optional arg)
  "Set the search functions and set the search direction to the current
direction.  If an argument is specified, don't set the search direction."
  (if (not arg) (setq tpu-searching-forward (if tpu-advance t nil)))
  (cond (tpu-searching-forward
	 (cond (tpu-regexp-p
		(fset 'tpu-emacs-search 're-search-forward)
		(fset 'tpu-emacs-rev-search 're-search-backward))
	       (t
		(fset 'tpu-emacs-search 'search-forward)
		(fset 'tpu-emacs-rev-search 'search-backward))))
	(t
	 (cond (tpu-regexp-p
		(fset 'tpu-emacs-search 're-search-backward)
		(fset 'tpu-emacs-rev-search 're-search-forward))
	       (t
		(fset 'tpu-emacs-search 'search-backward)
		(fset 'tpu-emacs-rev-search 'search-forward))))))

(defun tpu-search-internal (pat &optional quiet)
  "Search for a string or regular expression."
  (setq tpu-search-last-string
	(if (not (string= "" pat)) pat (tpu-regexp-prompt "Search: ")))

  (tpu-unset-match)
  (tpu-adjust-search)

  (let ((case-fold-search
	 (and case-fold-search (tpu-check-search-case tpu-search-last-string))))

    (cond ((tpu-emacs-search tpu-search-last-string nil t)
	   (tpu-set-match) (goto-char (tpu-match-beginning)))

	  (t
	   (tpu-adjust-search t)
	   (let ((found nil) (pos nil))
	     (save-excursion
	       (let ((tpu-searching-forward (not tpu-searching-forward)))
		 (tpu-adjust-search)
		 (setq found (tpu-emacs-rev-search tpu-search-last-string nil t))
		 (setq pos (match-beginning 0))))

	     (cond
	      (found
	       (cond ((tpu-y-or-n-p
		       (format "Found in %s direction.  Go there? "
			       (if tpu-searching-forward "reverse" "forward")))
		      (goto-char pos) (tpu-set-match)
		      (tpu-toggle-search-direction))))

	      (t
	       (if (not quiet)
		   (message
		    "%sSearch failed: \"%s\""
		    (if tpu-regexp-p "RE " "") tpu-search-last-string)))))))))

(fset 'tpu-search-internal-core (symbol-function 'tpu-search-internal))

(defun tpu-check-search-case (string)
  "Returns t if string contains upper case."
  ;; if using regexp, eliminate upper case forms (\B \W \S.)
  (if tpu-regexp-p
      (let ((pat (copy-sequence string)) (case-fold-search nil) (pos 0))
	(while (setq pos (string-match "\\\\\\\\" pat)) (aset pat (+ 1 pos) ?.))
	(while (setq pos (string-match "\\\\B" pat)) (aset pat (+ 1 pos) ?.))
	(while (setq pos (string-match "\\\\W" pat)) (aset pat (+ 1 pos) ?.))
	(while (setq pos (string-match "\\\\S." pat))
	  (aset pat (+ 1 pos) ?.) (aset pat (+ 2 pos) ?.))
	(string-equal pat (downcase pat)))
    (string-equal string (downcase string))))

(defun tpu-adjust-search (&optional arg)
  "For forward searches, move forward a character before searching,
and backward a character after a failed search.  Arg means end of search."
  (if tpu-searching-forward
      (cond (arg (if (not (bobp)) (forward-char -1)))
	    (t (if (not (eobp)) (forward-char 1))))))

(defun tpu-toggle-search-direction nil
  "Toggle the TPU-edt search direction.
Used for reversing a search in progress."
  (interactive)
  (setq tpu-searching-forward (not tpu-searching-forward))
  (tpu-set-search t)
  (and (interactive-p)
       (message "Searching %sward."
		(if tpu-searching-forward "for" "back"))))

(defun tpu-search-forward-exit nil
  "Set search direction forward and exit minibuffer."
  (interactive)
  (setq tpu-searching-forward t)
  (tpu-set-search t)
  (exit-minibuffer))

(defun tpu-search-backward-exit nil
  "Set search direction backward and exit minibuffer."
  (interactive)
  (setq tpu-searching-forward nil)
  (tpu-set-search t)
  (exit-minibuffer))


;;;
;;;  Select / Unselect
;;;
(defun tpu-select (&optional quiet)
  "Sets the mark to define one end of a region."
  (interactive "P")
  (cond ((tpu-mark)
	 (tpu-unselect quiet))
	(t
	 (tpu-set-mark (point))
	 (tpu-update-mode-line)
	 (if (not quiet) (message "Move the text cursor to select text.")))))

(defun tpu-unselect (&optional quiet)
  "Removes the mark to unselect the current region."
  (interactive "P")
  (setq mark-ring nil)
  (tpu-set-mark nil)
  (tpu-update-mode-line)
  (if (not quiet) (message "Selection canceled.")))


;;;
;;;  Delete / Cut
;;;
(defun tpu-toggle-rectangle nil
  "Toggle rectangular mode for remove and insert."
  (interactive)
  (setq tpu-rectangular-p (not tpu-rectangular-p))
  (setq tpu-rectangle-string (if tpu-rectangular-p " Rect" ""))
  (tpu-update-mode-line)
  (and (interactive-p)
       (message "Rectangular cut and paste %sabled."
		(if tpu-rectangular-p "en" "dis"))))

(defun tpu-arrange-rectangle nil
  "Adjust point and mark to mark upper left and lower right
corners of a rectangle."
  (let ((mc (current-column))
	(pc (progn (exchange-point-and-mark) (current-column))))

    (cond ((> (point) (tpu-mark))                  ; point on lower line
	   (cond ((> pc mc)                        ; point @  lower-right
		  (exchange-point-and-mark))       ; point -> upper-left

		 (t	                           ; point @  lower-left
		  (move-to-column mc)              ; point -> lower-right
		  (exchange-point-and-mark)        ; point -> upper-right
		  (move-to-column pc))))           ; point -> upper-left

	  (t                                       ; point on upper line
	   (cond ((> pc mc)                        ; point @  upper-right
		  (move-to-column mc)              ; point -> upper-left
		  (exchange-point-and-mark)        ; point -> lower-left
		  (move-to-column pc)              ; point -> lower-right
		  (exchange-point-and-mark)))))))  ; point -> upper-left

(defun tpu-cut-text nil
  "Delete the selected region.
The text is saved for the tpu-paste command."
  (interactive)
  (cond ((tpu-mark)
	 (cond (tpu-rectangular-p
		(tpu-arrange-rectangle)
		(picture-clear-rectangle (point) (tpu-mark) (not overwrite-mode))
		(tpu-unselect t))
	       (t
		(setq tpu-last-deleted-region
		      (buffer-substring (tpu-mark) (point)))
		(delete-region (tpu-mark) (point))
		(tpu-unselect t))))
	((tpu-check-match)
	 (let ((beg (tpu-match-beginning)) (end (tpu-match-end)))
	   (setq tpu-last-deleted-region (buffer-substring beg end))
	   (delete-region beg end)
	   (tpu-unset-match)))
	(t
	 (error "No selection active."))))

(defun tpu-store-text nil
  "Copy the selected region to the cut buffer without deleting it.
The text is saved for the tpu-paste command."
  (interactive)
  (cond ((tpu-mark)
	 (cond (tpu-rectangular-p
		(save-excursion
		  (tpu-arrange-rectangle)
		  (setq picture-killed-rectangle
			(extract-rectangle (point) (tpu-mark))))
		(tpu-unselect t))
	       (t
		(setq tpu-last-deleted-region
		      (buffer-substring (tpu-mark) (point)))
		(tpu-unselect t))))
	((tpu-check-match)
	 (setq tpu-last-deleted-region
	       (buffer-substring (tpu-match-beginning) (tpu-match-end)))
	 (tpu-unset-match))
	(t
	 (error "No selection active."))))

(defun tpu-cut (arg)
  "Copy selected region to the cut buffer.  In the absence of an
argument, delete the selected region too."
  (interactive "P")
  (if arg (tpu-store-text) (tpu-cut-text)))

(defun tpu-append-region (arg)
  "Append selected region to the tpu-cut buffer.  In the absence of an
argument, delete the selected region too."
  (interactive "P")
  (cond ((tpu-mark)
	 (let ((beg (region-beginning)) (end (region-end)))
	   (setq tpu-last-deleted-region
		 (concat tpu-last-deleted-region
			 (buffer-substring beg end)))
	   (if (not arg) (delete-region beg end))
	   (tpu-unselect t)))
	((tpu-check-match)
	 (let ((beg (tpu-match-beginning)) (end (tpu-match-end)))
	   (setq tpu-last-deleted-region
		 (concat tpu-last-deleted-region
			 (buffer-substring beg end)))
	   (if (not arg) (delete-region beg end))
	   (tpu-unset-match)))
	(t
	 (error "No selection active."))))

(defun tpu-delete-current-line (num)
  "Delete one or specified number of lines after point.
This includes the newline character at the end of each line.
They are saved for the TPU-edt undelete-lines command."
  (interactive "p")
  (let ((beg (point)))
    (forward-line num)
    (if (not (eq (preceding-char) ?\n))
        (insert "\n"))
    (setq tpu-last-deleted-lines
          (buffer-substring beg (point)))
    (delete-region beg (point))))

(defun tpu-delete-to-eol (num)
  "Delete text up to end of line.
With argument, delete up to to Nth line-end past point.
They are saved for the TPU-edt undelete-lines command."
  (interactive "p")
  (let ((beg (point)))
    (forward-char 1)
    (end-of-line num)
    (setq tpu-last-deleted-lines
          (buffer-substring beg (point)))
    (delete-region beg (point))))

(defun tpu-delete-to-bol (num)
  "Delete text back to beginning of line.
With argument, delete up to to Nth line-end past point.
They are saved for the TPU-edt undelete-lines command."
  (interactive "p")
  (let ((beg (point)))
    (tpu-next-beginning-of-line num)
    (setq tpu-last-deleted-lines
          (buffer-substring (point) beg))
    (delete-region (point) beg)))

(defun tpu-delete-current-word (num)
  "Delete one or specified number of words after point.
They are saved for the TPU-edt undelete-words command."
  (interactive "p")
  (let ((beg (point)))
    (tpu-forward-to-word num)
    (setq tpu-last-deleted-words
          (buffer-substring beg (point)))
    (delete-region beg (point))))

(defun tpu-delete-previous-word (num)
  "Delete one or specified number of words before point.
They are saved for the TPU-edt undelete-words command."
  (interactive "p")
  (let ((beg (point)))
    (tpu-backward-to-word num)
    (setq tpu-last-deleted-words
          (buffer-substring (point) beg))
    (delete-region beg (point))))

(defun tpu-delete-current-char (num)
  "Delete one or specified number of characters after point.  The last
character deleted is saved for the TPU-edt undelete-char command."
  (interactive "p")
  (while (and (> num 0) (not (eobp)))
    (setq tpu-last-deleted-char (char-after (point)))
    (cond (overwrite-mode
	   (picture-clear-column 1)
	   (forward-char 1))
	  (t
	   (delete-char 1)))
    (setq num (1- num))))


;;;
;;;  Undelete / Paste
;;;
(defun tpu-paste (num)
  "Insert the last region or rectangle of killed text.
With argument reinserts the text that many times."
  (interactive "p")
  (while (> num 0)
    (cond (tpu-rectangular-p
	   (let ((beg (point)))
	     (save-excursion
	       (picture-yank-rectangle (not overwrite-mode))
	       (message ""))
	     (goto-char beg)))
	  (t
	   (insert tpu-last-deleted-region)))
    (setq num (1- num))))

(defun tpu-undelete-lines (num)
  "Insert lines deleted by last TPU-edt line-deletion command.
With argument reinserts lines that many times."
  (interactive "p")
  (let ((beg (point)))
    (while (> num 0)
      (insert tpu-last-deleted-lines)
      (setq num (1- num)))
    (goto-char beg)))

(defun tpu-undelete-words (num)
  "Insert words deleted by last TPU-edt word-deletion command.
With argument reinserts words that many times."
  (interactive "p")
  (let ((beg (point)))
    (while (> num 0)
      (insert tpu-last-deleted-words)
      (setq num (1- num)))
    (goto-char beg)))

(defun tpu-undelete-char (num)
  "Insert character deleted by last TPU-edt character-deletion command.
With argument reinserts the character that many times."
  (interactive "p")
  (while (> num 0)
    (if overwrite-mode (prog1 (forward-char -1) (delete-char 1)))
    (insert tpu-last-deleted-char)
    (forward-char -1)
    (setq num (1- num))))


;;;
;;;  Replace and Substitute
;;;
(defun tpu-replace nil
  "Replace the selected region with the contents of the cut buffer."
  (interactive)
  (cond ((tpu-mark)
	 (let ((beg (region-beginning)) (end (region-end)))
	   (setq tpu-last-replaced-text (buffer-substring beg end))
	   (delete-region beg end)
	   (insert tpu-last-deleted-region)
	   (tpu-unselect t)))
	((tpu-check-match)
	 (let ((beg (tpu-match-beginning)) (end (tpu-match-end)))
	   (setq tpu-last-replaced-text (buffer-substring beg end))
	   (replace-match tpu-last-deleted-region
			  (not case-replace) (not tpu-regexp-p))
	   (tpu-unset-match)))
	(t
	 (error "No selection active."))))

(defun tpu-substitute (num)
  "Replace the selected region with the contents of the cut buffer, and
repeat most recent search.  A numeric argument serves as a repeat count.
A negative argument means replace all occurrences of the search string."
  (interactive "p")
  (cond ((or (tpu-mark) (tpu-check-match))
	 (while (and (not (= num 0)) (or (tpu-mark) (tpu-check-match)))
	   (let ((beg (point)))
	     (tpu-replace)
	     (if tpu-searching-forward (forward-char -1) (goto-char beg))
	     (if (= num 1) (tpu-search-internal tpu-search-last-string)
	       (tpu-search-internal-core tpu-search-last-string)))
	   (setq num (1- num))))
	(t
	 (error "No selection active."))))

(defun tpu-lm-replace (from to)
  "Interactively search for OLD-string and substitute NEW-string."
  (interactive (list (tpu-regexp-prompt "Old String: ")
		     (tpu-regexp-prompt "New String: ")))

  (let ((doit t) (strings 0))

    ;; Can't replace null strings
    (if (string= "" from) (error "No string to replace."))

    ;; Find the first occurrence
    (tpu-set-search)
    (tpu-search-internal from t)

    ;; Loop on replace question - yes, no, all, last, or quit.
    (while doit
      (if (not (tpu-check-match)) (setq doit nil)
	(progn (message "Replace? Type Yes, No, All, Last, or Quit: ")
	       (let ((ans (read-char)))

		 (cond ((or (= ans ?y) (= ans ?Y) (= ans ?\r) (= ans ?\ ))
			(let ((beg (point)))
			  (replace-match to (not case-replace) (not tpu-regexp-p))
			  (setq strings (1+ strings))
			  (if tpu-searching-forward (forward-char -1) (goto-char beg)))
			(tpu-search-internal from t))

		       ((or (= ans ?n) (= ans ?N) (= ans ?\C-?))
			(tpu-search-internal from t))

		       ((or (= ans ?a) (= ans ?A))
			(save-excursion
			  (let ((beg (point)))
			    (replace-match to (not case-replace) (not tpu-regexp-p))
			    (setq strings (1+ strings))
			    (if tpu-searching-forward (forward-char -1) (goto-char beg)))
			  (tpu-search-internal-core from t)
			  (while (tpu-check-match)
			    (let ((beg (point)))
			      (replace-match to (not case-replace) (not tpu-regexp-p))
			      (setq strings (1+ strings))
			      (if tpu-searching-forward (forward-char -1) (goto-char beg)))
			    (tpu-search-internal-core from t)))
			(setq doit nil))

		       ((or (= ans ?l) (= ans ?L))
			(let ((beg (point)))
			  (replace-match to (not case-replace) (not tpu-regexp-p))
			  (setq strings (1+ strings))
			  (if tpu-searching-forward (forward-char -1) (goto-char beg)))
			(setq doit nil))

		       ((or (= ans ?q) (= ans ?Q))
			(setq doit nil)))))))

    (message "Replaced %s occurrence%s." strings
	     (if (not (= 1 strings)) "s" ""))))

(defun tpu-emacs-replace (&optional dont-ask)
  "A TPU-edt interface to the emacs replace functions.  If TPU-edt is
currently in regular expression mode, the emacs regular expression
replace functions are used.  If an argument is supplied, replacements
are performed without asking.  Only works in forward direction."
  (interactive "P")
  (cond (dont-ask
	 (setq current-prefix-arg nil)
	 (call-interactively
	  (if tpu-regexp-p 'replace-regexp 'replace-string)))
	(t
	 (call-interactively
	  (if tpu-regexp-p 'query-replace-regexp 'query-replace)))))

(defun tpu-add-at-bol (text)
  "Add text to the beginning of each line in a region,
or each line in the entire buffer if no region is selected."
  (interactive
   (list (tpu-string-prompt "String to add: " 'tpu-add-at-bol-hist)))
  (if (string= "" text) (error "No string specified."))
  (cond ((tpu-mark)
	 (save-excursion
	   (if (> (point) (tpu-mark)) (exchange-point-and-mark))
	   (while (and (< (point) (tpu-mark)) (re-search-forward "^" (tpu-mark) t))
	     (if (< (point) (tpu-mark)) (replace-match text))))
	 (tpu-unselect t))
	(t
	 (save-excursion
	   (goto-char (point-min))
	   (while (and (re-search-forward "^" nil t) (not (eobp)))
	     (replace-match text))))))

(defun tpu-add-at-eol (text)
  "Add text to the end of each line in a region,
or each line of the entire buffer if no region is selected."
  (interactive
   (list (tpu-string-prompt "String to add: " 'tpu-add-at-eol-hist)))
  (if (string= "" text) (error "No string specified."))
  (cond ((tpu-mark)
	 (save-excursion
	   (if (> (point) (tpu-mark)) (exchange-point-and-mark))
	   (while (< (point) (tpu-mark))
	     (end-of-line)
	     (if (<= (point) (tpu-mark)) (insert text))
	     (forward-line)))
	 (tpu-unselect t))
	(t
	 (save-excursion
	   (goto-char (point-min))
	   (while (not (eobp))
	     (end-of-line) (insert text) (forward-line))))))

(defun tpu-trim-line-ends nil
  "Removes trailing whitespace from every line in the buffer."
  (interactive)
  (picture-clean))


;;;
;;;  Movement by character
;;;
(defun tpu-char (num)
  "Move to the next character in the current direction.
A repeat count means move that many characters."
  (interactive "p")
  (if tpu-advance (tpu-forward-char num) (tpu-backward-char num)))

(defun tpu-forward-char (num)
  "Move right ARG characters (left if ARG is negative)."
  (interactive "p")
  (forward-char num))

(defun tpu-backward-char (num)
  "Move left ARG characters (right if ARG is negative)."
  (interactive "p")
  (backward-char num))


;;;
;;;  Movement by word
;;;
(defconst tpu-word-separator-list '()
  "List of additional word separators.")
(defconst tpu-skip-chars "^ \t"
  "Characters to skip when moving by word.
Additional word separators are added to this string.")

(defun tpu-word (num)
  "Move to the beginning of the next word in the current direction.
A repeat count means move that many words."
  (interactive "p")
  (if tpu-advance (tpu-forward-to-word num) (tpu-backward-to-word num)))

(defun tpu-forward-to-word (num)
  "Move forward until encountering the beginning of a word.
With argument, do this that many times."
  (interactive "p")
  (while (and (> num 0) (not (eobp)))
    (let* ((beg (point))
	   (end (prog2 (end-of-line) (point) (goto-char beg))))
      (cond ((eolp)
	     (forward-char 1))
	    ((memq (char-after (point)) tpu-word-separator-list)
	     (forward-char 1)
	     (skip-chars-forward " \t" end))
	    (t
	     (skip-chars-forward tpu-skip-chars end)
	     (skip-chars-forward " \t" end))))
    (setq num (1- num))))

(defun tpu-backward-to-word (num)
  "Move backward until encountering the beginning of a word.
With argument, do this that many times."
  (interactive "p")
  (while (and (> num 0) (not (bobp)))
    (let* ((beg (point))
	   (end (prog2 (beginning-of-line) (point) (goto-char beg))))
      (cond ((bolp)
	     ( forward-char -1))
	    ((memq (char-after (1- (point)))  tpu-word-separator-list)
	     (forward-char -1))
	    (t
	     (skip-chars-backward " \t" end)
	     (skip-chars-backward tpu-skip-chars end)
	     (if (and (not (bolp)) (= ?  (char-syntax (char-after (point)))))
		 (forward-char -1)))))
    (setq num (1- num))))

(defun tpu-add-word-separators (separators)
  "Add new word separators for TPU-edt word commands."
  (interactive "sSeparators: ")
  (let* ((n 0) (length (length separators)))
    (while (< n length)
      (let ((char (aref separators n))
	    (ss (substring separators n (1+ n))))
	(cond ((not (memq char tpu-word-separator-list))
	       (setq tpu-word-separator-list
		     (append ss tpu-word-separator-list))
	       (cond ((= char ?-)
		      (setq tpu-skip-chars (concat tpu-skip-chars "\\-")))
		     ((= char ?\\)
		      (setq tpu-skip-chars (concat tpu-skip-chars "\\\\")))
		     ((= char ?^)
		      (setq tpu-skip-chars (concat tpu-skip-chars "\\^")))
		     (t
		      (setq tpu-skip-chars (concat tpu-skip-chars ss))))))
	(setq n (1+ n))))))

(defun tpu-reset-word-separators nil
  "Reset word separators to default value."
  (interactive)
  (setq tpu-word-separator-list nil)
  (setq tpu-skip-chars "^ \t"))

(defun tpu-set-word-separators (separators)
  "Set new word separators for TPU-edt word commands."
  (interactive "sSeparators: ")
  (tpu-reset-word-separators)
  (tpu-add-word-separators separators))


;;;
;;;  Movement by line
;;;
(defun tpu-next-line (num)
  "Move to next line.
Prefix argument serves as a repeat count."
  (interactive "p")
  (next-line-internal num)
  (setq this-command 'next-line))

(defun tpu-previous-line (num)
  "Move to previous line.
Prefix argument serves as a repeat count."
  (interactive "p")
  (next-line-internal (- num))
  (setq this-command 'previous-line))

(defun tpu-next-beginning-of-line (num)
  "Move to beginning of line; if at beginning, move to beginning of next line.
Accepts a prefix argument for the number of lines to move."
  (interactive "p")
  (backward-char 1)
  (forward-line (- 1 num)))

(defun tpu-end-of-line (num)
  "Move to the next end of line in the current direction.
A repeat count means move that many lines."
  (interactive "p")
  (if tpu-advance (tpu-next-end-of-line num) (tpu-previous-end-of-line num)))

(defun tpu-next-end-of-line (num)
  "Move to end of line; if at end, move to end of next line.
Accepts a prefix argument for the number of lines to move."
  (interactive "p")
  (forward-char 1)
  (end-of-line num))

(defun tpu-previous-end-of-line (num)
  "Move EOL upward.
Accepts a prefix argument for the number of lines to move."
  (interactive "p")
  (end-of-line (- 1 num)))

(defun tpu-current-end-of-line nil
  "Move point to end of current line."
  (interactive)
  (let ((beg (point)))
    (end-of-line)
    (if (= beg (point)) (message "You are already at the end of a line."))))

(defun tpu-line (num)
  "Move to the beginning of the next line in the current direction.
A repeat count means move that many lines."
  (interactive "p")
  (if tpu-advance (tpu-forward-line num) (tpu-backward-line num)))

(defun tpu-forward-line (num)
  "Move to beginning of next line.
Prefix argument serves as a repeat count."
  (interactive "p")
  (forward-line num))

(defun tpu-backward-line (num)
  "Move to beginning of previous line.
Prefix argument serves as repeat count."
  (interactive "p")
  (or (bolp) (>= 0 num) (setq num (- num 1)))
  (forward-line (- num)))


;;;
;;;  Movement by paragraph
;;;
(defun tpu-paragraph (num)
  "Move to the next paragraph in the current direction.
A repeat count means move that many paragraphs."
  (interactive "p")
  (if tpu-advance
      (tpu-next-paragraph num) (tpu-previous-paragraph num)))

(defun tpu-next-paragraph (num)
  "Move to beginning of the next paragraph.
Accepts a prefix argument for the number of paragraphs."
  (interactive "p")
  (beginning-of-line)
  (while (and (not (eobp)) (> num 0))
    (if (re-search-forward "^[ \t]*$" nil t)
	(if (re-search-forward "[^ \t\n]" nil t)
	    (goto-char (match-beginning 0))
	  (goto-char (point-max))))
    (setq num (1- num)))
  (beginning-of-line))


(defun tpu-previous-paragraph (num)
  "Move to beginning of previous paragraph.
Accepts a prefix argument for the number of paragraphs."
  (interactive "p")
  (end-of-line)
  (while (and (not (bobp)) (> num 0))
    (if (not (and (re-search-backward "^[ \t]*$" nil t)
		  (re-search-backward "[^ \t\n]" nil t)
		  (re-search-backward "^[ \t]*$" nil t)
		  (progn (re-search-forward "[^ \t\n]" nil t)
			 (goto-char (match-beginning 0)))))
	(goto-char (point-min)))
    (setq num (1- num)))
  (beginning-of-line))


;;;
;;;  Movement by page
;;;
(defun tpu-page (num)
  "Move to the next page in the current direction.
A repeat count means move that many pages."
  (interactive "p")
  (if tpu-advance (forward-page num) (backward-page num))
  (if (eobp) (recenter -1)))


;;;
;;;  Scrolling and movement within the buffer
;;;
(defun tpu-scroll-window (num)
  "Scroll the display to the next section in the current direction.
A repeat count means scroll that many sections."
  (interactive "p")
  (if tpu-advance (tpu-scroll-window-up num) (tpu-scroll-window-down num)))

(defun tpu-scroll-window-down (num)
  "Scroll the display down to the next section.
A repeat count means scroll that many sections."
  (interactive "p")
  (let* ((beg (tpu-current-line))
	 (height (1- (window-height)))
	 (lines (* num (/ (* height tpu-percent-scroll) 100))))
    (next-line-internal (- lines))
    (if (> lines beg) (recenter 0))))

(defun tpu-scroll-window-up (num)
  "Scroll the display up to the next section.
A repeat count means scroll that many sections."
  (interactive "p")
  (let* ((beg (tpu-current-line))
	 (height (1- (window-height)))
	 (lines (* num (/ (* height tpu-percent-scroll) 100))))
    (next-line-internal lines)
    (if (>= (+ lines beg) height) (recenter -1))))

(defun tpu-pan-right (num)
  "Pan right tpu-pan-columns (16 by default).
Accepts a prefix argument for the number of tpu-pan-columns to scroll."
  (interactive "p")
  (scroll-left (* tpu-pan-columns num)))

(defun tpu-pan-left (num)
  "Pan left tpu-pan-columns (16 by default).
Accepts a prefix argument for the number of tpu-pan-columns to scroll."
  (interactive "p")
  (scroll-right (* tpu-pan-columns num)))

(defun tpu-move-to-beginning nil
  "Move cursor to the beginning of buffer, but don't set the mark."
  (interactive)
  (goto-char (point-min)))

(defun tpu-move-to-end nil
  "Move cursor to the end of buffer, but don't set the mark."
  (interactive)
  (goto-char (point-max))
  (recenter -1))

(defun tpu-goto-percent (perc)
  "Move point to ARG percentage of the buffer."
  (interactive "NGoto-percentage: ")
  (if (or (> perc 100) (< perc 0))
      (error "Percentage %d out of range 0 < percent < 100" perc)
    (goto-char (/ (* (point-max) perc) 100))))

(defun tpu-beginning-of-window nil
  "Move cursor to top of window."
  (interactive)
  (move-to-window-line 0))

(defun tpu-end-of-window nil
  "Move cursor to bottom of window."
  (interactive)
  (move-to-window-line -1))

(defun tpu-line-to-bottom-of-window nil
  "Move the current line to the bottom of the window."
  (interactive)
  (recenter -1))

(defun tpu-line-to-top-of-window nil
  "Move the current line to the top of the window."
  (interactive)
  (recenter 0))


;;;
;;;  Direction
;;;
(defun tpu-advance-direction nil
  "Set TPU Advance mode so keypad commands move forward."
  (interactive)
  (setq tpu-direction-string " Advance")
  (setq tpu-advance t)
  (setq tpu-reverse nil)
  (tpu-set-search)
  (tpu-update-mode-line))

(defun tpu-backup-direction nil
  "Set TPU Backup mode so keypad commands move backward."
  (interactive)
  (setq tpu-direction-string " Reverse")
  (setq tpu-advance nil)
  (setq tpu-reverse t)
  (tpu-set-search)
  (tpu-update-mode-line))


;;;
;;;  Define keymaps
;;;
(define-key global-map [scroll] GOLD-map)                      ; GOLD map

(define-key global-map [up]    'tpu-previous-line)            ; up
(define-key global-map [down]  'tpu-next-line)                ; down
(define-key global-map [left]  'tpu-backward-char)            ; left
(define-key global-map [right] 'tpu-forward-char)             ; right

(define-key global-map [find]   'tpu-search)                  ; Find
(define-key global-map [insert] 'tpu-paste)                   ; Insert Here
(define-key global-map [f35]    'tpu-cut)                     ; Remove
(define-key global-map [select] 'tpu-select)                  ; Select
(define-key global-map [prior]  'tpu-scroll-window-down)      ; Prev Screen
(define-key global-map [next]   'tpu-scroll-window-up)        ; Next Screen

(define-key global-map [f1] 'nil)                            ; F1
;(define-key CSI-map "12~" 'nil)                               ; F2
;(define-key CSI-map "13~" 'nil)                               ; F3
;(define-key CSI-map "14~" 'nil)                               ; F4
;(define-key CSI-map "15~" 'nil)                               ; F5
;(define-key CSI-map "17~" 'nil)                               ; F6
;(define-key CSI-map "18~" 'nil)                               ; F7
;(define-key CSI-map "19~" 'nil)                               ; F8
;(define-key CSI-map "20~" 'nil)                               ; F9
(define-key global-map [f10]  'tpu-exit)                      ; F10
(define-key global-map [f11]  'tpu-insert-escape)             ; F11 (ESC)
(define-key global-map [f12]  'tpu-next-beginning-of-line)    ; F12 (BS)
(define-key global-map [f13]  'tpu-delete-previous-word)      ; F13 (LF)
(define-key global-map [f14]  'tpu-toggle-overwrite-mode)     ; F14
(define-key global-map [help] 'tpu-help)                      ; HELP
(define-key global-map [do]   'execute-extended-command)      ; DO
(define-key global-map [f17]  'tpu-goto-breadcrumb)           ; F17
(define-key global-map [f18]  'nil)                           ; F18
(define-key global-map [f19]  'nil)                           ; F19
(define-key global-map [f20]  'other-window)                  ; F20
(define-key global-map [kp-divide] 'tpu-help)                     ; PF2
(define-key global-map [kp-multiply] 'tpu-search-again)           ; PF3
(define-key global-map [kp-subtract] 'tpu-delete-current-line)    ; PF4
(define-key global-map [kp-0]  'tpu-line)                         ; KP0
(define-key global-map [kp-1]  'tpu-word)                         ; KP1
(define-key global-map [kp-2]  'tpu-end-of-line)                  ; KP2
;(define-key global-map [kp-3] 'tpu-char)                          ; KP3
(define-key global-map [kp-3] 'tpu-delete-current-char)           ; KP3
(define-key global-map [kp-4] 'tpu-advance-direction)             ; KP4
(define-key global-map [kp-5] 'tpu-backup-direction)              ; KP5
(define-key global-map [kp-6] 'tpu-cut)                           ; KP6
;(define-key global-map [kp-7] 'tpu-page)                          ; KP7
(define-key global-map [kp-7] 'tpu-scroll-window-down)            ; KP7
;(define-key global-map [kp-8] 'tpu-scroll-window)                 ; KP8
(define-key global-map [kp-8] 'tpu-scroll-window-up)              ; KP8
;(define-key global-map [kp-9] 'tpu-append-region)                ; KP9
(define-key global-map [kp-9] 'tpu-store-text)                    ; KP9
;(define-key global-map [kp-subtract] 'tpu-delete-current-word)    ; KP-
(define-key global-map [kp-add] 'tpu-delete-current-word)         ; KP+
(define-key global-map [kp-separator] 'tpu-delete-current-char)   ; KP,
(define-key global-map [kp-decimal] 'tpu-select)                  ; KP.
;;(define-key global-map [kp-enter] 'newline)                      ; KPenter
(define-key global-map [kp-enter] 'other-window)                  ; KPenter



;;;
;;;  GOLD-map key definitions
;;;
(define-key GOLD-map "\C-A" 'tpu-toggle-overwrite-mode)       ; ^A
(define-key GOLD-map "\C-B" 'nil)                             ; ^B
(define-key GOLD-map "\C-C" 'nil)                             ; ^C
(define-key GOLD-map "\C-D" 'nil)                             ; ^D
(define-key GOLD-map "\C-E" 'nil)                             ; ^E
(define-key GOLD-map "\C-F" 'set-visited-file-name)           ; ^F
(define-key GOLD-map "\C-g" 'keyboard-quit)                   ; safety first
(define-key GOLD-map "\C-h" 'delete-other-windows)            ; BS
(define-key GOLD-map "\C-i" 'other-window)                    ; TAB
(define-key GOLD-map "\C-J" 'nil)                             ; ^J
(define-key GOLD-map "\C-K" 'tpu-define-macro-key)            ; ^K
(define-key GOLD-map "\C-l" 'downcase-region)                 ; ^L
(define-key GOLD-map "\C-M" 'nil)                             ; ^M
(define-key GOLD-map "\C-N" 'nil)                             ; ^N
(define-key GOLD-map "\C-O" 'nil)                             ; ^O
(define-key GOLD-map "\C-P" 'nil)                             ; ^P
(define-key GOLD-map "\C-Q" 'nil)                             ; ^Q
(define-key GOLD-map "\C-R" 'nil)                             ; ^R
(define-key GOLD-map "\C-S" 'nil)                             ; ^S
(define-key GOLD-map "\C-T" 'tpu-toggle-control-keys)         ; ^T
(define-key GOLD-map "\C-u" 'upcase-region)                   ; ^U
(define-key GOLD-map "\C-V" 'nil)                             ; ^V
(define-key GOLD-map "\C-w" 'tpu-write-current-buffers)       ; ^W
(define-key GOLD-map "\C-X" 'nil)                             ; ^X
(define-key GOLD-map "\C-Y" 'nil)                             ; ^Y
(define-key GOLD-map "\C-Z" 'nil)                             ; ^Z

(define-key GOLD-map "0" 'digit-argument)                     ; 0
(define-key GOLD-map "1" 'digit-argument)                     ; 1
(define-key GOLD-map "2" 'digit-argument)                     ; 2
(define-key GOLD-map "3" 'digit-argument)                     ; 3
(define-key GOLD-map "4" 'digit-argument)                     ; 4
(define-key GOLD-map "5" 'digit-argument)                     ; 5
(define-key GOLD-map "6" 'digit-argument)                     ; 6
(define-key GOLD-map "7" 'digit-argument)                     ; 7
(define-key GOLD-map "8" 'digit-argument)                     ; 8
(define-key GOLD-map "9" 'digit-argument)                     ; 9
(define-key GOLD-map " " 'undo)                               ; GOLD-" "
(define-key GOLD-map "a" 'tpu-toggle-newline-and-indent)      ; a
(define-key GOLD-map "A" 'tpu-ascii-table)                    ; GOLD-A
(define-key GOLD-map "b" 'switch-to-buffer)                   ; GOLD-b
(define-key GOLD-map "B" 'buffer-menu)                        ; GOLD-B
(define-key GOLD-map "c" 'find-file)                          ; GOLD-c
(define-key GOLD-map "C" 'compile)                            ; C
;(define-key GOLD-map "C" 'repeat-complex-command)             ; C
(define-key GOLD-map "d" 'shell-command)                      ; GOLD-d
(define-key GOLD-map "D" 'shell-command)                      ; GOLD-D
(define-key GOLD-map "e" 'save-buffers-kill-emacs)            ; GOLD-e
(define-key GOLD-map "E" 'tpu-exit)                           ; E
(define-key GOLD-map "f" 'find-file)                          ; GOLD-f
(define-key GOLD-map "F" 'new-frame)                          ; GOLF-F
(define-key GOLD-map "g" 'goto-line)                          ; GOLD-g
(define-key GOLD-map "G" 'tpu-get)                            ; G
(define-key GOLD-map "h" 'nil)                                ; h
(define-key GOLD-map "H" 'nil)                                ; H
(define-key GOLD-map "i" 'insert-file)                        ; GOLD-i
(define-key GOLD-map "I" 'tpu-include)                        ; I
(define-key GOLD-map "j" 'tpu-toggle-line-trunc)              ; GOLD-j
(define-key GOLD-map "J" 'tpu-toggle-line-trunc)              ; GOLD-J
;;(define-key GOLD-map "k" 'tpu-kill-buffer)                    ; k
;;(define-key GOLD-map "K" 'tpu-kill-buffer)                    ; K
(define-key GOLD-map "k" 'kill-rectangle)                     ; GOLD-k
(define-key GOLD-map "K" 'yank-rectangle)                     ; GOLD-K
(define-key GOLD-map "l" 'buffer-menu)                        ; GOLD-l
(define-key GOLD-map "L" 'tpu-what-line)                      ; L
(define-key GOLD-map "m" 'save-some-buffers)                  ; GOLD-m
(define-key GOLD-map "M" 'buffer-menu)                        ; M
(define-key GOLD-map "n" 'next-error)                         ; GOLD-n
(define-key GOLD-map "N" 'tpu-next-file-buffer)               ; N
(define-key GOLD-map "o" 'switch-to-buffer-other-window)      ; GOLD-o
(define-key GOLD-map "O" 'occur)                              ; O
(define-key GOLD-map "p" 'lpr-region)                         ; p
(define-key GOLD-map "P" 'lpr-buffer)                         ; P
(define-key GOLD-map "q" 'tpu-quit)                           ; q
(define-key GOLD-map "Q" 'kill-emacs)                         ; GOLD-Q
;;(define-key GOLD-map "r" 'tpu-toggle-rectangle)               ; r
;;(define-key GOLD-map "R" 'tpu-toggle-rectangle)               ; R
(define-key GOLD-map "r" 'query-replace)                      ; GOLD-r
(define-key GOLD-map "R" 'replace-string)                     ; GOLD-R
(define-key GOLD-map "s" 'save-buffer)                        ; GOLD-s
;(define-key GOLD-map "S" 'replace)                            ; S
(define-key GOLD-map "t" 'tpu-trim-line-ends)                 ; GOLD-t
(define-key GOLD-map "T" 'tpu-insert-func-tmpl)               ; GOLD-T
(define-key GOLD-map "u" 'undo)                               ; u
(define-key GOLD-map "U" 'undo)                               ; U
(define-key GOLD-map "v" 'find-file-other-window)             ; GOLD-v
(define-key GOLD-map "V" 'tpu-version)                        ; V
(define-key GOLD-map "w" 'write-file)                         ; GOLD-w
(define-key GOLD-map "W" 'save-buffer)                        ; W
(define-key GOLD-map "x" 'call-last-kbd-macro)                ; GOLD-x
(define-key GOLD-map "X" 'tpu-save-all-buffers-kill-emacs)    ; X
(define-key GOLD-map "y" 'center-line)                        ; GOLD-y
(define-key GOLD-map "Y" 'center-region)                      ; GOLD-Y
(define-key GOLD-map "z" 'shrink-window)                      ; GOLD-z
(define-key GOLD-map "Z" 'enlarge-window)                     ; GOLD-Z

(define-key GOLD-map "\177" 'kill-buffer)                     ; GOLD-<X]
(define-key GOLD-map "!" 'tpu-find-balance-point)             ; GOLD-"!"
(define-key GOLD-map "@" 'tpu-what-position)                  ; GOLD-"@"
(define-key GOLD-map "#" 'nil)                                ; #
(define-key GOLD-map "$" 'tpu-add-at-eol)                     ; $
(define-key GOLD-map "%" 'tpu-goto-percent)                   ; GOLD-"%"
(define-key GOLD-map "^" 'register-to-point)                  ; GOLD-"^"
(define-key GOLD-map "&" 'nil)                                ; GOLD-"&"
(define-key GOLD-map "*" 'tpu-toggle-regexp)                  ; GOLD-"*"
(define-key GOLD-map "(" 'nil)                                ; GOLD-"("
(define-key GOLD-map ")" 'nil)                                ; GOLD-")"
;;(define-key GOLD-map "-" 'negative-argument)                  ; GOLD-"-"
(define-key GOLD-map "-" 'delete-window)                      ; GOLD-"-"
(define-key GOLD-map "_" 'split-window-vertically)            ; -
(define-key GOLD-map "+" 'split-window-vertically)            ; GOLD-"+"
(define-key GOLD-map "=" 'point-to-register)                  ; GOLD-"="
(define-key GOLD-map "|" 'split-window-horizontally)          ; GOLD-"|"
(define-key GOLD-map "\\" 'tpu-prev-buffer)                   ; GOLD-"\"
(define-key GOLD-map "~" 'exchange-point-and-mark)            ; GOLD-"~"
(define-key GOLD-map "`" 'tpu-goto-breadcrumb)                ; GOLD-"`"
(define-key GOLD-map "[" 'start-kbd-macro    )                ; GOLD-"["
(define-key GOLD-map "{" 'nil)                                ; GOLD-"{"
(define-key GOLD-map "]" 'end-kbd-macro)                      ; GOLD-"]"
(define-key GOLD-map "}" 'set-fill-column)                    ; GOLD-"}"
(define-key GOLD-map ":" 'tpu-fill)                           ; GOLD-":"
(define-key GOLD-map ";" 'justify-current-line)               ; GOLD-";"
(define-key GOLD-map ">" 'tpu-indent-code-right)              ; GOLD-">"
(define-key GOLD-map "," 'tpu-drop-breadcrumb)                ; GOLD-","
(define-key GOLD-map "<" 'tpu-indent-code-left)               ; GOLD-"<"
(define-key GOLD-map "." 'nil)                                ; GOLD-"."
(define-key GOLD-map "?" 'tpu-spell-check)                    ; GOLD-"?"
(define-key GOLD-map "/" 'tpu-next-buffer)                    ; GOLD-"/"

;;;
;;;  GOLD-CSI-map key definitions
;;;
(define-key GOLD-map [f1] 'nil)                               ; F1
(define-key GOLD-map [f2] 'nil)                               ; F2
(define-key GOLD-map [f3] 'nil)                               ; F3
(define-key GOLD-map [f4] 'nil)                               ; F4
(define-key GOLD-map [f5] 'nil)                               ; F5
;(define-key GOLD-map "228z" 'lse-gdb-tbreak)                  ; SUN-F5
(define-key GOLD-map [f6] 'nil)                               ; F6
;(define-key GOLD-map "229z" 'justify-current-line)            ; SUN-F6
;(define-key GOLD-map " 'nil)                                 ; F7
(define-key GOLD-map [f7]  'overwrite-mode)                    ; SUN-F7
(define-key GOLD-map [f8]  'nil)                              ; F8
(define-key GOLD-map [f9]  'nil)                              ; F9
(define-key GOLD-map [f10] 'nil)                              ; F10
(define-key GOLD-map [f11] 'nil)                              ; F11
(define-key GOLD-map [f12] 'nil)                              ; F12
(define-key GOLD-map [f13] 'nil)                              ; F13
(define-key GOLD-map [f14] 'nil)                              ; F14
(define-key GOLD-map [help] 'describe-bindings)               ; HELP
(define-key GOLD-map [f15] 'Helper-help)                      ; SUN-HELP
(define-key GOLD-map [do] 'nil)                               ; DO
(define-key GOLD-map [f17] 'tpu-drop-breadcrumb)              ; F17
(define-key GOLD-map [f18] 'nil)                              ; F18
(define-key GOLD-map [f19] 'nil)                              ; F19
(define-key GOLD-map [f20] 'nil)                              ; F20

;;;
;;;  GOLD-SS3-map key definitions
;;;
;;(define-key GOLD-map [up]   'tpu-move-to-beginning)           ; up-arrow
;;(define-key GOLD-map [down] 'tpu-move-to-end)                 ; down-arrow
(define-key GOLD-map [up]    'tpu-line-to-top-of-window)      ; GOLD-UP
(define-key GOLD-map [down]  'tpu-line-to-bottom-of-window)   ; GOLD-DOWN
(define-key GOLD-map [right] 'tpu-pan-right)                  ; GOLD-RIGHT
(define-key GOLD-map [left]  'tpu-pan-left)                   ; GOLD-LEFT
;(define-key GOLD-map [kp-numlock] 'keyboard-quit)             ; PF1
(define-key GOLD-map [kp-divide] 'help-for-help)              ; PF2
(define-key GOLD-map [kp-multiply] 'tpu-search)               ; PF3
(define-key GOLD-map [kp-subtract] 'tpu-undelete-lines)       ; PF4
(define-key GOLD-map [kp-0] 'open-line)                       ; KP0
(define-key GOLD-map [kp-1] 'tpu-change-case)                 ; KP1
(define-key GOLD-map [kp-2] 'tpu-delete-to-eol)               ; KP2
;(define-key GOLD-map [kp-3] 'tpu-special-insert)              ; KP3
(define-key GOLD-map [kp-3] 'tpu-undelete-char)               ; KP3
(define-key GOLD-map [kp-4] 'tpu-move-to-end)                 ; KP4
(define-key GOLD-map [kp-5] 'tpu-move-to-beginning)           ; KP5
(define-key GOLD-map [kp-6] 'tpu-paste)                       ; KP6
(define-key GOLD-map [kp-7] 'execute-extended-command)        ; KP7
(define-key GOLD-map [kp-8] 'tpu-fill)                        ; KP8
;(define-key GOLD-map [kp-9] 'tpu-replace)                     ; KP9
(define-key GOLD-map [kp-9] 'tpu-paste)                       ; KP9
;(define-key GOLD-map [kp-subtract]  'tpu-undelete-words)      ; KP-
(define-key GOLD-map [kp-add]       'tpu-undelete-words)      ; KP+
(define-key GOLD-map [kp-separator] 'tpu-undelete-char)       ; KP,
(define-key GOLD-map [kp-decimal]   'tpu-unselect)            ; KP.
(define-key GOLD-map [kp-enter]     'tpu-substitute)          ; KPenter

;;(define-key global-map "b" 'self-insert-command)

;;;
;;;  Repeat complex command map additions to make arrows work
;;;
(cond ((boundp 'repeat-complex-command-map)
       (define-key repeat-complex-command-map [up]   'previous-complex-command)
       (define-key repeat-complex-command-map [down] 'next-complex-command)
       (define-key repeat-complex-command-map "\eOA" 'previous-complex-command)
       (define-key repeat-complex-command-map "\eOB" 'next-complex-command)))


;;;
;;;  Minibuffer map additions to make KP_enter = RET
;;;
(define-key minibuffer-local-map "\eOM" 'exit-minibuffer)
(define-key minibuffer-local-ns-map "\eOM" 'exit-minibuffer)
(define-key minibuffer-local-completion-map "\eOM" 'exit-minibuffer)
(define-key minibuffer-local-must-match-map "\eOM" 'minibuffer-complete-and-exit)
(and (boundp 'repeat-complex-command-map)
     (define-key repeat-complex-command-map "\eOM" 'exit-minibuffer))


;;;
;;;  Minibuffer map additions to set search direction
;;;
(define-key minibuffer-local-map "\eOt" 'tpu-search-forward-exit)
(define-key minibuffer-local-map "\eOu" 'tpu-search-backward-exit)


;;;
;;;  Functions to set, reset, and toggle the control key bindings
;;;
(defun tpu-set-control-keys nil
  "Set control keys to TPU style functions."
  (define-key global-map "\C-\\" 'quoted-insert)                ; ^\
  (define-key global-map "\C-a" 'tpu-toggle-overwrite-mode)     ; ^A
  (define-key global-map "\C-b" 'repeat-complex-command)        ; ^B
  (define-key global-map "\C-e" 'tpu-current-end-of-line)       ; ^E
  (define-key global-map "\C-h" 'tpu-next-beginning-of-line)    ; ^H (BS)
  (define-key global-map "\C-j" 'tpu-delete-previous-word)      ; ^J (LF)
  (define-key global-map "\C-k" 'tpu-define-macro-key)          ; ^K
  (define-key global-map "\C-l" 'tpu-insert-formfeed)           ; ^L (FF)
  (define-key global-map "\C-r" 'recenter)                      ; ^R
  (define-key global-map "\C-u" 'tpu-delete-to-bol)             ; ^U
  (define-key global-map "\C-v" 'tpu-quoted-insert)             ; ^V
  (define-key global-map "\C-w" 'redraw-display)                ; ^W
  (define-key global-map "\C-z" 'tpu-exit)                      ; ^Z
  (setq tpu-control-keys t))

(defun tpu-reset-control-keys (tpu-style)
  "Set control keys to TPU or emacs style functions."
  (let* ((tpu   (and tpu-style (not tpu-control-keys)))
	 (emacs (and (not tpu-style) tpu-control-keys))
	 (doit  (or tpu emacs)))
    (cond (doit
	   (if emacs (setq tpu-global-map (copy-keymap global-map)))
	   (let ((map (if tpu
			  (copy-keymap tpu-global-map)
			(copy-keymap tpu-original-global-map))))

 	     (define-key global-map "\C-\\" (lookup-key map "\C-\\"))   ; ^\
 	     (define-key global-map "\C-a" (lookup-key map "\C-a"))     ; ^A
 	     (define-key global-map "\C-b" (lookup-key map "\C-b"))     ; ^B
 	     (define-key global-map "\C-e" (lookup-key map "\C-e"))     ; ^E
 	     (define-key global-map "\C-f" (lookup-key map "\C-f"))     ; ^F
	     (define-key global-map "\C-h" (lookup-key map "\C-h"))     ; ^H (BS)
	     (define-key global-map "\C-j" (lookup-key map "\C-j"))     ; ^J (LF)
	     (define-key global-map "\C-k" (lookup-key map "\C-k"))     ; ^K
	     (define-key global-map "\C-l" (lookup-key map "\C-l"))     ; ^L (FF)
	     (define-key global-map "\C-r" (lookup-key map "\C-r"))     ; ^R
	     (define-key global-map "\C-u" (lookup-key map "\C-u"))     ; ^U
	     (define-key global-map "\C-v" (lookup-key map "\C-v"))     ; ^V
	     (define-key global-map "\C-w" (lookup-key map "\C-w"))     ; ^W
	     (define-key global-map "\C-z" (lookup-key map "\C-z"))     ; ^Z
	     (setq tpu-control-keys tpu-style))))))

(defun tpu-toggle-control-keys nil
  "Toggles control key bindings between TPU-edt and Emacs."
  (interactive)
  (tpu-reset-control-keys (not tpu-control-keys))
  (and (interactive-p)
       (message "Control keys function with %s bindings."
		(if tpu-control-keys "TPU-edt" "Emacs"))))


;;;
;;;  Emacs version 19 minibuffer history support
;;;
(defun tpu-next-history-element (n)
  "Insert the next element of the minibuffer history into the minibuffer."
  (interactive "p")
  (next-history-element n)
  (goto-char (point-max)))

(defun tpu-previous-history-element (n)
  "Insert the previous element of the minibuffer history into the minibuffer."
  (interactive "p")
  (previous-history-element n)
  (goto-char (point-max)))

(defun tpu-arrow-history nil
  "Modify minibuffer maps to use arrows for history recall."
  (interactive)
  (let ((loc (where-is-internal 'tpu-previous-line)) (cur nil))
    (while (setq cur (car loc))
      (define-key read-expression-map cur 'tpu-previous-history-element)
      (define-key minibuffer-local-map cur 'tpu-previous-history-element)
      (define-key minibuffer-local-ns-map cur 'tpu-previous-history-element)
      (define-key minibuffer-local-completion-map cur 'tpu-previous-history-element)
      (define-key minibuffer-local-must-match-map cur 'tpu-previous-history-element)
      (setq loc (cdr loc)))

    (setq loc (where-is-internal 'tpu-next-line))
    (while (setq cur (car loc))
      (define-key read-expression-map cur 'tpu-next-history-element)
      (define-key minibuffer-local-map cur 'tpu-next-history-element)
      (define-key minibuffer-local-ns-map cur 'tpu-next-history-element)
      (define-key minibuffer-local-completion-map cur 'tpu-next-history-element)
      (define-key minibuffer-local-must-match-map cur 'tpu-next-history-element)
      (setq loc (cdr loc)))))


;;;
;;;  Emacs version 19 X-windows key definition support
;;;
(defun tpu-load-xkeys (file)
  "Load the TPU-edt X-windows key definitions FILE.
If FILE is nil, try to load a default file.  The default file names are
`~/.tpu-lucid-keys' for Lucid emacs, and `~/.tpu-keys' for Emacs."
  (interactive "fX key definition file: ")
  (cond (file
	 (setq file (expand-file-name file)))
	(tpu-xkeys-file
	 (setq file (expand-file-name tpu-xkeys-file)))
	(tpu-lucid-emacs19-p
	 (setq file (convert-standard-filename
		     (expand-file-name "~/.tpu-lucid-keys"))))
	(tpu-emacs19-p
	 (setq file (convert-standard-filename
		     (expand-file-name "~/.tpu-keys")))
	 (and (not (file-exists-p file))
	      (file-exists-p
	       (convert-standard-filename
		(expand-file-name "~/.tpu-gnu-keys")))
	      (tpu-copy-keyfile
	       (convert-standard-filename
		(expand-file-name "~/.tpu-gnu-keys")) file))))
  (cond ((file-readable-p file)
	 (load-file file))
	(t
	 (switch-to-buffer "*scratch*")
	 (erase-buffer)
	 (insert "

     Ack!!  You're running TPU-edt under X-windows without loading an
     X  key definition file.   To create a  TPU-edt X  key definition
     file, run the tpu-mapper.el program.  It  came with TPU-edt.  It
     even includes directions on how to  use it!   Perhaps it's lying
     around here someplace.  ")
	 (let ((file "tpu-mapper.el")
	       (found nil)
	       (path nil)
	       (search-list (append (list (expand-file-name ".")) load-path)))
	   (while (and (not found) search-list)
	     (setq path (concat (car search-list)
				(if (string-match "/$" (car search-list)) "" "/")
				file))
	     (if (and (file-exists-p path) (not (file-directory-p path)))
		 (setq found t))
	     (setq search-list (cdr search-list)))
	   (cond (found
		  (insert (format
			   "Ah yes, there it is, in \n\n       %s \n\n" path))
		  (if (tpu-y-or-n-p "Do you want to run it now? ")
		      (load-file path)))
		 (t
		  (insert "Nope, I can't seem to find it.  :-(\n\n")
		  (sit-for 120)))))))

(defun tpu-copy-keyfile (oldname newname)
  "Copy the TPU-edt X key definitions file to the new default name."
  (interactive "fOld name: \nFNew name: ")
  (if (not (get-buffer "*TPU-Notice*")) (generate-new-buffer "*TPU-Notice*"))
  (set-buffer "*TPU-Notice*")
  (erase-buffer)
  (insert "
  NOTICE --

  The default name of the TPU-edt key definition file has changed
  from `~/.tpu-gnu-keys' to `~/.tpu-keys'.  With your permission,
  your key definitions will be copied to the new file.  If you'll
  never use older versions of Emacs, you can remove the old file.
  If the copy fails, you'll be asked if you want to create a new
  key definitions file.  Do you want to copy your key definition
  file now?
  ")
  (save-window-excursion
    (switch-to-buffer-other-window "*TPU-Notice*")
    (shrink-window-if-larger-than-buffer)
    (goto-char (point-min))
    (beep)
    (and (tpu-y-or-n-p "Copy key definitions to the new file now? ")
	 (condition-case conditions
             (copy-file oldname newname)
	   (error (message "Sorry, couldn't copy - %s" (cdr conditions)))))
    (kill-buffer "*TPU-Notice*")))


;;;
;;;  Start and Stop TPU-edt
;;;
;;;###autoload
(defun tpu-edt-on nil
  "Turn on TPU/edt emulation."
  (interactive)
  (cond
   ((not tpu-edt-mode)
    ;; we use picture-mode functions
    (require 'picture)
    (tpu-set-control-keys)
    (cond (tpu-emacs19-p
	   (and nil window-system (tpu-load-xkeys nil))
	   (tpu-arrow-history))
	  (t
	   ;; define ispell functions
	   (autoload 'ispell-word "ispell" "Check spelling of word at or before point" t)
	   (autoload 'ispell-complete-word "ispell" "Complete word at or before point" t)
	   (autoload 'ispell-buffer "ispell" "Check spelling of entire buffer" t)
	   (autoload 'ispell-region "ispell" "Check spelling of region" t)))
    (tpu-set-mode-line t)
    (tpu-advance-direction)
    ;; set page delimiter, display line truncation, and scrolling like TPU
    (setq-default page-delimiter "\f")
    (setq-default truncate-lines t)
    (setq scroll-step 1)
    (setq tpu-edt-mode t))))

(defun tpu-edt-off nil
  "Turn off TPU/edt emulation.  Note that the keypad is left on."
  (interactive)
  (cond
   (tpu-edt-mode
    (tpu-reset-control-keys nil)
    (tpu-set-mode-line nil)
    (setq-default page-delimiter "^\f")
    (setq-default truncate-lines nil)
    (setq scroll-step 0)
    (setq global-map (copy-keymap tpu-original-global-map))
    (use-global-map global-map)
    (setq tpu-edt-mode nil))))

(provide 'tpu-edt)
(tpu-add-word-separators "]\\[-_,.\"=+()'/*#:!&;$")

;;; tpu-edt.el ends here

(custom-set-variables
  '(cua-mode nil)
  '(menu-bar-mode t nil (menu-bar))
  '(show-paren-mode nil)
  '(tool-bar-mode nil nil (tool-bar))
  '(inhibit-splash-screen t)
  '(global-font-lock-mode nil)
)

(if (file-directory-p "c:/opt/cygwin/bin")
  (add-to-list 'exec-path "c:/opt/cygwin/bin"))

(setq shell-file-name "bash")
(setq explicit-shell-file-name shell-file-name)
