Add the following to ~/.emacs:

    (require 'vimrc-mode)
    (add-to-list 'auto-mode-alist '(".vim\\(rc\\)?$" . vimrc-mode))
