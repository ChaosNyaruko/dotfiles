(add-to-list 'load-path "~/evil")
(require 'evil)
(evil-mode t)
(setq make-backup-files nil)
(setq org-log-done 'time)
(setq org-agenda-files (list "~/org/home.org"))
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)
