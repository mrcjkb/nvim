;; extends

(quasiquote
  (_
    (module) @_mod
    . (variable) @_name
  ) 
  (#eq? @_mod "Log")
  (#any-of? @_name "t" "d" "i" "w" "e")
  (quasiquote_body) @string
) 
(quasiquote
  (_
    (module) @_mod
    . (variable) @keyword.exception
  ) 
  (#eq? @_mod "Log")
  (#eq? @keyword.exception "e")
) 

((variable) @keyword.exception
  (#any-of? @keyword.exception 
   "throwString"
   "throwWhenNothing"
   "failWhenNothing"
   "failWhenLeft_"
  ))

((variable) @keyword.exception
  (#any-of? @keyword.exception 
   "throwString"
   "throwWhenNothing"
   "failWhenNothing"
   "failWhenLeft_"
  ))

; Blocking STM calls "@keyword.blocking" is a non-standard capture
((variable) @keyword.blocking
  (#any-of? @keyword.blocking
   "putTMVar"
   "putTMVarIO"
   "takeTMVar"
   "takeTMVarIO"
   "readTMVar"
   "readTMVarIO"
   "swapTMVar"
   "swapTMVarIO"
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
   "writeTQueue"
   "writeTQueueIO"
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
  ))
