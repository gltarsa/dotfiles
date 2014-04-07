;;; rtags-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (rtags-show-target-in-other-window rtags-remove-other-window
;;;;;;  rtags-fixit rtags-show-rtags-buffer rtags-find-file rtags-imenu
;;;;;;  rtags-select-and-remove-rtags-buffer rtags-show-in-other-window
;;;;;;  rtags-select-other-window rtags-select rtags-taglist rtags-close-taglist
;;;;;;  rtags-standard-save-hook rtags-diagnostics rtags-clear-diagnostics
;;;;;;  rtags-stop-diagnostics rtags-post-command-hook rtags-restart-tracking-timer
;;;;;;  rtags-update-current-project rtags-update-completion-mode
;;;;;;  rtags-ac-find-file-hook rtags-ac-after-save-hook rtags-ac-pre-command-hook
;;;;;;  rtags-ac-post-command-hook rtags-restart-completion-cache-timer
;;;;;;  rtags-fix-fixit-at-point rtags-cycle-overlays-on-screen rtags-is-running
;;;;;;  rtags-clear-diagnostics-overlays rtags-apply-fixit-at-point
;;;;;;  rtags-prepare-completions rtags-init-completion-stream rtags-expand
;;;;;;  rtags-rdm-completion-enabled rtags-find-references-current-dir
;;;;;;  rtags-find-symbol-current-dir rtags-find-references-current-file
;;;;;;  rtags-find-symbol-current-file rtags-find-references rtags-find-symbol
;;;;;;  rtags-rename-symbol rtags-guess-function-at-point rtags-find-all-references-at-point
;;;;;;  rtags-find-virtuals-at-point rtags-find-references-at-point
;;;;;;  rtags-find-symbol-at-point rtags-location-stack-reset rtags-location-stack-back
;;;;;;  rtags-location-stack-forward rtags-switch-to-completion-buffer
;;;;;;  rtags-quit-rdm rtags-print-current-location rtags-enable-standard-keybindings
;;;;;;  rtags-location-stack-jump rtags-remove-completion-buffer
;;;;;;  rtags-goto-offset rtags-print-enum-value-at-point rtags-print-dependencies
;;;;;;  rtags-print-cursorinfo rtags-set-current-project rtags-reparse-file
;;;;;;  rtags-preprocess-file rtags-index-js-file rtags-previous-diag
;;;;;;  rtags-next-diag rtags-previous-match rtags-next-match rtags-bury-or-delete)
;;;;;;  "rtags" "rtags.el" (21309 51734 0 0))
;;; Generated autoloads from rtags.el

(autoload 'rtags-bury-or-delete "rtags" "\


\(fn)" t nil)

(autoload 'rtags-next-match "rtags" "\


\(fn)" t nil)

(autoload 'rtags-previous-match "rtags" "\


\(fn)" t nil)

(autoload 'rtags-next-diag "rtags" "\


\(fn)" t nil)

(autoload 'rtags-previous-diag "rtags" "\


\(fn)" t nil)

(autoload 'rtags-index-js-file "rtags" "\


\(fn)" t nil)

(autoload 'rtags-preprocess-file "rtags" "\


\(fn &optional BUFFER)" t nil)

(autoload 'rtags-reparse-file "rtags" "\


\(fn &optional BUFFER)" t nil)

(autoload 'rtags-set-current-project "rtags" "\


\(fn)" t nil)

(autoload 'rtags-print-cursorinfo "rtags" "\


\(fn &optional VERBOSE)" t nil)

(autoload 'rtags-print-dependencies "rtags" "\


\(fn &optional BUFFER)" t nil)

(autoload 'rtags-print-enum-value-at-point "rtags" "\


\(fn &optional LOCATION)" t nil)

(autoload 'rtags-goto-offset "rtags" "\


\(fn POS)" t nil)

(autoload 'rtags-remove-completion-buffer "rtags" "\


\(fn)" t nil)

(autoload 'rtags-location-stack-jump "rtags" "\


\(fn BY)" t nil)

(autoload 'rtags-enable-standard-keybindings "rtags" "\


\(fn &optional MAP PREFIX)" t nil)

(autoload 'rtags-print-current-location "rtags" "\


\(fn)" t nil)

(autoload 'rtags-quit-rdm "rtags" "\


\(fn)" t nil)

(autoload 'rtags-switch-to-completion-buffer "rtags" "\


\(fn)" t nil)

(autoload 'rtags-location-stack-forward "rtags" "\


\(fn)" t nil)

(autoload 'rtags-location-stack-back "rtags" "\


\(fn)" t nil)

(autoload 'rtags-location-stack-reset "rtags" "\


\(fn)" t nil)

(autoload 'rtags-find-symbol-at-point "rtags" "\
Find the natural target for the symbol under the cursor and moves to that location.
For references this means to jump to the definition/declaration of the referenced symbol (it jumps to the definition if it is indexed).
For definitions it jumps to the declaration (if there is only one) For declarations it jumps to the definition.
If called with a prefix restrict to current buffer

\(fn &optional PREFIX)" t nil)

(autoload 'rtags-find-references-at-point "rtags" "\
Find all references to the symbol under the cursor
If there's exactly one result jump directly to it.
If there's more show a buffer with the different alternatives and jump to the first one if rtags-jump-to-first-match is true.
References to references will be treated as references to the referenced symbol

\(fn &optional PREFIX)" t nil)

(autoload 'rtags-find-virtuals-at-point "rtags" "\
List all reimplentations of function under cursor. This includes both declarations and definitions

\(fn &optional PREFIX)" t nil)

(autoload 'rtags-find-all-references-at-point "rtags" "\


\(fn &optional PREFIX)" t nil)

(autoload 'rtags-guess-function-at-point "rtags" "\


\(fn)" t nil)

(autoload 'rtags-rename-symbol "rtags" "\


\(fn)" t nil)

(autoload 'rtags-find-symbol "rtags" "\


\(fn &optional PREFIX)" t nil)

(autoload 'rtags-find-references "rtags" "\


\(fn &optional PREFIX)" t nil)

(autoload 'rtags-find-symbol-current-file "rtags" "\


\(fn)" t nil)

(autoload 'rtags-find-references-current-file "rtags" "\


\(fn)" t nil)

(autoload 'rtags-find-symbol-current-dir "rtags" "\


\(fn)" t nil)

(autoload 'rtags-find-references-current-dir "rtags" "\


\(fn)" t nil)

(autoload 'rtags-rdm-completion-enabled "rtags" "\


\(fn)" t nil)

(autoload 'rtags-expand "rtags" "\


\(fn)" t nil)

(autoload 'rtags-init-completion-stream "rtags" "\


\(fn)" t nil)

(autoload 'rtags-prepare-completions "rtags" "\


\(fn)" t nil)

(autoload 'rtags-apply-fixit-at-point "rtags" "\


\(fn)" t nil)

(autoload 'rtags-clear-diagnostics-overlays "rtags" "\


\(fn)" t nil)

(autoload 'rtags-is-running "rtags" "\


\(fn)" t nil)

(autoload 'rtags-cycle-overlays-on-screen "rtags" "\


\(fn)" t nil)

(autoload 'rtags-fix-fixit-at-point "rtags" "\


\(fn)" t nil)

(autoload 'rtags-restart-completion-cache-timer "rtags" "\


\(fn)" t nil)

(autoload 'rtags-ac-post-command-hook "rtags" "\


\(fn)" t nil)

(autoload 'rtags-ac-pre-command-hook "rtags" "\


\(fn)" t nil)

(autoload 'rtags-ac-after-save-hook "rtags" "\


\(fn)" t nil)

(autoload 'rtags-ac-find-file-hook "rtags" "\


\(fn)" t nil)

(autoload 'rtags-update-completion-mode "rtags" "\


\(fn)" t nil)

(autoload 'rtags-update-current-project "rtags" "\


\(fn)" t nil)

(autoload 'rtags-restart-tracking-timer "rtags" "\


\(fn)" t nil)

(autoload 'rtags-post-command-hook "rtags" "\


\(fn)" t nil)

(autoload 'rtags-stop-diagnostics "rtags" "\


\(fn)" t nil)

(autoload 'rtags-clear-diagnostics "rtags" "\


\(fn)" t nil)

(autoload 'rtags-diagnostics "rtags" "\


\(fn &optional RESTART NODIRTY)" t nil)

(autoload 'rtags-standard-save-hook "rtags" "\


\(fn)" t nil)

(autoload 'rtags-close-taglist "rtags" "\


\(fn)" t nil)

(autoload 'rtags-taglist "rtags" "\


\(fn)" t nil)

(autoload 'rtags-select "rtags" "\


\(fn &optional OTHER-WINDOW REMOVE SHOW)" t nil)

(autoload 'rtags-select-other-window "rtags" "\


\(fn &optional NOT-OTHER-WINDOW)" t nil)

(autoload 'rtags-show-in-other-window "rtags" "\


\(fn)" t nil)

(autoload 'rtags-select-and-remove-rtags-buffer "rtags" "\


\(fn)" t nil)

(autoload 'rtags-imenu "rtags" "\


\(fn)" t nil)

(autoload 'rtags-find-file "rtags" "\


\(fn &optional PREFIX TAGNAME)" t nil)

(autoload 'rtags-show-rtags-buffer "rtags" "\


\(fn)" t nil)

(autoload 'rtags-fixit "rtags" "\


\(fn &optional EDIFF BUFFER)" t nil)

(autoload 'rtags-remove-other-window "rtags" "\


\(fn)" t nil)

(autoload 'rtags-show-target-in-other-window "rtags" "\


\(fn)" t nil)

;;;***

;;;### (autoloads nil nil ("rtags-pkg.el") (21309 51734 362363 0))

;;;***

(provide 'rtags-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; rtags-autoloads.el ends here
