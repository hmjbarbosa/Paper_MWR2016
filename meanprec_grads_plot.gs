'reinit'
rc=gsfallow('on')
'set display color white'
'clear'

'open meanprec_grads.ctl'
*'set t 1 last'
*'tmp=re2(prec,0.05,0.05)'

'set lat -4 -2'
'set lon -62 -58'

t=1
while(t<=15)
  'clear'
  'set mpdraw off'
  'set grads off'
  'set grid off'
  'set gxout shaded'

  'set clevs 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8 2 2.2'
  'd prec(t='t')/100'
*  'draw shp hidro_am'
  
  'cbarn'
  'draw title t='t-15' h'

  siz='0.15'
  'drawmark 3  -59.97  -3.06 'siz
  'drawmark 3  -60.00  -3.03 'siz
  'drawmark 3  -60.01  -3.12 'siz
  'drawmark 3  -60.06  -3.11 'siz
  'drawmark 3  -59.92  -3.20 'siz
  'drawmark 3  -59.97  -2.89 'siz
  'drawmark 3  -60.23  -3.26 'siz
  'drawmark 3  -59.88  -3.09 'siz
  'drawmark 3  -60.24  -3.11 'siz
  'drawmark 3  -59.93  -3.04 'siz
  'drawmark 3  -60.63  -3.30 'siz
  'drawmark 3  -60.46  -3.43 'siz
  'drawmark 1  -60.09  -3.07 'siz
  'drawmark 3  -60.05  -3.07 'siz
  'drawmark 3  -59.94  -3.01 'siz
  'drawmark 3  -59.64  -2.65 'siz
  'drawmark 3  -60.67  -2.95 'siz
  'drawmark 3  -60.05  -3.00 'siz
  'drawmark 3  -60.21  -2.61 'siz
  'drawmark 3  -59.99  -3.10 'siz
  'drawmark 3  -60.06  -3.02 'siz

  'printim trmm_prec_t't'.png'

  'q pos'
  t=t+1
endwhile

*fim