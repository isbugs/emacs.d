;;; init.el --- Configuration entry -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; (setq debug-on-error t)

;; Defer garbage collection further back in the startup proces
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Increase the amout of data reads from the process
(setq read-process-output-max (* 4 1024 1024))

;; Disable start-up screen
(setq inhibit-startup-screen t)

;; Display (row, col) in mode-line
(setq-default line-number-mode t
	      column-number-mode t)

;; Alias the longform of ‘y-or-n-p’
;; (defalias 'yes-or-no-p 'y-or-n-p)
(setq use-short-answers t)

;; Don't creeate  .#  backup~  #autosave#  files
(setq-default create-lockfiles nil
 	      make-backup-files nil
 	      auto-save-default nil)

;; For evaluating expressions only run on MacOS
(defconst is-mac-p (eq system-type 'darwin))

(when (and is-mac-p (not (display-graphic-p)))
  (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'set-scroll-bar-mode)
  (set-scroll-bar-mode nil))
(when (fboundp 'horizontal-scroll-bar-mode)
  (horizontal-scroll-bar-mode -1))

(setq-default window-resize-pixelwise t
              frame-resize-pixelwise t)
(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode))

(when (and is-mac-p (display-graphic-p))
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'none))

(when (member "Menlo" (font-family-list))
  (set-frame-font "Menlo-11" t t))

;; By default, emacs will warn you if you try to edit a buffer for
;; a file whose contents have changed on disk.  You could go one
;; step further and have emacs update the buffer automatically
;; (if there were no unsaved changes)
(setq global-auto-revert-mode t)


;; (when (fboundp 'display-line-numbers-mode)
;;   (setq-default display-line-numbers-width 3)
;;   (add-hook 'prog-mode-hook 'display-line-numbers-mode))

;; (when (boundp 'display-fill-column-indicator)
;;   (setq-default fill-column 72)
;;   (setq-default indicate-buffer-boundaries 'left)
;;   (setq-default display-fill-column-indicator-character ?┊)
;;   (add-hook 'prog-mode-hook 'display-fill-column-indicator-mode))

;;; Newline behaviour
(defun is-newline-at-end-of-line ()
  "Move to end of line, enter a newline, and reindent."
  (interactive)
  (move-end-of-line 1)
  (newline-and-indent))
(global-set-key (kbd "S-<return>") 'is-newline-at-end-of-line)

(defun is-suspend-frame ()
  "Stop `C-z' from minimizing frames under MacOS;
but when Emacs running in terminal rather than graphic interface,
it can be suspended using `C-z' and recover through command `fg'."
  (interactive)
  (unless (and is-mac-p (display-graphic-p))
    (suspend-frame)))
(global-set-key (kbd "C-z") 'is-suspend-frame)

(when (and is-mac-p (display-graphic-p) (fboundp 'toggle-frame-fullscreen))
  ;; Command-Option-f to toggle fullscreen mode
  ;; Hint: Customize `ns-use-native-fullscreen'
  (global-set-key (kbd "M-ƒ") 'toggle-frame-fullscreen))

;; Allow access from emacsclient
(add-hook 'after-init-hook
          (lambda ()
            (require 'server)
            (unless (server-running-p)
              (server-start))))

;; Put customisations in a separate file
(setq custom-file (locate-user-emacs-file "custom.el"))
;; Variables configured via the interactive 'customize' interface
(when (file-exists-p custom-file)
  (load custom-file))

(provide 'init)
;;; init.el ends here.
