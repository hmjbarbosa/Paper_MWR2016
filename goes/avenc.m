close all
clear all

% this script reads the netcdf files and creates png images of the data

% get a list of the files in the current directory with the .nc extension
mylist=dirpath('./','*.nc');
nfiles=length(mylist);

% read lat/lon from first file
lat=ncread(mylist{1},'lat');
nlat=length(lat);

lon=ncread(mylist{1},'lon');
nlon=length(lon);

% initialize data array to hold all the data
data=nan(nlon,nlat,nfiles);

% loop through the files and read the data
for i=1:nfiles
  data(:,:,i)=ncread(mylist{i},'new_temp');
  
  % some files have the wrong scaling factor, so we manually divide by 100
  if any([max(max(data(:,:,i))) min(min(data(:,:,i)))]>1000)
    data(:,:,i)=data(:,:,i)/100.;
  end
  
  % create and save a png image of the data in each file
  imsc(lon,lat,data(:,:,i),[190 300],colormap(jet))
  title(mylist{i},'interpreter','none')
  colorbar
  print([mylist{i} '.png'],'-dpng')
end


% end of script