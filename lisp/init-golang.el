(require-package 'go-mode)
;; (require-package 'flymake-go)
;;(require-package 'company-go)
(require-package 'exec-path-from-shell)
(require-package 'go-guru)
(require-package 'go-dlv)
(require-package 'go-eldoc)
;; NOTE: go-impl is currently incompatible with ivy so we are
;; keeping it disabled.
;;(require-package 'go-impl)
(require-package 'go-projectile)
(require-package 'godoctor)
(require-package 'go-stacktracer)
(require-package 'go-snippets)

;; Snag the user's GOPATH
(when (memq window-system '(mac ns))
  (exec-path-from-shell-copy-env "GOPATH"))

;; Define function to call when go-mode loads
(defun my-go-mode-hook ()
  (add-hook 'before-save-hook #'gofmt-before-save) ; gofmt before every save
  (setq gofmt-command "goimports")                 ; gofmt uses invokes goimports
  (if (not (string-match "go" compile-command))    ; set compile command default
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))

  ;; go-guru settings
  (go-guru-hl-identifier-mode)                     ; highlight identifiers

  ;; Key bindings specific to go-mode
  (local-set-key (kbd "M-.") 'godef-jump)          ; Go to definition
  (local-set-key (kbd "M-*") 'pop-tag-mark)        ; Return from where you came
  (local-set-key (kbd "C-c ?") 'godoc-at-point)

  ;; Refactoring keybord shortcuts
  (local-set-key (kbd "C-c C-g r") 'godoctor-rename)
  (local-set-key (kbd "C-c C-g e") 'godoctor-extract)
  (local-set-key (kbd "C-c C-g d") 'go-goto-docstring)
  (local-set-key (kbd "C-c C-g v") 'godoctor-toggle)

  ;; Company (autocomplate)
  ;;(set (make-local-variable 'company-backends) '(company-go))
  ;;(company-mode)
  ;;(local-set-key (kbd "M-/") 'company-complete)

  ;; M-/ : company-complete
  ;; C-c ; : comment-or-uncomment

  ;; go-eldoc
  (go-eldoc-setup)
  )

;; Connect go-mode-hook with the function we just defined
(add-hook 'go-mode-hook 'my-go-mode-hook)

(when (maybe-require-package 'company-go)
  (after-load 'company
    (add-hook 'go-mode-hook
              (lambda () (sanityinc/local-push-company-backend 'company-go)))))

;; C-c C-a : go-import-add (add a new import)
;; go-remove-unused-imports

;; C-c C-d : describe expressions

;; Playground:
;; go-play-buffer, go-play-region: send to playground
;; go-download-play: download from playground
;; go-coverage

;; With compile errors:
;; M-g n : next-error
;; M-g p : previous-error

(after-load 'go-mode
  (add-hook 'go-mode-hook
            (lambda ()
              (guide-key/add-local-guide-key-sequence "C-c C-g")
              (guide-key/add-local-guide-key-sequence "C-c C-f")
              (guide-key/add-local-guide-key-sequence "C-c C-o") )))

;; ;; Add some go keybindings to guide-key
;; (after-load 'go-mode
;;   (add-to-list 'guide-key/guide-key-sequence "C-c C-g"))

;; ;; Add guide-key for go-goto-map
;; (after-load 'go-mode
;;   (add-to-list 'guide-key/guide-key-sequence "C-c C-f"))

;; ;; Add guide-key for go-guru
;; (after-load 'go-guru
;;   (add-to-list 'guide-key/guide-key-sequence "C-c C-o"))

;; ;; (after-load 'flycheck
;; ;;   (add-to-list 'guide-key/guide-key-sequence "C-c !")))


(provide 'init-golang)
