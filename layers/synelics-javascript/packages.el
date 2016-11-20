;; ;;; packages.el --- synelics-completion Layer packages File for Spacemacs
;; ;;
;; ;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;; ;;
;; ;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; ;; URL: https://github.com/syl20bnr/spacemacs
;; ;;
;; ;; This file is not part of GNU Emacs.
;; ;;
;; ;;; License: GPLv3

(setq synelics-javascript-packages
      '(
        js2-mode
        ycmd
        company-ycmd
        flycheck
        ))

(defun synelics-javascript/init-js2-mode ()
  (use-package js2-mode
    :defer t
    :mode "\\.js\\'"
    :init
    (progn
      (setq js-indent-level 2)

      (add-hook 'js2-mode-hook (lambda ()
                                 (setq mode-name "JavaScript")
                                 (js2-mode-hide-warnings-and-errors)))

      (synelics-core|add-hook 'js2-mode
                              'ycmd-mode
                              'paredit-mode
                              'subword-mode
                              'flycheck-mode
                              'evil-matchit-mode)

      (synelics-core|add-hook 'js2-mode
                              (lambda ()
                                (define-key evil-normal-state-local-map
                                  (kbd "C-]")
                                  (synelics-core|center-cursor-after-call 'synelics//js-goto-definition))
                                (define-key evil-normal-state-local-map
                                  (kbd "C-t")
                                  (synelics-core|center-cursor-after-call 'pop-tag-mark)))))
    :config
    (progn
      (spacemacs/set-leader-keys-for-major-mode 'js2-mode
        "zo" 'js2-mode-toggle-element))))

(defun synelics-javascript/post-init-ycmd ()
  (use-package ycmd
    :defer t
    :init
    (spacemacs|add-company-hook js2-mode)))

(defun synelics-javascript/post-init-flycheck ()
  (use-package flycheck
    :defer t
    :init
    (synelics-core|add-hook 'js2-mode
                            (lambda () (setq-default flycheck-enabled-checkers '(javascript-standard))))))

(defun synelics-javascript/post-init-company-ycmd ()
  (use-package company-ycmd
    :defer t
    :if (and (configuration-layer/package-usedp 'company)
             (configuration-layer/package-usedp 'ycmd))
    :init
    (push 'company-ycmd company-backends-js2-mode)))

