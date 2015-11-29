;; Spaces, not tabs
(setq-default indent-tabs-mode nil)
;; Tab width is now 2
(setq-default tab-width 2)
;; same for js mode
(setq js-indent-level 2)
;; pairing of parens
(electric-pair-mode 1)
;; Indent Level?
(setq-default indent-level 2)
(setq-default evil-shift-width 2)


;;(add-hook 'js-mode-hook
;;    (function (lambda ()
;;        (setq evil-shift-width js-indent-level))))

;; adds line numbers to sourcecode files
(add-hook 'prog-mode-hook
  (function (lambda ()
    (linum-mode 1))))


(setq-default c-basic-offset 2
              tab-width 2
              indent-tabs-mode nil)

;; (defun my-java-conf ()
;;   "Java mode mods"
;;   (setq indent-tabs-mode nil)
;;   (setq indent-level 2)
;;   (setq tab-width 2))

; java indent should be 2
;; (add-hook 'java-mode-hook 'my-java-conf)

;;(let ((default-directory "/usr/share/emacs/site-lisp/"))
;;  (normal-top-level-add-subdirs-to-load-path))

;;(setq x-select-enable-clipboard-manager nil)

;;(let ((default-directory "/usr/local/share/emacs/site-lisp/"))
;;  (normal-top-level-add-subdirs-to-load-path))


;; different site-lisp dirs for different OS's -- enabling shared home
(cond 
  ((string-equal system-type "gnu/linux")
    (let ((default-directory "/usr/share/emacs/site-lisp/"))
      (normal-top-level-add-subdirs-to-load-path)))
  ((string-equal system-type "darwin")
    (let (default-directory "/usr/local/share/emacs/site-lisp/")
      (normal-top-level-add-subdirs-to-load-path))))

;; autosave to file instead of #filename#
;; (defun save-buffer-if-visiting-file (&optional args)
;;   "Save the current buffer only if it is visiting a file"
;;   (interactive)
;;   (if (and (buffer-file-name) (buffer-modified-p))
;;       (save-buffer args)))
;; (add-hook 'auto-save-hook 'save-buffer-if-visiting-file)

;; autosave entire file to the file(no #filename# files or w/e)
(defun full-auto-save ()
  (interactive)
  (save-excursion
    (dolist (buf (buffer-list))
      (set-buffer buf)
      (if (and (buffer-file-name) (buffer-modified-p))
          (basic-save-buffer)))))
(add-hook 'auto-save-hook 'full-auto-save)

;; restore tab functionality in org-mode
(setq evil-want-C-i-jump nil)

(require 'package)
(push '("marmalade" . "http://marmalade-repo.org/packages/")
      package-archives )
(push '("melpa" . "http://melpa.milkbox.net/packages/")
      package-archives)
(package-initialize)
;; Init of evil-tabs-mode MUST occur before evil-mode 1
(global-evil-tabs-mode t)
;; vim mode
(require 'evil)
(require 'evil-leader)
(require 'evil-org)

;; for copy and paste
(require 'pbcopy)
(turn-on-pbcopy)

(evil-mode 1)
;;Yesss, give me a powerline . . .
(require 'powerline)
(powerline-evil-vim-color-theme)

;; evil-surround mode on!
(require 'evil-surround)
(global-evil-surround-mode 1)

;;(powerline-evil-theme)
;; (powerline-default-theme) ; also possible: (powerline-evil-center-color-theme)
(display-time-mode t)

; Ace jump activation, via spacebar in normal mode
(define-key evil-normal-state-map (kbd "SPC") 'ace-jump-mode)

;; start fullscreen
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;;(toggle-frame-maximized)
;; (custom-set-variables
;;  '(initial-frame-alist (quote ((fullscreen . maximized)))))


; auto-complete mode
(global-auto-complete-mode 1)


;; rainbow delimiters in programming modes
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; tabs
(unless (display-graphic-p)
  (require 'evil-terminal-cursor-changer))

;; I like to have a box when naving and a bar when inserting
(setq evil-normal-state-cursor '("green" box))
(setq evil-insert-state-cursor '("green" bar))

;; (load "elscreen" "ElScreen" t)
;; (elscreen-start)
;; (define-key evil-normal-state-map (kbd "C-w t") 'elscreen-create) ;creat tab
;; (define-key evil-normal-state-map (kbd "C-w x") 'elscreen-kill) ;kill tab
;; (define-key evil-normal-state-map "gT" 'elscreen-previous) ;previous tab
;; (define-key evil-normal-state-map "gt" 'elscreen-next) ;next tab

;; Java stuff, with JDEE
;;(add-to-list 'load-path (format "%s/dist/jdee-2.4.1/lisp" my-jdee-path))
;;  (autoload 'jde-mode "jde" "JDE mode" t)
;;  (setq auto-mode-alist
;;        (append '(("\\.java\\'" . jde-mode)) auto-mode-alist))
(add-hook 'java-mode-hook (function (lambda () 
                            (require 'gradle-mode)
                            (gradle-mode 1))))

;; eslint, jsx stuff
;; use web-mode for .jsx files
(add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))

;; http://www.flycheck.org/manual/latest/index.html
(require 'flycheck)

;; turn on flychecking globally
(add-hook 'after-init-hook #'global-flycheck-mode)

;; disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(javascript-jshint)))

;; use eslint with web-mode for jsx files
(flycheck-add-mode 'javascript-eslint 'web-mode)

;; disable json-jsonlist checking for json files
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(json-jsonlist)
;    '(javascript-jscs) ; uncomment to disable javascript-jscs
    ))

;; https://github.com/purcell/exec-path-from-shell
;; only need exec-path-from-shell on OSX
;; this hopefully sets up path and other vars better
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; end of eslint stuffs with jsx

;; start of webmode stuff with indents, etc.
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(defun my-web-mode-hook ()
  "Hooks for Web mode. Adjust indents"
  ;;; http://web-mode.org/
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))
(add-hook 'web-mode-hook  'my-web-mode-hook)

(setq web-mode-enable-current-column-highlight t)

(setq web-mode-ac-sources-alist
  '(("css" . (ac-source-css-property))
    ("html" . (ac-source-words-in-buffer ac-source-abbrev))))

;; end of web-mode stuff for indent setting etc.

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2d3743" "#ff4242" "#74af68" "#dbdb95" "#34cae2" "#008b8b" "#00ede1" "#e1e1e0"])
 '(blink-cursor-mode nil)
 '(compilation-message-face (quote default))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#839496")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(custom-enabled-themes (quote (calmer-forest)))
 '(custom-safe-themes
   (quote
    ("f5eb916f6bd4e743206913e6f28051249de8ccfd070eae47b5bde31ee813d55f" "790e74b900c074ac8f64fa0b610ad05bcfece9be44e8f5340d2d94c1e47538de" "7997e0765add4bfcdecb5ac3ee7f64bbb03018fb1ac5597c64ccca8c88b1262f" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "11636897679ca534f0dec6f5e3cb12f28bf217a527755f6b9e744bd240ed47e1" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" default)))
 '(fci-rule-color "#073642")
 '(highlight-changes-colors (quote ("#d33682" "#6c71c4")))
 '(highlight-symbol-colors
   (--map
    (solarized-color-blend it "#002b36" 0.25)
    (quote
     ("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2"))))
 '(highlight-symbol-foreground-color "#93a1a1")
 '(highlight-tail-colors
   (quote
    (("#073642" . 0)
     ("#546E00" . 20)
     ("#00736F" . 30)
     ("#00629D" . 50)
     ("#7B6000" . 60)
     ("#8B2C02" . 70)
     ("#93115C" . 85)
     ("#073642" . 100))))
 '(hl-bg-colors
   (quote
    ("#7B6000" "#8B2C02" "#990A1B" "#93115C" "#3F4D91" "#00629D" "#00736F" "#546E00")))
 '(hl-fg-colors
   (quote
    ("#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36")))
 '(inhibit-startup-screen t)
 '(magit-diff-use-overlays nil)
 '(nrepl-message-colors
   (quote
    ("#dc322f" "#cb4b16" "#b58900" "#546E00" "#B4C342" "#00629D" "#2aa198" "#d33682" "#6c71c4")))
 '(pos-tip-background-color "#073642")
 '(pos-tip-foreground-color "#93a1a1")
 '(show-paren-mode t)
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#073642" 0.2))
 '(term-default-bg-color "#002b36")
 '(term-default-fg-color "#839496")
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#dc322f")
     (40 . "#c37300")
     (60 . "#b97d00")
     (80 . "#b58900")
     (100 . "#a18700")
     (120 . "#9b8700")
     (140 . "#948700")
     (160 . "#8d8700")
     (180 . "#859900")
     (200 . "#5a942c")
     (220 . "#439b43")
     (240 . "#2da159")
     (260 . "#16a870")
     (280 . "#2aa198")
     (300 . "#009fa7")
     (320 . "#0097b7")
     (340 . "#008fc7")
     (360 . "#268bd2"))))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   (quote
    (unspecified "#002b36" "#073642" "#990A1B" "#dc322f" "#546E00" "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2" "#93115C" "#d33682" "#00736F" "#2aa198" "#839496" "#657b83")))
 '(xterm-color-names
   ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#eee8d5"])
 '(xterm-color-names-bright
   ["#002b36" "#cb4b16" "#586e75" "#657b83" "#839496" "#6c71c4" "#93a1a1" "#fdf6e3"]))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:height 110 :family "Anonymous Pro")))))

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)

(provide 'init)
;;; init.el ends here
