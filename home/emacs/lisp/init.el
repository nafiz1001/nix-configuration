;; -*- lexical-binding: t; -*-

;; Borrowed a crap ton of configuration from https://github.com/daviwil/dotfiles/blob/master/Emacs.org

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; https://stackoverflow.com/a/13983506
(defun nuke-all-buffers ()
  (interactive)
  (mapcar 'kill-buffer (buffer-list))
  (delete-other-windows))

;; UI

(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)
(setq visible-bell t)

(scroll-bar-mode 'right)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode t)

;; Font

(defun my-configure-font ()
  "Configure font for first frame"
  (let ((my-font (lambda (n)
		   (concat
		    (face-attribute 'default :family)
		    "-"
		    (number-to-string n)))))
    (set-face-attribute 'default nil :font (funcall my-font 15))

    ;; https://emacs.stackexchange.com/a/1062
    (let ((faces '(mode-line
		   mode-line-buffer-id
		   mode-line-emphasis
		   mode-line-highlight
		   mode-line-inactive)))
      (mapc
       (lambda
	 (face)
	 (set-face-attribute face nil :font (funcall my-font 10)))
       faces)))
  (if (daemonp)
      (remove-hook 'server-after-make-frame-hook #'my-configure-font)
    (remove-hook 'window-setup-hook #'my-configure-font)))

(if (daemonp)
    (add-hook 'server-after-make-frame-hook #'my-configure-font)
  (add-hook 'window-setup-hook #'my-configure-font))

;; Scrolling

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(setq use-dialog-box nil) ;; Disable dialog boxes since they weren't working in Mac OSX

(setq-default truncate-lines t) ;; avoid awkward scrolling

;; Line/Number


(column-number-mode)

(global-display-line-numbers-mode t)

(defun disable-line-number ()
  (display-line-numbers-mode 0))

(defun enable-line-number ()
  (display-line-numbers-mode 0))

;; Enable line numbers for some modes
(dolist (mode '(text-mode-hook
		prog-mode-hook
		conf-mode-hook))
  (add-hook mode #'enable-line-number))

;; Override some modes which derive from the above
(dolist (mode '(org-mode-hook))
  (add-hook mode #'disable-line-number))

;; prevent number lines in shell/term
;; https://github.com/daviwil/emacs-from-scratch/blob/d23348b4a52dde97f4f7cbcd66a519b5fd0a143c/init.el#L82-L88
(dolist (mode '(term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
  (add-hook mode #'disable-line-number))

;; Auto-revert

(global-auto-revert-mode 1)
(setq global-auto-revert-mode t)

;; Native Compilation

(setq native-comp-async-report-warnings-errors nil)

;; Dired

(put 'dired-find-alternate-file 'disabled nil)

;; LSP

(setq gc-cons-threshold (* 1024 1024))
(setq read-process-output-max (* 1024 1024))

;; Paren

(require 'paren)
(setq show-paren-style 'parenthesis)
(show-paren-mode +1)

;; Coding System

(set-default-coding-systems 'utf-8)

;; Recursive Minibuffer

(setq enable-recursive-minibuffers  t)
(minibuffer-depth-indicate-mode 1)

;; Theme

(setq modus-themes-italic-constructs t
      modus-themes-bold-constructs nil
      modus-themes-region '(bg-only no-extend))
(load-theme 'modus-vivendi t)

;; Org

(setq org-agenda-files (file-expand-wildcards "~/org/*.org"))
(setq org-startup-folded t)
(setq org-adapt-indentation nil)
(setq org-src-tab-acts-natively t)
(setq org-cycle-separator-lines 0)

(require 'setup)

(setup-define :load-after
  (lambda (features &rest body)
    (let ((body `(progn
		   (require ',(setup-get 'feature))
		   ,@body)))
      (dolist (feature (if (listp features)
			   (nreverse features)
			 (list features)))
	(setq body `(with-eval-after-load ',feature ,body)))
      body))
  :documentation "Load the current feature after FEATURES."
  :indent 1)

(setup (:if-package no-littering)
  (require 'no-littering)
  (setq custom-file (no-littering-expand-etc-file-name "custom.el"))
  (when (fboundp 'startup-redirect-eln-cache)
    (startup-redirect-eln-cache
     (convert-standard-filename
      (expand-file-name  "var/eln-cache/" user-emacs-directory)))))

(setup (:if-package nix-mode)
  (require 'nix-mode)
  (add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode)))

(setup (:if-package rainbow-delimiters)
  (require 'rainbow-delimiters)
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(setup (:if-package hl-todo)
  (require 'hl-todo)
  (define-key hl-todo-mode-map (kbd "C-c p") 'hl-todo-previous)
  (define-key hl-todo-mode-map (kbd "C-c n") 'hl-todo-next)
  (define-key hl-todo-mode-map (kbd "C-c o") 'hl-todo-occur)
  (define-key hl-todo-mode-map (kbd "C-c i") 'hl-todo-insert)
  (global-hl-todo-mode))

(setup (:if-package nyan-mode)
  (require 'nyan-mode)
  (nyan-mode 1))

(setup (:if-package vterm)
  (require 'vterm)
  (add-hook 'vterm-mode-hook #'disable-line-number)
  (setq vterm-max-scrollback 1000)
  (defun new-term (buffer-name)
    (interactive "sbuffer name: ")
    (vterm vterm-shell)
    (rename-buffer buffer-name t)))

(setup (:if-package helpful)
  (require 'helpful)
  (global-set-key (kbd "C-h f") #'helpful-callable)
  (global-set-key (kbd "C-h v") #'helpful-variable)
  (global-set-key (kbd "C-h k") #'helpful-key)
  (global-set-key (kbd "C-c C-d") #'helpful-at-point)
  (global-set-key (kbd "C-h F") #'helpful-function)
  (global-set-key (kbd "C-h C") #'helpful-command))


(setup (:if-package undo-tree)
  (require 'undo-tree)
  (setq undo-tree-auto-save-history nil)
  (global-undo-tree-mode 1))

(setup (:if-package evil)
  ;; Pre-load configuration
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-respect-visual-line-mode t)

  (:load-after undo-tree
    (setq evil-undo-system 'undo-tree))

  (require 'evil)

  ;; Activate the Evil
  (evil-mode 1)

  ;; Set Emacs state modes
  (dolist (mode '(custom-mode
		  eshell-mode
		  git-rebase-mode
		  erc-mode
		  circe-server-mode
		  circe-chat-mode
		  circe-query-mode
		  sauron-mode
		  term-mode))
    (add-to-list 'evil-emacs-state-modes mode))

					; (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
					; (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(setup (:if-package evil-collection)
  (require 'evil-collection)
  ;; Is this a bug in evil-collection?
  (setq evil-collection-company-use-tng nil)
  (:load-after evil
    (:option evil-collection-outline-bind-tab-p nil
	     (remove evil-collection-mode-list) 'lispy
	     (remove evil-collection-mode-list) 'org-present)
    (evil-collection-init)))

(setup (:if-package evil-commentary)
  (:load-after evil
    (require 'evil-commentary)
    (evil-commentary-mode)))

(setup (:if-package magit))

(setup (:if-package git-gutter)
  (require 'git-gutter)
  (global-git-gutter-mode +1))

(setup (:if-package company-mode)
  (require 'company-mode)
  (add-hook 'after-init-hook 'global-company-mode))

(setup (:if-package yasnippet)
  (require 'yasnippet)
  (define-key yas-minor-mode-map (kbd "<tab>") nil)
  (define-key yas-minor-mode-map (kbd "TAB") nil)
  (define-key yas-minor-mode-map (kbd "C-c y") #'yas-expand)
  (yas-global-mode 1))

(setup (:if-package vertico)
  (require 'vertico)
  (vertico-mode))

(setup (:if-package orderless)
  (require 'orderless)
  (setq completion-styles '(orderless)
	completion-category-defaults nil
	completion-category-overrides '((file (styles . (partial-completion))))))

(setup (:if-package consult)
  (require 'consult)
  (:global "C-s" consult-line
	   "C-M-l" consult-imenu
	   "C-M-j" persp-switch-to-buffer*)

  (:with-map minibuffer-local-map
    (:bind "C-r" consult-history))

  (defun dw/get-project-root ()
    (when (fboundp 'projectile-project-root)
      (projectile-project-root)))

  (:option consult-project-root-function #'dw/get-project-root
	   completion-in-region-function #'consult-completion-in-region))


(setup (:if-package marginalia)
  (:option marginalia-annotators '(marginalia-annotators-heavy
				   marginalia-annotators-light
				   nil))
  (require 'marginalia)
  (marginalia-mode))

(setup (:if-package embark-consult))

(setup (:if-package embark)
  (:also-load embark-consult)
  (:global "C-S-a" embark-act)
  (:with-map minibuffer-local-map
    (:bind "C-d" embark-act)))


(setup (:if-package projectile)
  (when (file-directory-p "~/src")
    (setq projectile-project-search-path '("~/src")))

  (projectile-mode)

  (:global "C-M-p" projectile-find-file
	   "C-c p" projectile-command-map))

(setup (:if-package flycheck)
  (:hook-into lsp-mode))

(setup (:if-package smartparens)
  (:hook-into prog-mode))

(setup (:if-package tree-sitter)
  (require 'tree-sitter)
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))
(setup (:if-package tree-sitter-langs) (:load-after tree-sitter))

(setup (:if-package json-mode))

(setup (:if-package auctex)
  (setq TeX-auto-save t)
  (setq TeX-parse-self t))

(add-to-list 'auto-mode-alist '("\\.[ts]sx?$" . javascript-mode))

(setup (:if-package rustic))

(setup (:if-package go-mode)
  (add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode)))

(setup (:if-package slime)
  (setq inferior-lisp-program (executable-find "sbcl" exec-path)))

(setup (:if-package tuareg))
(setup (:if-package merlin))
(setup (:if-package merlin-company))
(setup (:if-package merlin-eldoc))

(setup (:if-package lsp-mode)
  (setq lsp-keymap-prefix "C-c l")
  (require 'lsp-mode)
  (setq lsp-lens-enable nil)
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-signature-render-documentation nil)
  (add-hook 'javascript-mode-hook #'lsp-deferred)
  (add-hook 'go-mode-hook #'lsp-deferred))

(setup (:if-package lsp-ui)
  (setq lsp-ui-doc-show-with-cursor nil)
  (setq lsp-ui-doc-show-with-mouse t)
  (setq lsp-ui-sideline-enable nil))

(setup (:if-package lsp-pyright)
  (:load-after lsp-mode
    (add-hook 'python-mode-hook (lambda ()
				  (require 'lsp-pyright)
				  (lsp-deferred)))
    (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]env\\'")))

(setup (:if-package envrc))
