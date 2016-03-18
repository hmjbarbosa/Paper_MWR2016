'reinit'
rc=gsfallow('on')
'set display color white'
'clear'

* open precipitation data
*'open /LFANAS/hbarbosa/trmmopen.gsfc.nasa.gov/pub/merged/mergeIRMicro/mergeIRMicro.ctl'
'open /LFANAS/hbarbosa/disc2.nascom.nasa.gov/data/TRMM/Gridded/3B42_V7/3B42.ctl'
'set lon -75.125 -44.875 '
'set lat -20.125 10.125 '

* read the list of events
rc=read('grads_All_PWV.list')
ok=sublin(rc,1)
while (ok=0)
  lin=sublin(rc,2)

  id=subwrd(lin,6)
  y.id=subwrd(lin,1)
  m.id=subwrd(lin,2)
  d.id=subwrd(lin,3)
  HH.id=subwrd(lin,4)
  MM.id=subwrd(lin,5)

  rc=read('grads_All_PWV.list')
  ok=sublin(rc,1)
endwhile
say 'nevents= 'id
nevents=id

* open output file
'set gxout fwrite'
'set fwrite -le -st -cl meanprec_grads2.bin'

* time step (in hours)
dt=3

* loop over times (0 to 14h of antecedence)
t=5
while (t>=0)
  say '========= time = 't
* initialize an empty variable
  'tmp't'=lat*0'
  
* loop over events, to accumulate precip
  ev=1
  while(ev<=nevents)

* base time for ev'th event
    xxjd=date2julian(y.ev,m.ev,d.ev)
    xxHH=HH.ev

* time antecedence
    xxHH=xxHH-t*dt
    if (xxHH<0)
      xxHH=xxHH+24
      xxjd=xxjd-1
    endif

* closest time from TRMM time
    hh1=math_nint(xxHH/3)*3
    if (hh1>=24)
      hh1=hh1-24
      xxjd=xxjd+1
    endif
    t1=jd2grads(xxjd,hh1,0)

    say '                     adding event = 'ev'  't1

* acumulate variable in memory
    'tmp't'=tmp't'+prec(time='t1')'
*return
    ev=ev+1
  endwhile

  'tmp't'=tmp't'/'nevents
  'd tmp't

  t=t-1
endwhile

'disable fwrite'
'set gxout contour'

******
function date2julian(y,m,d) 
* http://www.hermetic.ch/cal_stud/jdn.htm#comp
if (m<=2)
  tmp=-1
else 
  tmp=0
endif
jd = math_int( ( 1461 * ( y + 4800 + tmp ) ) / 4 )
jd = jd + math_int( ( 367 * ( m - 2 - 12 * tmp ) ) / 12 )
jd = jd - math_int( ( 3 * ( ( y + 4900 + tmp ) / 100 ) ) / 4 )
jd = jd + d - 32075
return(jd)

******
function julian2date(jd)
* http://www.hermetic.ch/cal_stud/jdn.htm#comp
l = jd + 68569
n = math_int( ( 4 * l ) / 146097 )
l = l - math_int( ( 146097 * n + 3 ) / 4 )
i = math_int( ( 4000 * ( l + 1 ) ) / 1461001 )
l = l - math_int(( 1461 * i ) / 4) + 31
j = math_int(( 80 * l ) / 2447)
d = l - math_int(( 2447 * j ) / 80)
l = math_int(j / 11)
m = j + 2 - ( 12 * l )
y = 100 * ( n - 49 ) + i + l
return(y' 'm' 'd)

******
function daysinmonth(y,m)
if (m=1)  ; day=31; endif
if (m=2)
  day=28
  x=math_mod(y,4)
  if (x=0)
    day=29
  endif
endif
if (m=3)  ; day=31; endif
if (m=4)  ; day=30; endif
if (m=5)  ; day=31; endif
if (m=6)  ; day=30; endif
if (m=7)  ; day=31; endif
if (m=8)  ; day=31; endif
if (m=9)  ; day=30; endif
if (m=10) ; day=31; endif
if (m=11) ; day=30; endif
if (m=12) ; day=31; endif
return(day)

******
function jd2grads(jd,HH,MM)
rc=julian2date(jd)
y=subwrd(rc,1); m=subwrd(rc,2); d=subwrd(rc,3)
return(HH':'MM'z'd''getMon(m)''y)

******
function time2grads(y,m,d,HH,MM)
return(HH':'MM'z'd''getMon(m)''y)

*****
function getMon(m)
if (m=1)  ; mes='JAN'; endif
if (m=2)  ; mes='FEB'; endif
if (m=3)  ; mes='MAR'; endif
if (m=4)  ; mes='APR'; endif
if (m=5)  ; mes='MAY'; endif
if (m=6)  ; mes='JUN'; endif
if (m=7)  ; mes='JUL'; endif
if (m=8)  ; mes='AUG'; endif
if (m=9)  ; mes='SEP'; endif
if (m=10) ; mes='OCT'; endif
if (m=11) ; mes='NOV'; endif
if (m=12) ; mes='DEC'; endif
return(mes)

*fim