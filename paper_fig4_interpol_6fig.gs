'reinit'
rc=gsfallow('on')
'set display color white'
'clear'
'set grads off'
'set datawarn off'
'set mproj latlon'

* =================================================================================
* open the file with the station data created by the Fortran code
'open station2modelgrid.ctl'

* get time limits
'set t 1 last'
'q dims'
lin=sublin(result,5)
time1=subwrd(lin,6)
t2=subwrd(lin,13)

* create ctl for gridded values
xmin=-60.7; xmax=-59.5; nx=30; dx=(xmax-xmin)/nx
ymin=-3.5; ymax=-2.5; ny=25; dy=(ymax-ymin)/ny
arq='station2gridded.ctl'
rc=write(arq,' DSET ^station2gridded.bin')
rc=write(arq,' options little_endian ')
rc=write(arq,' TITLE Station Data')
rc=write(arq,' UNDEF -999.99')
rc=write(arq,' XDEF 'nx' linear 'xmin' 'dx)
rc=write(arq,' YDEF 'ny' linear 'ymin' 'dy)
rc=write(arq,' ZDEF 1 linear 1 1 ')
rc=write(arq,' TDEF  't2'   linear  'time1'  5mn')
rc=write(arq,' VARS  1')
rc=write(arq,' var     0  99   **')
rc=write(arq,' ENDVARS')
rc=close(arq)
* creat an empty file if there is no one
'!touch station2gridded.bin'

* reopen files 
'close 1'
'open station2gridded.ctl'
'open station2modelgrid.ctl'

* now create a binary with undef values because oacres need a non-empty binary
'set gxout fwrite'
'set fwrite -le -st -cl station2gridded.bin'
'd lat*0'
'disable fwrite'
'set gxout contour'

* =================================================================================
* now the grid is set according to the above CTL
* draw a map on the SCREEN just to make sure of what we've done above
'set grid on 1 15'
'set parea 1 10 0.5 8'
'set xlopts 1 1 0.16'
'set ylopts 1 1 0.16'

* display the interpolated field for t=1
* to get from cm to mm we *10
'set gxout shaded'
'd oacres(var.1, var.2,50,20,15,10,5,4)*10'

* grads trick, draw the station values * zero to get a "round"
* marker to indicate the position of the stations.
'set gxout contour'
'set ccolor 4'
'set digsiz 0.10'
'set dignum 1'
* for the moment, forget the trick, draw the values on the map...
'd var.2*10'
'draw title PWV (cm) and Stations` postions '
'cbarn'

* save this figure as a PS file
'printim station2gridded3'i'.ps white x800 y600'

* =================================================================================
* Now finally do the interpolation for all times and save the result to a binary file
'set gxout fwrite'
'set fwrite -le -st -cl station2gridded.bin'
'set undef -999.99'
i=1
while (i<=t2)
  'set t 'i
  'd oacres(var.1(t=1), var.2)'
  i=i+1
endwhile
'disable fwrite'
'set gxout grfill'

* =================================================================================
* for visualization, make the plot on the screen

'colors 6 240  17  45  110  40 237  30 '
'colors 6 255 255   0   49 129  49  36 '
'colors 6  40 240 240  54   60 220  42 '

'set mpdset mres brmap_mres bacias rios'
'set parea off'

'clear'
*panels('2 3')

*dx=11/3
*y0=1.2
*dy=(8.5-y0)/2
*_vpg.1='set vpage 0        'dx' 'y0+dy' '2*dy+y0
*_vpg.2='set vpage 'dx'   '2*dx' 'y0+dy' '2*dy+y0
*_vpg.3='set vpage '2*dx' '3*dx' 'y0+dy' '2*dy+y0
*_vpg.4='set vpage 0        'dx' 'y0'      'dy+y0
*_vpg.5='set vpage 'dx'   '2*dx' 'y0'      'dy+y0
*_vpg.6='set vpage '2*dx' '3*dx' 'y0'      'dy+y0

nx=3
ny=2

x0=0.6
dx=(11-x0)/nx
mx=0.05
y0=1.5
dy=(8.5-y0)/ny
my=0.05

j=1
while(j<=ny)
  i=1
  while (i<=nx)
    n=(ny-j)*nx+i
    _vpg.n='set parea 'x0+(i-1)*dx+mx' 'x0+i*dx-mx' 'y0+(j-1)*dy+my' 'y0+j*dy-my
    i=i+1
  endwhile
  j=j+1
endwhile

i=97
while (i<=t2)

  'set t 'i
  j=i+11
  h=1-(168-i+1)/12
  id=6+h

  _vpg.id
  say 'id='id'  h='h'   '_vpg.id

  'set mpdraw off'
*  'set mpt  31 1 1 6 '
  'set grads off'
  'set grid off'

* color bar levels
  'set gxout shaded'
* display variable (in mm)
  'xx=smth9(ave(oacres(var.1(t=1), var.2, 30, 21, 12, 6, 3),t='i',t='j')*10)'
  'set xlopts 1 1 0.125'; 'set xlint 0.3'
  'set ylopts 1 1 0.125'; 'set ylint 0.3'
  if (id!=1&id!=4)
    'set ylab `3 `0 '
  else
    'set ylab auto'
  endif
  if (id<4)
    'set xlab `3 `0 '
  else
    'set xlab auto'
  endif
  'set clevs  -0.5 0 0.5 1 1.5 2 2.5 3 3.5 4 '
  'set ccols  9  14   4   11  13  10  7 12  8 6   15'
  'd xx'
  'set gxout contour'
  'set clab off'
  'set clevs  -0.5 0 0.5 1 1.5 2 2.5 3 3.5 4 '
  'set ccolor 15'
  'd xx'
  'draw shp hidro_am'

  siz='0.10'
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
  'drawmark 4  -60.09  -3.07 'siz
  'drawmark 3  -60.05  -3.07 'siz
  'drawmark 3  -59.94  -3.01 'siz
  'drawmark 3  -59.64  -2.65 'siz
  'drawmark 3  -60.67  -2.95 'siz
  'drawmark 3  -60.05  -3.00 'siz
  'drawmark 3  -60.21  -2.61 'siz
  'drawmark 3  -59.99  -3.10 'siz
  'drawmark 3  -60.06  -3.02 'siz
* GOAM
  'drawmark 4  -60.59  -3.23 'siz
  
*'draw title h='h
  'textbox tl 1 0 1 "t='h'h"'
* add the color bar
*  'cbarn'

  i=i+12
endwhile

'cbarnv 1 0 5.8 0.9 1'
'set strsiz 0.16'
'draw string 5.8 0.5 PWV Anomaly (mm)'

* save a PNG figure
'printim figs/figure4_densenet_6fig_cresman30_21_12_6_3.png x1600 y1200 white '
'gxprint figs/figure4_densenet_6fig_cresman30_21_12_6_3.eps  '
*
