(defun insert-current-date (&optional omit-day-of-week-p)
  "Insert today's date"
  (interactive "P*")
  (insert (calendar-date-string (calendar-current-date) nil
                                omit-day-of-week-p)))
(defun copy-filename()
  "Put the current file name on the clipboard"
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                    default-directory
                    (buffer-file-name))))
    (when filename
      (with-temp-buffer
        (insert filename)
        (clipboard-kill-region (point-min) (point-max)))
      (message filename))))


(defun reload-config ()
  "Reload Emacs Configuration."
  (interactive)
  (load-file (concat user-emacs-directory "init.el")))


;; WSL specific
(defun copy-selected-text (start end)
  (interactive "r")
  (if (use-region-p)
    (let ((text (buffer-substring-no-properties start end)))
      (shell-command (concat "echo '" text "' | clip.exe")))))
