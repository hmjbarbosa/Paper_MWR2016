'reinit'
'set display color white'
'clear'
'set grads off'
'set datawarn off'

'open temp.ctl'
'set t 1 last'
*'set vrange 4.3 5.7'
'set vrange -0.6 0.6'
*'set vrange 0 1'
'set parea 1 9.2 0.7 7.6'
'set xlopts 1 1 0.16'
'set ylopts 1 1 0.16'

* prob 10, 12, 15, 17, 20
cc='-c '
mm='-m '
ll='-l '
tt='-t '
i=1
while (i<=21)
  say 'fazendo i='i'...'
  if (i<10)
    var='var0'i
  else
    var='var'i
  endif
  'set cmark 'i
  'set ccolor 'i
  cc=cc' 'i
  mm=mm' 'i
  ll=ll' 'i
  tt=tt' "gps'i'"'
  'd 'var
  i=i+1
endwhile
'cbar_line -x 9.5 -y 8.2 'cc' 'mm' 'll' 'tt
'draw title PWV (cm)'
*
