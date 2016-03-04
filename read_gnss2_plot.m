clear all
close all

load('Dry_CTT_season_data_2011.mat');
load('Dry_PWV_season_data_2011.mat');
load('Dry_to_Wet_CTT_season_data_2011.mat');
load('Dry_to_Wet_PWV_season_data_2011.mat');
load('Wet_CTT_season_data_2012.mat');
load('Wet_PWV_season_data_2012.mat');

% calculate the correlations
%tempo1=[2011,7,1,0,0,0];
%tempo2=[2011,10,1,0,0,0];
tempo1=[2000,1,1,0,0,0];
tempo2=[2999,1,1,0,0,0];

for y=1:6
  if y==1
    pwv=y2011.pwv; jd=y2011.jd;  tit='mean of all data';
    mask=jd>=datenum(tempo1)&jd<=datenum(tempo2); jd=jd(mask);
    pwv=pwv(mask,:); 
    xx=ones(size(pwv,1),1)*nanmean(pwv,1);
    pwv=pwv-xx;
    nstation=y2011.nstation;
    lat=y2011.lat; lon=y2011.lon;
  elseif y==2
    pwv=y2011.pwv; jd=y2011.jd;  tit='window 8day';
    mask=jd>=datenum(tempo1)&jd<=datenum(tempo2); jd=jd(mask);
    pwv=pwv(mask,:);
    xx=nanmoving_average(pwv,4*288);
    pwv=pwv-xx;
    nstation=y2011.nstation;
    lat=y2011.lat; lon=y2011.lon;
  elseif y==3
    pwv=y2011.pwv; jd=y2011.jd;  tit='window 4day';
    mask=jd>=datenum(tempo1)&jd<=datenum(tempo2); jd=jd(mask);
    pwv=pwv(mask,:);
    xx=nanmoving_average(pwv,2*288);
    pwv=pwv-xx;
    nstation=y2011.nstation;
    lat=y2011.lat; lon=y2011.lon;
  elseif y==4
    pwv=y2011.pwv; jd=y2011.jd;  tit='window 2day';
    mask=jd>=datenum(tempo1)&jd<=datenum(tempo2); jd=jd(mask);
    pwv=pwv(mask,:);
    xx=nanmoving_average(pwv,1*288);
    pwv=pwv-xx;
    nstation=y2011.nstation;
    lat=y2011.lat; lon=y2011.lon;
  elseif y==5
    pwv=y2011.pwv; jd=y2011.jd;  tit='window 1day';
    mask=jd>=datenum(tempo1)&jd<=datenum(tempo2); jd=jd(mask);
    pwv=pwv(mask,:);
    xx=nanmoving_average(pwv,144);%+- 12h
    pwv=pwv-xx;
    nstation=y2011.nstation;
    lat=y2011.lat; lon=y2011.lon;
  elseif y==6
    pwv=y2011.pwv; jd=y2011.jd; tit='window 12h';
    mask=jd>=datenum(tempo1)&jd<=datenum(tempo2); jd=jd(mask);
    pwv=pwv(mask,:);
    xx=nanmoving_average(pwv,72);%+- 6h
    pwv=pwv-xx;
    nstation=y2011.nstation;
    lat=y2011.lat; lon=y2011.lon;
  end

  figure(100+y); clf; hold on; 
  yy=pwv+xx;
  plot(jd-datenum(2011,1,1,0,0,0),yy(:,1),'-r');
  plot(jd-datenum(2011,1,1,0,0,0),xx(:,1),'-k');
  plot(jd-datenum(2011,1,1,0,0,0),pwv(:,1),'-b');
  legend('original','mean curve removed','data used for correlation');
  ylabel('PWV station #1')
  xlabel('day of the year 2011')
  title(tit)
  prettify(gca); grid on
  print(['2011full_gnss_corr_pwv_filtered_window' num2str(y) '.png'],'-dpng')
  
  data(y).mycor=nan(nstation, nstation);
  data(y).mydist=data(y).mycor;

  for i=1:nstation
    for j=1:i-1
      X=pwv(:,i);
      Y=pwv(:,j);
      mask=isnan(X)|isnan(Y);
      
      X(mask)=[];
      Y(mask)=[];
      
      if ~isempty(X) & sum(~mask)>1000
	data(y).mycor(i,j)=corr(X,Y);
	data(y).mycor(j,i)=data(y).mycor(i,j);
	if data(y).mycor(i,j)<0
	  disp({'y, i, j, corr, npts=', y, i, j, data(y).mycor(i,j), sum(~mask)})
	end
      end
      
      data(y).mydist(i,j)=distance(lat(i),lon(i),lat(j),lon(j))*pi()*6371./180.; 
      data(y).mydist(j,i)=data(y).mydist(i,j);
    end
  end
  
end

% make the plot

figure(5); clf; hold on
y=3; plot(reshape(data(y).mydist,numel(data(y).mydist),1), reshape(data(y).mycor,numel(data(y).mydist),1),'or')
y=4; plot(reshape(data(y).mydist,numel(data(y).mydist),1), reshape(data(y).mycor,numel(data(y).mydist),1),'xg')
y=5; plot(reshape(data(y).mydist,numel(data(y).mydist),1), reshape(data(y).mycor,numel(data(y).mydist),1),'+b')
y=6; plot(reshape(data(y).mydist,numel(data(y).mydist),1), reshape(data(y).mycor,numel(data(y).mydist),1),'*k')
y=7; plot(reshape(data(y).mydist,numel(data(y).mydist),1), reshape(data(y).mycor,numel(data(y).mydist),1),'sm')
y=8; plot(reshape(data(y).mydist,numel(data(y).mydist),1), reshape(data(y).mycor,numel(data(y).mydist),1),'dc')
%title('2011 Jul-1st Sep-31st');
title('2011 full year');
legend('PWV - full ave',...
       'PWV - ave(8 days)',...
       'PWV - ave(4 days)',...
       'PWV - ave(2 days)',...
       'PWV - ave(1 days)',...
       'PWV - ave(12 h)', 'Location','southwest');


%legend('2011 Apr 25th - Dec 31st','2011 Jul 1st - Sep 31st',...
%       '2012 Jan 1st - Apr 20th','Location','southwest')
xlabel('distance between stations (km)')
ylabel('pearson correlation coefficient')
prettify(gca); grid on; 

print('2011full_gnss_corr_dist.png','-dpng')

%end-of-script