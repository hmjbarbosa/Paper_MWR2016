clear all
close all

% list of stations
tmp=read_mixed_csv(['station_file_list_T02_2011_2012'],' ');

nstation=size(tmp,1);
name=tmp(:,1);
lat=str2double(tmp(:,2));
lon=str2double(tmp(:,3));
clear tmp

for idx=1:1
  
  switch idx
   case 1,
    tag=['All_PWV']; nevents=67; var='PWV';
   case 2,
    tag=['Daytime_PWV']; nevents=55; var='PWV';
   case 3,
    tag=['Nightime_PWV']; nevents=12; var='PWV';
   case 4,
    tag=['Dry_Season_PWV']; nevents=27; var='PWV';
   case 5,
    tag=['Wet_Season_PWV']; nevents=24; var='PWV';
  end

  ID='_14hr_interval_2011_2012';

  % read data
  disp('reading data...')
  clear tmp
  tmp=importdata([tag ID '.dat'],' ',3);
  tmp=tmp.data;

  ntimes=size(tmp,1)/nevents;
  if (mod(ntimes,1)>0.01)
    error('gnss','ntimes is not integer!')
  end

  tmp=tmp(end-nevents+1:end,1:6);
  tmp(:,2)=[];
  tmp(:,end+1)=(1:nevents);
  
  dlmwrite(['grads_' tag '.list'],tmp,' ');
  
end

%fim