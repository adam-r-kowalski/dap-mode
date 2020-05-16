;;; dap-cppdbg.el --- Debug Adapter Protocol mode for Python      -*- lexical-binding: t; -*-

;; Copyright (C) 2018  Ivan Yonchovski

;; Author: Ivan Yonchovski <yyoncho@gmail.com>
;; Keywords: languages

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;; URL: https://github.com/yyoncho/dap-mode
;; Package-Requires: ((emacs "25.1") (dash "2.14.1") (lsp-mode "4.0"))
;; Version: 0.2

;;; Commentary:
;; Adapter for ptvsd (https://github.com/Microsoft/ptvsd)

;;; Code:

(require 'dap-mode)

(defun dap-cppdbg--debug-test-at-point ()
  (interactive)
  (dap-debug (dap--template "C++ :: Run doctest (at point)")))

(defun dap-cppdbg--populate-test-at-point (conf)
  "Populate CONF with the required arguments."
  (let ((cwd (concat (lsp-workspace-root) "/build/bin/")))
    (plist-put conf :dap-server-path '("/Users/adamkowalski/.vscode-insiders/extensions/ms-vscode.cpptools-0.28.0-insiders/debugAdapters/OpenDebugAD7"))
    (plist-put conf :cwd cwd)
    (plist-put conf :request "launch")
    (plist-put conf :program (concat cwd "test_omega"))
    (plist-put conf :externalTerminal :json-false)
    (plist-put conf :MIMode "lldb")
    conf))

(dap-register-debug-provider "cppdbg" 'dap-cppdbg--populate-test-at-point)
(dap-register-debug-template "C++ :: Run doctest (at point)"
			     (list :type "cppdbg"
				   :name "C++ :: Run doctest (at point)"))

(provide 'dap-cppdbg)
;;; dap-python.el ends here
