(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(use-package doom-modeline :ensure t)
(doom-modeline-mode 1)

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-gruvbox t)
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(set-fringe-mode -1)

(add-hook 'after-init-hook 'eshell)

(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "~/.emacs.d/auto-save/"))))

(set-frame-parameter (selected-frame) 'alpha '(95 . 75))
(add-to-list 'default-frame-alist '(alpha . (95 . 75)))

(defun jwd/org-startup ()
  (org-superstar-mode 1)
  (visual-line-mode 1))

(defun jwd/org-mode-visual-fill-column ()
  (setq-local visual-fill-column-width 100
              visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package org-superstar :ensure t)

(use-package org
  :init
  ;; Org reads startup options before running org-mode-hook.
  ;; Setting the org-indent-mode variable does not enable the minor mode.
  (setq org-odd-levels-only t
        org-ellipsis "  ⬎"
        org-hide-emphasis-markers t
        org-startup-indented t)
  :hook (org-mode . jwd/org-startup))

(use-package visual-fill-column
  :ensure t
  :hook (org-mode . jwd/org-mode-visual-fill-column))

(defun jwd/org-insert-backtick (n)
  "Insert N Org code markers, or wrap the active region as code.
In literal blocks and inline source, insert actual backticks instead.
Use C-q ` to insert a literal backtick anywhere."
  (interactive "p")
  (cond
   ((org-element-lineage (org-element-context)
                         '(src-block example-block export-block
                           inline-src-block fixed-width keyword node-property)
                         t)
    (insert (make-string n ?`)))
   ((use-region-p) (org-emphasize ?~))
   (t (insert (make-string n ?~)))))

(defun jwd/org-backtick-clear (beg end)
  "Remove this mode's display properties between BEG and END."
  (with-silent-modifications
    (let ((pos beg))
      (while (< pos end)
        (let ((next (next-single-property-change
                     pos 'jwd/org-backtick nil end)))
          (when (get-text-property pos 'jwd/org-backtick)
            (remove-text-properties
             pos next '(display nil jwd/org-backtick nil)))
          (setq pos next))))))

(defun jwd/org-backtick-fontify (beg end)
  "Display Org code delimiters between BEG and END as backticks."
  (save-excursion
    (save-match-data
      (with-silent-modifications
        (jwd/org-backtick-clear beg end)
        (goto-char beg)
        (while (re-search-forward "~" end t)
          (let* ((pos (1- (point)))
                 (element (save-excursion
                            (goto-char pos)
                            (org-element-context))))
            ;; Use the parsed boundaries, not the face: a tilde inside
            ;; code or a source block must retain its original appearance.
            (when (and (eq (org-element-type element) 'code)
                       (memq pos
                             (list (org-element-property :begin element)
                                   (- (org-element-property :end element)
                                      (org-element-property :post-blank element)
                                      1))))
              (put-text-property pos (1+ pos) 'display "`")
              (put-text-property pos (1+ pos) 'jwd/org-backtick t)
              (remove-text-properties pos (1+ pos) '(invisible nil))))))))
  `(jit-lock-bounds ,beg . ,end))

(define-minor-mode jwd/org-backtick-mode
  "Display Org code markers as backticks without changing stored text."
  :lighter ""
  (if jwd/org-backtick-mode
      (add-hook 'jit-lock-functions #'jwd/org-backtick-fontify 91 t)
    (remove-hook 'jit-lock-functions #'jwd/org-backtick-fontify t)
    (save-restriction
      (widen)
      (jwd/org-backtick-clear (point-min) (point-max))))
  (font-lock-flush))

(add-hook 'org-mode-hook #'jwd/org-backtick-mode)
(with-eval-after-load 'org
  (define-key org-mode-map (kbd "`") #'jwd/org-insert-backtick))

(use-package ox-gfm
  :ensure t
  :after org)

(defun jwd/org-copy-as-markdown ()
  "Copy the active region or current Org buffer as Markdown."
  (interactive)
  (require 'ox-gfm)
  (let ((org-export-use-babel nil))
    (kill-new (org-export-as 'gfm nil nil t
                             '(:with-toc nil :section-numbers nil))))
  (message "Copied Markdown to the kill ring"))

(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c w") #'jwd/org-copy-as-markdown))

(font-lock-add-keywords 'org-mode
    '(("^ *\\([-]\\) "
       (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

;; org: quickly insert src blocks (with or without language)
(require 'org-tempo)

;; generic "open" source block (no language)
(add-to-list 'org-structure-template-alist
             '("conf" . "src conf"))

;; language specific templates
(add-to-list 'org-structure-template-alist
             '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist
             '("py" . "src python"))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)))

(setq org-confirm-babel-evaluate nil)

(defun jwd/org-babel-tangle-qtile-config ()
  (when (string-equal (buffer-file-name)
		      (expand-file-name "~/.dotfiles/QTile.org"))
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'jwd/org-babel-tangle-qtile-config)))

(defun jwd/org-babel-tangle-emacs-config ()
  (when (string-equal (buffer-file-name)
		      (expand-file-name "~/.dotfiles/Emacs.org"))
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'jwd/org-babel-tangle-emacs-config)))

(defun jwd/org-babel-tangle-i3-config ()
  (when (string-equal (buffer-file-name)
		      (expand-file-name "~/.dotfiles/i3.org"))
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'jwd/org-babel-tangle-i3-config)))

;; stop Org from indenting source blocks errantly
(setq org-src-tab-acts-natively t
      org-edit-src-content-indentation 0
      org-src-preserve-indentation t
      org-adapt-indentation nil)

(add-hook 'org-mode-hook (lambda ()
                           (electric-indent-local-mode -1)))

(use-package counsel :ensure t)
(ivy-mode)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> o") 'counsel-describe-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(ox-gfm visual-fill-column use-package setup org-superstar org-bullets modus-themes doom-themes doom-modeline counsel)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
