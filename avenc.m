close all
clear all

mylist=dirpath('./','*.nc');
nfiles=length(mylist);

lat=ncread(mylist{1},'lat');
nlat=length(lat);

lon=ncread(mylist{1},'lon');
nlon=length(lon);

data=nan(nlon,nlat,nfiles);

for i=1:nfiles
  data(:,:,i)=ncread(mylist{i},'new_temp');
  
  if any([max(max(data(:,:,i))) min(min(data(:,:,i)))]>1000)
    data(:,:,i)=data(:,:,i)/100.;
  end
  
  imsc(lon,lat,data(:,:,i),[190 300],colormap(jet))
  title(mylist{i},'interpreter','none')
  colorbar
  print([mylist{i} '.png'],'-dpng')
end


% fim