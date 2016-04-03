'reinit'
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
ymin=-3.5; ymax=-2.5; ny=30; dy=(ymax-ymin)/ny
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


i=1
while (i<=t2)
  'set t 'i
  'clear'
  'set mpdraw off'
*  'set mpt  31 1 1 6 '
  'set grads off'
  'set grid off'
* find the min/max values
*  'set gxout stat'
*
*  'd oacres(var.1(t=1), var.2)*10'
*  lin=sublin(result,8)
*  vmin=subwrd(lin,4); 
*  vmax=subwrd(lin,5); 
** build N levels from vmin to vmax
*  j=1; N=10; mylevs=''
*  while(j<=N)
*    v=vmin+(j-1)*(vmax-vmin)/(N-1)
** round to the 1st decimal place
*    v=math_nint(v*10)/10
** add the new value to our list
*    mylevs=mylevs' 'v
*    j=j+1
*  endwhile
* print the list of levels to the screen
*  say mylevs

* color bar levels
  'set gxout shaded'
*  'set gxout grfill'
*  'set clevs 50 50.5 51 51.5 52 52.5 53 53.5 54 54.5 55 55.5 56 56.5 57 57.5 58'
*  'set ccols 30 31   32 33   34 35   36 37   38 39   40 41   42 43   44 45   46 47' 
*  'set clevs 51 52  53 53.5 54 54.5 55 55.5 56 56.5 57 57.5'
*  'set clevs 'mylevs
* display variable (in mm)
  j=i+11
*  'colormaps -l 51 59 0.5 -map jet'
*  'colormaps -l -3 5 0.5 -map jet'
  'xx=smth9(ave(oacres(var.1(t=1), var.2, 30, 21, 12, 6, 3),t='i',t='j')*10)'
  'set xlint 0.2'
  'set ylint 0.2'
  'set clevs  -2 -1.5 -1 -0.5 0 0.5 1 1.5 2 2.5 3 3.5 4 '
  'set ccols  9  14   4   11  5 13  3 10  7 12  8 2   6  15'
  'd xx'
  'set gxout contour'
  'set clab off'
*  'set clevs 51 51.5 52 52.5 53 53.5 54 54.5 55 55.5 56 56.5 57 57.5 58 58.5 59'
  'set clevs  -2 -1.5 -1 -0.5 0 0.5 1 1.5 2 2.5 3 3.5 4 '
  'set ccolor 15'
  'd xx'
  'draw shp hidro_am'

* display the values at the stations (in mm)
  'set gxout contour'
  'set digsiz 0.10'
  'set clab masked'
  'set ccolor 1'
  'set dignum 0'
*  'd var.2*0'

* string to use in the title and as file name
  id=math_format('%05.0f',i)

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
*'drawmark 1  -60.09  -3.07 'siz
'drawmark 3  -60.05  -3.07 'siz
'drawmark 3  -59.94  -3.01 'siz
'drawmark 3  -59.64  -2.65 'siz
'drawmark 3  -60.67  -2.95 'siz
'drawmark 3  -60.05  -3.00 'siz
'drawmark 3  -60.21  -2.61 'siz
'drawmark 3  -59.99  -3.10 'siz
'drawmark 3  -60.06  -3.02 'siz

  'q time'
  tt=subwrd(result,3)
* add title to the plot
*  'draw title t=' id' time=' tt
  h=1-(168-i+1)/12
*'draw title h='h
  'textbox tl 1 0 1 "t='h'h"'
* add the color bar
  'cbarn'

* save a PNG figure
  'printim figs/densenet_'h'.png x800 y600 white '
* if you want to pause the images inside grads, uncomment the line below
* in this case you will have to click inside the figure with your mouse to see the next one
* if you get bored, hit ctrl-C in grads to kill the loop.
*return
  'q pos'

  i=i+12
endwhile

*
