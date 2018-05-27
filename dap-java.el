;;; dap-java.el --- DAP Adapter for Java        -*- lexical-binding: t; -*-

;; Copyright (C) 2018  Ivan

;; Author: Ivan <kyoncho@myoncho>
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

;;; Commentary:

;; DAP Adapter for java

;;; Code:


(require 'lsp-mode)
(require 'dap-mode)

(defun dap-java-create-session ()
  "DD."
  (let* ((debug-port (lsp-send-execute-command "vscode.java.startDebugSession" )))
    (dap--create-session "localhost"
                         debug-port
                         "name")))

(defun dap-java-debug ()
  "XX."
  (interactive)
  (let* ((debug-port (lsp-send-execute-command "vscode.java.startDebugSession" ))
         (mainClass (first (lsp-send-execute-command "vscode.java.resolveMainClass" )))
         (classpath (second
                     (lsp-send-execute-command "vscode.java.resolveClasspath"
                                               (list (gethash "mainClass" mainClass)
                                                     (gethash "projectName" mainClass))))))
    (dap-start-debugging
     "java"
     'dap-java-create-session
     (list :args ""
           :name "Debug (Launch)"
           :request "launch"
           :type "java"
           :cwd (lsp-java--get-root)
           :stopOnEntry :json-false
           :mainClass (gethash "mainClass" mainClass)
           :classPaths classpath
           :modulePaths (vector)
           :debugServer debug-port
           :__sessionId "123123"))))

;; (with-current-buffer "App.java"
;;   (dap-java-debug ))

(provide 'dap-java)
;;; dap-java.el ends here