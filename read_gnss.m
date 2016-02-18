clear all
close all

% list of stations
nstation=21;
name{ 1}='CDN2'; lat( 1)=-3.06; lon( 1)=-59.97;
name{ 2}='CDN4'; lat( 2)=-3.03; lon( 2)=-60.00;
name{ 3}='CHR5'; lat( 3)=-3.12; lon( 3)=-60.01;
name{ 4}='CMP1'; lat( 4)=-3.11; lon( 4)=-60.06;
name{ 5}='CTLO'; lat( 5)=-3.20; lon( 5)=-59.92;
name{ 6}='EMBP'; lat( 6)=-2.89; lon( 6)=-59.97;
name{ 7}='EMIR'; lat( 7)=-3.26; lon( 7)=-60.23;
name{ 8}='HORT'; lat( 8)=-3.09; lon( 8)=-59.88;
name{ 9}='IRAN'; lat( 9)=-3.11; lon( 9)=-60.24;
name{10}='JPL6'; lat(10)=-3.04; lon(10)=-59.93;
name{11}='MNCP'; lat(11)=-3.30; lon(11)=-60.63;
name{12}='MNQI'; lat(12)=-3.43; lon(12)=-60.46;
name{13}='PDAQ'; lat(13)=-3.07; lon(13)=-60.09;
name{14}='PNT8'; lat(14)=-3.07; lon(14)=-60.05;
name{15}='RDCK'; lat(15)=-3.01; lon(15)=-59.94;
name{16}='RPDE'; lat(16)=-2.65; lon(16)=-59.64;
name{17}='TMB7'; lat(17)=-2.95; lon(17)=-60.67;
name{18}='TRM3'; lat(18)=-3.00; lon(18)=-60.05;
name{19}='ZF29'; lat(19)=-2.61; lon(19)=-60.21;
name{20}='INPA'; lat(20)=-3.10; lon(20)=-59.99;
name{21}='NAUS'; lat(21)=-3.02; lon(21)=-60.06;

% read data
tmp=read_mixed_csv('stationdata_clean.txt',' ');

[nlin ncol]=size(tmp);

pwv=str2double(tmp(:,9));
pwv(pwv<0)=nan;

yy=str2double(tmp(:,1));
mm=str2double(tmp(:,2));
dd=str2double(tmp(:,3));
h=str2double(tmp(:,4));
m=str2double(tmp(:,5));
s=m*0;

jd=datenum(yy,mm,dd,h,m,s);
clear yy mm dd h m s

% find min and max JD
jdmin=min(jd);
jdmax=max(jd);
% time-step of data in file
% 5min in units of days
dt=5./1440.;
% index of time-step on our vectors
idx=floor((jd-jdmin)/dt+1+0.5);
% maximum number of times
idxmax=max(idx);

data=nan(idxmax, nstation);

% separate data per station
for j=1:nstation
  mask=strcmp(tmp(:,6), name{j});
  
  % maybe the data is not in order
  astation=sortrows([jd(mask) idx(mask) pwv(mask)], 1);

  % maybe not all times were given for this station
  station(j).data=nan(idxmax,3);
  for i=1:size(astation,1)
    station(j).data(astation(i,2),:)=astation(i,:);
    
    data(astation(i,2), j)=astation(i,3);
  end

end

% calculate the correlations

mycor=nan(nstation, nstation);
mydist=mycor;

for i=1:nstation
  for j=1:i-1
    X=data(:,i);
    Y=data(:,j);
    mask=isnan(X)|isnan(Y);
    X(mask)=[];
    Y(mask)=[];
    
    if ~isempty(X)
      mycor(i,j)=corr(X,Y);
    end
    
    mydist(i,j)=distance(lat(i),lon(i),lat(j),lon(j))*pi()*6371./180.;
    
  end
end

% make the plot

figure(1); clf;
plot(mydist,mycor,'*b')
xlabel('distance between stations (km)')
ylabel('pearson correlation coefficient')
prettify(gca)
grid on

print('gnss_corr_dist.png','-dpng')

%end-of-script