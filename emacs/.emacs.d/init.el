;;
;; package
;;

;; this enables this running method
;;   emacs -q -l ~/.debug.emacs.d/{{pkg}}/init.el
(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
           (file-name-directory (or load-file-name byte-compile-current-file))))))

(eval-and-compile
  (customize-set-variable
   'package-archives '(("org"   . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu"   . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
                                        ;(leaf hydra :ensure t)
                                        ;(leaf el-get :ensure t)
                                        ;(leaf blackout :ensure t)
    (leaf magit :ensure t)
    (leaf markdown-mode :ensure t)
    (leaf ddskk :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))

(leaf leaf
  :config
  (leaf leaf-convert :ensure t)
  (leaf leaf-tree
    :ensure t
    :custom ((imenu-list-size . 30)
             (imenu-list-position . 'left))))

(leaf macrostep
  :ensure t
  :bind (("C-c e" . macrostep-expand)))

;; disable auto-adding :custom vars to init.el

(leaf custom-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :tag "builtin" "faces" "help"
  :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))

(leaf general-settings
  :doc "define customization properties of builtins"
  :tag "builtin" "internal"
  :bind (("C-h" . 'backward-delete-char)
         ("C-M-h" . 'backward-delete-word)
         ("C-M-r" . 'query-replace-regexp)
         ("M-r" . 'replace-regexp)
         ("C-c l" . 'goto-line)
         )
  :custom '((user-full-name . "Ken Miura")
            (user-mail-address . "miuraken@")
            (user-login-name . "miuraken")
            (create-lockfiles . nil)
            (debug-on-error . t)
            (init-file-debug . t)
            (frame-resize-pixelwise . t)
            (enable-recursive-minibuffers . t)
            (history-length . 10000)
            (history-delete-duplicates . t)
            (scroll-preserve-screen-position . t)
            (scroll-conservatively . 100)
            (mouse-wheel-scroll-amount . '(1 ((control) . 5)))
            (ring-bell-function . 'ignore)
            (text-quoting-style . 'straight)
            (truncate-lines . t)
            (use-dialog-box . nil)
            (use-file-dialog . nil)
            (menu-bar-mode . nil)
            (tool-bar-mode . nil)
            (column-number-mode . t)
            (setq ring-bell-function . 'ignore) ; no-beep no-flash
            (scroll-bar-mode . nil)
            (indent-tabs-mode . nil)
            ;;(global-whitespace-mode . nil)
            (eol-mnemonic-dos . " CRLF")
            (eol-mnemonic-mac . " CR")
            (eol-mnemonic-unix . " LF")
            (inhibit-splash-screen . t)
            (scroll-step . 1)
            (scroll-conservatively . 1)
            (scroll-margin . 3)
            (show-trailing-whitespace . 1))
  :setq-default ((find-file-visit-truename . t))
  :config

  (set-locale-environment nil)
  (set-language-environment "Japanese")
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-buffer-file-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  (prefer-coding-system 'utf-8)
  (add-to-list 'safe-local-variable-values
               '(testing . "YES"))
  (keyboard-translate ?\C-h ?\C-?))

(leaf leaf-convert
  :config
  (defalias 'yes-or-no-p 'y-or-n-p))

(leaf autorevert
  :doc "revert buffers when files on disk change"
  :tag "builtin"
  :custom ((auto-revert-interval . 1))
  :global-minor-mode global-auto-revert-mode)

(leaf paren
  :doc "highlight matching paren"
  :tag "builtin"
  :custom ((show-paren-delay . 0.1))
  :global-minor-mode show-paren-mode)

(leaf simple
  :doc "basic editing commands for Emacs"
  :tag "builtin" "internal"
  :custom ((kill-ring-max . 100)
           (kill-read-only-ok . t)
           (kill-whole-line . t)
           (eval-expression-print-length . nil)
           (eval-expression-print-level . nil)))

(leaf files ;;; backup file
  :doc "file input and output commands for Emacs"
  :tag "builtin"
  :custom `((auto-save-timeout . 15)
            (auto-save-interval . 60)
            (auto-save-file-name-transforms . '((".*" ,(locate-user-emacs-file "backup/") t)))
            (backup-directory-alist . '((".*" . ,(locate-user-emacs-file "backup"))
                                        (,tramp-file-name-regexp . nil)))
            (version-control . t)
            (kept-new-versions . 5)
            (kept-old-versions . 1)
            (create-lockfiles . nil)
            (delete-old-versions . t)))


(leaf startup
  :doc "process Emacs shell arguments"
  :tag "builtin" "internal"
  :custom `((auto-save-list-file-prefix . ,(locate-user-emacs-file "backup/.saves-"))))

(leaf magit
  :doc "A Git porcelain inside Emacs."
  :req "emacs-25.1" "compat-29.1.3.4" "dash-20221013" "git-commit-20230101" "magit-section-20230101" "transient-20230201" "with-editor-20230118"
  :tag "vc" "tools" "git" "emacs>=25.1"
  :url "https://github.com/magit/magit"
  :added "2023-07-05"
  :emacs>= 25.1
  :ensure t)

(leaf ddskk
  :doc "Simple Kana to Kanji conversion program."
  :req "ccc-1.43" "cdb-20141201.754"
  :tag "input method" "mule" "japanese"
  :url "https://github.com/skk-dev/ddskk"
  :added "2023-07-05"
  :bind (("C-x C-j" . skk-auto-fill-mode))
  :pre-setq ((default-input-method . "japanese-skk")
             (skk-large-jisyo . "~/.emacs.d/skk-get-jisyo/SKK-JISYO.L")
             (skk-egg-like-newline . t)      ; 変換時にリターンでは改行しない)
             (skk-henkan-okuri-strictly . nil)
             )
  :require skk-study
  :ensure t
  :config
  (skk-get "~/.emacs.d/skk-get-jisyo")
  )


;;
;; Mini Buffer
;;

(leaf vertico
  :ensure t
  :preface
  (defun my:disable-selection ()
    (when (eq minibuffer-completion-table #'org-tags-completion-function)
      (setq-local vertico-map minibuffer-local-completion-map
                  completion-cycle-threshold nil
                  completion-styles '(basic))))

  :advice
  ((:before vertico--setup
            my:disable-selection)
   )
  :bind
  (:vertico-map (("C-l" . my:filename-upto-parent)))
  :custom-face
  `((vertico-current
     . '((t (:inherit hl-line :background unspecified)))))
  :custom
  `((vertico-count . 9)
    (vertico-cycle . t)
    (enable-recursive-minibuffers . t)
    (vertico-resize . nil)
    (vertico-multiline . '(("↓" 0 1 (face vertico-multiline))
                           ("…" 0 1 (face vertico-multiline))))
    )
)


(setq recentf-max-saved-items 2000)
(setq recentf-auto-cleanup 'never)
(setq recentf-exclude '("/recentf" "COMMIT_EDITMSG" "/.?TAGS"))
(setq recentf-auto-save-timer (run-with-idle-timer 30 t 'recentf-save-list))
(recentf-mode 1)

(leaf consult
  :doc "Consulting completing-read"
  :req "emacs-27.1" "compat-29.1.4.1"
  :tag "completion" "files" "matching" "emacs>=27.1"
  :url "https://github.com/minad/consult"
  :added "2023-07-06"
  :emacs>= 27.1
  :ensure t
  :bind (("C-M-s" . consult-line)
         ("C-x l" . consult-goto-line))
  :after compat)

(leaf orderless
  :ensure t
  ;; :init (leaf flx :ensure t)
  :custom
  `((completion-styles . '(orderless))
    (orderless-matching-styles
     . '(orderless-prefixes
         orderless-flex
         orderless-regexp
         orderless-initialism
         orderless-literal))
    )
  )


(leaf marginalia
  :doc "Enrich existing commands with completion annotations"
  :req "emacs-27.1" "compat-29.1.4.0"
  :tag "completion" "matching" "help" "docs" "emacs>=27.1"
  :url "https://github.com/minad/marginalia"
  :added "2023-07-06"
  :emacs>= 27.1
  :ensure t
  :after compat
  :hook ((emacs-startup-hook . marginalia-mode))
)


(leaf savehist
  :doc "Save minibuffer history"
  :tag "builtin"
  :added "2023-07-05")


(leaf init_hook
    :preface
    (defun after-init-hook nil
      (vertico-mode)
      (savehist-mode))
    :hook ((after-init-hook . after-init-hook)))


(leaf generic-x
  :doc "A collection of generic modes"
  :tag "builtin" "font-lock" "comment" "generic"
  :added "2023-07-05")

(setq env-file (expand-file-name "local.el" user-emacs-directory))
(when (file-exists-p env-file) (load env-file))

(load "env")
(provide 'init)
(put 'narrow-to-region 'disabled nil)
