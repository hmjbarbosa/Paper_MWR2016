%
clear all
%close all

% list of stations
tmp=read_mixed_csv(['station_file_list_T02_2011_2012'],' ');

nstation=size(tmp,1);
name=tmp(:,1);
lat=str2double(tmp(:,2));
lon=str2double(tmp(:,3));
clear tmp

for i=1:nstation
  for j=1:nstation
    mydist(i,j)=distance(lat(i),lon(i),lat(j),lon(j))*pi()*6371./180.; 
  end
end
%%%%

%nstation=21; 
ntimes=168; % 5min x 168 = 14h
nevents=67;

% define mean and standard deviation
% for the moment, they are all the same
for st=1:nstation
  stave(st)=5.4;
  ststd(st)=0.45;
end

% slope x time
% slope(t) = A + B * exp(t/C)
A=-1e-3; % 1/km
B=-4e-3; % 1/km
C=3;     % h
tempo=(0:ntimes-1)*5/60.; % h
slope=A+B*exp(tempo/C);

% correlation x distance
% corr(d,t)=1+slope(t)*d
for t=1:ntimes
  for i=1:nstation
    for j=1:nstation
      mycor(i,j,t)=1+slope(t)*mydist(i,j);
    end
  end
end

% correlation
cor12=0.3;

% covariance matrix
cov12=[std1^2, cor12*std1*std2; cor12*std1*std2, std2^2];

for i=1:100
  r=mvnrnd([mean1,mean2],cov12,100);
  mycor(i)=corr(r(:,1),r(:,2));
end

figure(1)
plot(r)

figure(2)
plot(r(:,1),r(:,2),'*')

figure(3)
plot(mycor)
mean(mycor)
std(mycor)

%