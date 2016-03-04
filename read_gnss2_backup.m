clear all
close all

year='2012';
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
tmp=importdata(['all_stations_final_data_set_int_' year '.dat_5min'],' ');
%tmp=importdata('temp',' ');

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
data.(tag).pres=nan(nlin, data.(tag).nstation);
data.(tag).temp=nan(nlin, data.(tag).nstation);
data.(tag).umid=nan(nlin, data.(tag).nstation);
data.(tag).pwv =nan(nlin, data.(tag).nstation);
data.(tag).ztd =nan(nlin, data.(tag).nstation);

% separate data 
for j=1:data.(tag).nstation
  data.(tag).pres(:,j)=tmp(:, 7+(j-1)*5);
  data.(tag).temp(:,j)=tmp(:, 8+(j-1)*5);
  data.(tag).umid(:,j)=tmp(:, 9+(j-1)*5);
  data.(tag).pwv(:,j) =tmp(:,10+(j-1)*5);
  data.(tag).ztd(:,j) =tmp(:,11+(j-1)*5);
end
data.(tag).pres(data.(tag).pres<=0)=nan;
data.(tag).temp(data.(tag).temp<=0)=nan;
data.(tag).umid(data.(tag).umid<=0)=nan;
data.(tag).pwv (data.(tag).pwv <=0)=nan;
data.(tag).ztd (data.(tag).ztd <=0)=nan;

% save data to a matlab file
disp('saving to file...')
save(['all_stations_final_data_set_int_' year '.mat'],'-v7.3','-struct','data');

%end-of-script