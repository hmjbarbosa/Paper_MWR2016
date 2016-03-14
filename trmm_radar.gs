'reinit'
rc=gsfallow('on')
'set display color white'
'clear'

* open radar data
'open /LFANAS/hbarbosa/S-BAND-SIPAM/sbmn/level_2/rain_cappi3km_nc.ctl'

opt=0
if (opt=1)
  'x=ave(rain,t=1000,t=4000)'
  'radmask=const(maskout(lon*0+1,x),0,-u)'
  'set gxout fwrite'
  'set fwrite -le -st -cl radmask.bin'
  'd radmask'
  'disable fwrite'
  'set gxout contour'
else
  'open radmask.ctl'
endif

* open trmm data
*'open /LFANAS/hbarbosa/trmmopen.gsfc.nasa.gov/pub/merged/mergeIRMicro/mergeIRMicro.ctl'
'open /LFANAS/hbarbosa/disc2.nascom.nasa.gov/data/TRMM/Gridded/3B42_V7/3B42.ctl'

* ========================
panels('2 2')

tim='0Z22JAN2014  0Z30JAN2014'
clev='0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1 1.2'

_vpg.1
'set dfile 1'
'set t 1'
'xx=ave(rain,time='subwrd(tim,1)',time='subwrd(tim,2)')'
'set grads off'; 'set grid on'
'set gxout grfill'
'set clevs 'clev
'set lon -61.625 -58.125'
'set lat -4.875 -1.625'
'd xx'; 'draw title S-BAND 1km'
'cbarn'

_vpg.2
'set grads off'; 'set grid on'
'set gxout grfill'
'set clevs 'clev
'set lon -61.625 -58.125'
'set lat -4.875 -1.625'
'd re(xx,15,linear,-61.625,0.25,14,linear,-4.875,0.25)'
'draw title S-BAND @ trmm grid'
'cbarn'

_vpg.3
'set time 'tim
'set x 1'
'set y 1'
'x=aave(rain,lon=-62,lon=-58,lat=-5,lat=-1)'
'set grads off'; 'set grid on'
'set vrange 0 2'
'set ccolor 4'
'd x'; 'draw ylab Prec mm/h'

_vpg.4
'set dfile 3'
'set t 1'
*'set lon -61.5269 -58.4739'
*'set lat -4.68442 -1.63138'
'set lon -61.625 -58.125'
'set lat -4.875 -1.625'
'xx=ave(prec.3(z=1),time='subwrd(tim,1)',time='subwrd(tim,2)')'
'set grads off'; 'set grid on'
'set gxout grfill'
'set clevs 'clev
'd xx'; 'draw title TRMM 0.25deg'
'cbarn'

_vpg.3
'set time 'tim
'set x 1'
'set y 1'
'y=aave(prec.3(z=1),lon=-62,lon=-58,lat=-5,lat=-1)'
'set grads off'; 'set grid on'
'set vrange 0 2'
'set ccolor 2'
'd y'

*fim