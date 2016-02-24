clear all
close all

year='2011';
tag=['y' year];

% list of stations
tmp=read_mixed_csv(['station_file_list_T02_' year],' ');

data.(tag).nstation=size(tmp,1);
data.(tag).name=tmp(:,1);
data.(tag).lat=str2double(tmp(:,2));
data.(tag).lon=str2double(tmp(:,3));
clear tmp

% read data
disp('reading data...')
tmp=importdata(['9hr_interval_output_' year '.dat'],' ');
%tmp=importdata('test.dat',' ');

yy=tmp(:,1);
mm=tmp(:,3);
dd=tmp(:,4);
h =tmp(:,5);
m =tmp(:,6);
s=m*0;

data.(tag).jd=datenum(yy,mm,dd,h,m,s);
clear yy mm dd h m s

% maximum number of times
[nlin ncol]=size(tmp);

disp('separating variables...')
data.(tag).pwv =nan(nlin, data.(tag).nstation);

% separate data 
for j=1:data.(tag).nstation
  data.(tag).pwv(:,j) =tmp(:,6+j);
end
data.(tag).pwv (data.(tag).pwv <=-900)=nan;

% save data to a matlab file
disp('saving to file...')

tmp(tmp<=-900)=nan;
data.(tag).tmp=tmp;

save(['9hr_interval_output_' year '.mat'],'-v7.3','-struct','data');

%end-of-script