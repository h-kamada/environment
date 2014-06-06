;shift +
(setq windmove-wrap-around t)
(windmove-default-keybindings)

;clip board
(if (display-graphic-p)
    (progn
      (setq x-select-enable-clipboard t)
      (global-set-key "\C-y" 'x-clipboard-yank))
  (progn
    (setq interprogram-paste-function
          #'(lambda () (shell-command-to-string "xsel -b -o")))
    (setq interprogram-cut-function
          #'(lambda (text &optional rest)
              (let*
                  ((process-connection-type nil)
                   (proc (start-process "xsel" "*Messages*" "xsel" "-b" "-i")))
                (process-send-string proc text)
                (process-send-eof proc))))))