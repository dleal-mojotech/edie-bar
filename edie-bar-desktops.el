;;; edie-bar-desktops.el --- Desktop widget for Edie bar -*- lexical-binding: t -*-

;; Copyright (C) 2022-2023 David Leal

;; Author: David Leal <dleal@mojotech.com>
;; Maintainer: David Leal <dleal@mojotech.com>
;; Created: 2022
;; Version: 0.0.1

;; This file is part of Edie.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(defcustom edie-bar-desktops-icon-color-active "#fe8019"
  "The color of an icon symbolizing the current desktop."
  :type 'color)

(defcustom edie-bar-desktops-icon-color-used "#ffae6c"
  "The color of an icon symbolizing a desktop containing windows."
  :type 'color)

(defcustom edie-bar-desktops-icon 'circle
  "Name of the icon used to symbolize a desktop."
  :type 'symbol)

(defvar edie-bar-desktops--svg nil)

(cl-defmethod edie-widget-render ((widget (head desktops)) update)
  ""
  (add-hook 'edie-wm-desktop-change-hook update)
  (let ((desktop-index (edie-wm-desktop-index (edie-wm-current-desktop)))
        used-desktops)
    (dolist (w (edie-wm-window-list))
      (setq used-desktops (plist-put used-desktops (edie-wm-window-property w :desktop) t)))
    `(box ((spacing . ,(or (dom-attr widget 'spacing) 8)))
       ,@(let ((index 0)
               icons)
           (dolist (d (edie-wm-desktop-list) (nreverse icons))
             (push `(icon ((name . ,(dom-attr widget 'icon))
                           (size . ,(dom-attr widget 'icon-size))
                           (color . ,(cond
                                      ((= desktop-index index)
                                       edie-bar-desktops-color-active)
                                      ((plist-get used-desktops index)
                                       edie-bar-desktops-color-used)))))
                   icons)
             (setq index (1+ index)))))))

(provide 'edie-bar-desktops)
;;; edie-bar-desktops.el ends here
