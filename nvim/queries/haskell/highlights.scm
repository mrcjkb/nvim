;; extends

; NOTE: lsp semantic tokens have priority 125

(quasiquote
  (quoter
    (_
      (module (module_id) @_mod)
      . (variable) @_name))
  (#eq? @_mod "Log")
  (#any-of? @_name "t" "d" "i" "w" "e")
  (quasiquote_body) @string) 

(quasiquote
  (quoter
    (_
      (module (module_id) @_mod)
      . (variable) @keyword.exception))
  (#eq? @_mod "Log")
  (#eq? @keyword.exception "e"))

((variable) @keyword.exception
  (#any-of? @keyword.exception 
   "throwString"
   "throwWhenNothing"
   "failWhenNothing"
   "failWhenLeft_"
  )
  (#set! "priority" 200))

((variable) @keyword.exception
  (#any-of? @keyword.exception 
   "throwString"
   "throwWhenNothing"
   "failWhenNothing"
   "failWhenLeft_"
  )
  (#set! "priority" 200))

; Blocking STM calls "@keyword.blocking" is a non-standard capture
((variable) @keyword.blocking
  (#any-of? @keyword.blocking
   "readMVar"
   "putMVar"
   "takeMVar"
   "putTMVar"
   "putTMVarIO"
   "takeTMVar"
   "takeTMVarIO"
   "readTMVar"
   "readTMVarIO"
   "swapTMVar"
   "swapTMVarIO"
   "swapTMVar_"
   "swapTMVarIO_"
   "readTBQueue"
   "readTBQueueIO"
   "peekTBQueue"
   "peekTBQueueIO"
   "writeTBQueue"
   "writeTBQueueIO"
   "unGetTBQueue"
   "unGetTBQueueIO"
   "readTQueue"
   "readTQueueIO"
   "peekTQueue"
   "peekTQueueIO"
   "unGetTQueue"
   "unGetTQueueIO"
   "readTChan"
   "readTChanIO"
   "peekTChan"
   "peekTChanIO"
   "unGetTChan"
   "unGetTChanIO"
   "waitTSem"
   "waitTSemIO"
  )
  (#set! "priority" 200))
