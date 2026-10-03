if exists("b:current_syntax")
  finish
endif

syn case ignore

let s:critical = '\v<(crit|critical|fatal|QFATAL)>'
let s:debug    = '\v<(debug|QDEBUG)>'
let s:error    = '\v<(err|error|fail|failure|QCRITICAL)>'
let s:info     = '\v<(info|information|QINFO)>'
let s:warn     = '\v<(warn|warning|QWARN)>'

" Highlight entire line when it contains a keyword
exec 'syn match LogInfo     /^.*' . s:info     . '.*$/'
exec 'syn match LogDebug    /^.*' . s:debug    . '.*$/'
exec 'syn match LogWarn     /^.*' . s:warn     . '.*$/'
exec 'syn match LogError    /^.*' . s:error    . '.*$/'
exec 'syn match LogCritical /^.*' . s:critical . '.*$/'

" Link to standard highlight groups for colorscheme
hi def link LogInfo     PreProc
hi def link LogDebug    Type
hi def link LogWarn     WarningMsg
hi def link LogError    ErrorMsg
hi def link LogCritical Error

let b:current_syntax = "logfile"
