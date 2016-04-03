! PROGRAM: CreateStation2ModelGrid
!
! AUTHOR: Luiz Rodrigo Tozzi - luizrodrigotozzi@gmail.com
!
! DESCRIPTION: This fortran code converts a free-styled table with
! "station" values to a formatted table. This is the first step to
! create a GrADS station binary file.
!
! INPUT FILE LOOKS LIKE (separeted by any number of spaces):
!
! (...)
! yearwith4digits    monthwith2digits    daywith2digits    hourwith2digits  minuteswith2digits  stationname    latitude       longitude            value
! (...)
!
! hbarbosa 
! more comments, length of variable to nl,
! clean bad fortran use, 
! updated code to remove crutial bugs
program CreateStation2ModelGrid
  implicit none

  integer, parameter :: max_nlin=9999 ! max number of data points
  
  real,    dimension(max_nlin) :: lat,lon,var,N ! latitude, longitude and data value
  integer, dimension(max_nlin) :: d2, m2, y4  ! day, month and year
  integer, dimension(max_nlin) :: mm2, h2     ! minute and hour
  integer, dimension(max_nlin) :: time     ! full time (in minutes) since year 0
  character(LEN=4), dimension(max_nlin) :: sid ! station name

  integer :: i,k, nlin, ios, nsta,reclen
  character(len=3), parameter, dimension(12) :: m2name = &
       (/'jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec'/)

  character*256 fname

  ! Arguments
  if (iargc().ne.1) then
     write(*,*) 'Exactly one parameters required!'
     write(*,*) 'USAGE: '
     write(*,*) '   ./R013-convert <file name> '
     stop
  endif

  ! get file name from command line
  call getarg(1, fname)

  write(*,*) 'Reading file = ',trim(fname) 
  write(*,*) 'Input file is expected to have all station data for a given time, followed by'
  write(*,*) 'all station data for the next time, and so on. The sequence of stations should'
  write(*,*) 'always be the same, for each time period!!'

  open(unit=100, file=trim(fname), form='formatted', status='old', &
       iostat=ios)
  if (ios.ne.0) then
     write(*,*) 'ERROR: trying to open file= ',trim(fname)
     stop
  endif

  ! get number of stations
  !call getarg(2,sid(1))
  !read(sid(1),'(i4)') nsta
  nsta = 0

  ! read all lines
  i = 0
  do
     i=i+1

     read(100,*,iostat=ios) y4(i),m2(i),d2(i),h2(i),mm2(i),&
          sid(i),lat(i),lon(i),var(i),N(i)

     if ( (y4(i).eq.y4(1)) .and. (m2(i).eq.m2(1)) .and. (d2(i).eq.d2(1)) .and. &
          (h2(i).eq.h2(1)) .and. (mm2(i).eq.mm2(1)) ) then
        nsta = nsta + 1
     endif

     if(ios.ne.0 .or. (lat(i).eq.0.and.lon(i).eq.0)) exit
     time(i)=(((y4(i)*100+m2(i))*100+d2(i))*24+h2(i))*60+mm2(i)

  end do
  nlin=i-1
  write(*,*) 'Number of lines read= ',nlin
  write(*,*) 'Number of stations identified= ',nsta
     
  ! close the file
  close(unit=100)

!----------------------------------------------------------------------------------
! CONVERTED DATA FOR C-PROGRAM
!
  ! Transforms the station name (sid) in an index number (i)
  open(unit=200,file='station2modelgrid.txt', status='unknown',iostat=ios, &
       form='formatted')
  if (ios.ne.0) then
     write(*,*) 'ERROR: trying to open file= station2modelgrid.txt'
     stop
  endif
  do k=1,nlin
     write(200,14) y4(k),m2(k),d2(k), h2(k),mm2(k), mod(k-1,nsta)+1, lat(k),lon(k),var(k),N(k)
  enddo
  close(200)
14 format(i4,2x,i2,2x,i2,2x, i2,2x,i2,2x, i5,9x, f10.3,2x,f10.3,2x,f10.3,2x,f10.3)


!----------------------------------------------------------------------------------
! TEMP DATA FOR GRADS
!
  inquire(iolength=reclen) var(1)
  open(unit=200,file='temp.bin', status='unknown',iostat=ios,  &
       convert='little_endian',access='direct', recl=reclen, form='unformatted')
  if (ios.ne.0) then
     write(*,*) 'ERROR: trying to open file= temp.bin'
     stop
  endif
  do k=1,nlin
     write(200,rec=2*k-1) var(k)
     write(200,rec=2*k) N(k)
  enddo
  close(200)

! TEMP  CTL
!
  open(unit=300,file='temp.ctl')
  write(300,*) "DSET ^temp.bin"
  write(300,*) "options little_endian "
  write(300,*) "TITLE Station Data"
  write(300,*) "UNDEF -999.99"
  write(300,*) "XDEF 1 linear 1 1 "
  write(300,*) "YDEF 1 linear 1 1 "
  write(300,*) "ZDEF 1 linear 1 1 "
  write(300,'(a,2x,i5,2x,a,i2,a1,i2,a3,i4,a5)') "TDEF   ",int(nlin/nsta), &
       " linear ",h2(1),"z",d2(1),m2name(m2(1)),y4(1)," 5mn"
  write(300,*) "VARS ",nsta*2
  do i=1,nsta
     write(300,123) i 
     write(300,124) i 
  enddo
123 format('var',i0.2,'     0  99   **')
124 format('N',i0.2,'     0  99   **')
  write(300,*) "ENDVARS"
  close(300)

  stop
end program CreateStation2ModelGrid
!
