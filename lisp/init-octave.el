;; Associate .m files with octave (or matlab)
(add-to-list 'auto-mode-alist '("\\.m\\'" . octave-mode))

(setq octave-mode-hook
      (lambda () (progn (setq octave-comment-char ?%)
                   (setq comment-start "%")
                   (setq indent-tabs-mode nil)
                   (setq comment-add 0)
                   (setq tab-width 2)
                   (setq tab-stop-list (number-sequence 2 200 2))
                   ;; (setq indent-line-function 'insert-tab)
                   (setq octave-block-offset 2)


                   ;; (setq comment-use-syntax f)
                   ;; (setq comment-column (save-excursion (forward-line -1)(current-indentation)))
                   ;; (setq comment-start-skip f)
                   (defun octave-indent-comment ()
                     "A function for `smie-indent-functions' (which see)."
                     (save-excursion
                       (back-to-indentation)
                       (cond
                        ((octave-in-string-or-comment-p) nil)
                        ((looking-at-p "\\(\\s<\\)\\1\\{2,\\}") 0))))

                   )))

;; (modify-syntax-entry ?% "<"  octave-mode-syntax-table)

(provide 'init-octave)
