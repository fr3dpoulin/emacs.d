;;; init-octave.el --- Matlab/octave mode configuration -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require-package 'matlab-mode)

;; Associate .m files with octave (or matlab)
(add-to-list 'auto-mode-alist '("\\.m\\'" . matlab-mode))

(add-hook 'matlab-mode-hook
          (lambda ()
            (setq matlab-shell-command-switches '("-nodesktop -nosplash"))
            (setq matlab-show-mlint-warnings t)

            (matlab-cedet-setup)

            ;; See https://www.emacswiki.org/emacs/MatlabMode
            ;;
            ;; Need to create a cmd file in C:/Programs/matlabshell/matlabshell.cmd
            ;; that contains (or something equivalent):
            ;;   @echo off
            ;;   SET PATH=C:\PROGRA~1\MATLAB\R2011a\bin;C:\PROGRA~1\MATLAB\R2011a\bin\win32
            ;;   %~dp0\matlabShell.exe 10000 20000
            ;;

            (when (eq 'system-type 'windows-nt)
              (setq matlab-shell-command "c:/Programs/matlabshell/matlabshell.cmd")
              (setq matlab-shell-command-switches '())
              (setq matlab-shell-echoes nil)

              )))

;; (setq octave-mode-hook
;;       (lambda () (progn (setq octave-comment-char ?%)
;;                    (setq comment-start "%")
;;                    (setq indent-tabs-mode nil)
;;                    (setq comment-add 0)
;;                    (setq tab-width 2)
;;                    (setq tab-stop-list (number-sequence 2 200 2))
;;                    ;; (setq indent-line-function 'insert-tab)
;;                    (setq octave-block-offset 2)


;;                    ;; (setq comment-use-syntax f)
;;                    ;; (setq comment-column (save-excursion (forward-line -1)(current-indentation)))
;;                    ;; (setq comment-start-skip f)
;;                    (defun octave-indent-comment ()
;;                      "A function for `smie-indent-functions' (which see)."
;;                      (save-excursion
;;                        (back-to-indentation)
;;                        (cond
;;                         ((octave-in-string-or-comment-p) nil)
;;                         ((looking-at-p "\\(\\s<\\)\\1\\{2,\\}") 0))))

;;                    )))

;; (modify-syntax-entry ?% "<"  octave-mode-syntax-table)

(provide 'init-octave)
;;; init-octave.el ends here
