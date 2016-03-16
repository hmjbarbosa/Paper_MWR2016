clear all
close all


%load('Dry_CTT_season_data_2011.mat');
%pwv=Dry_CTT.pwv; jd=Dry_CTT.jd; nstation=Dry_CTT.nstation; lat=Dry_CTT.lat; lon=Dry_CTT.lon; tag='Dry_CTT';
%load('Dry_to_Wet_CTT_season_data_2011.mat');
%pwv=Dry_to_Wet_CTT.pwv; jd=Dry_to_Wet_CTT.jd; nstation=Dry_to_Wet_CTT.nstation; lat=Dry_to_Wet_CTT.lat; lon=Dry_to_Wet_CTT.lon; tag='Dry_to_Wet_CTT';
%load('Wet_CTT_season_data_2012.mat');
%pwv=Wet_CTT.pwv; jd=Wet_CTT.jd; nstation=Wet_CTT.nstation; lat=Wet_CTT.lat; lon=Wet_CTT.lon; tag='Wet_CTT';

%tmp=datevec(jd);
%n=size(tmp,1);
%for i=n:-1:1
%  if ~(mod(tmp(i,5),15)==0)
%    pwv(i,:)=[];
%    jd(i)=[];
%  end
%end
%dt=15;

load('Dry_PWV_season_data_2011.mat');
pwv=Dry_PWV.pwv; jd=Dry_PWV.jd; nstation=Dry_PWV.nstation; lat=Dry_PWV.lat; lon=Dry_PWV.lon; tag='Dry_PWV';
%load('Dry_to_Wet_PWV_season_data_2011.mat');
%pwv=Dry_to_Wet_PWV.pwv; jd=Dry_to_Wet_PWV.jd; nstation=Dry_to_Wet_PWV.nstation; lat=Dry_to_Wet_PWV.lat; lon=Dry_to_Wet_PWV.lon; tag='Dry_to_Wet_PWV';
%load('Wet_PWV_season_data_2012.mat');
%pwv=Wet_PWV.pwv; jd=Wet_PWV.jd; nstation=Wet_PWV.nstation; lat=Wet_PWV.lat; lon=Wet_PWV.lon; tag='Wet_PWV';

dt=5;

for y=1:6
  if y==1
    tit='mean of all data';
    xx=ones(size(pwv,1),1)*nanmean(pwv,1);
  elseif y==2
    tit='window 8day';
    xx=nanmoving_average(pwv,96*60/dt); % +- 4day
  elseif y==3
    tit='window 4day';
    xx=nanmoving_average(pwv,48*60/dt); % +- 2day 
  elseif y==4
    tit='window 2day';
    xx=nanmoving_average(pwv,24*60/dt); % +- 1day
  elseif y==5
    tit='window 1day';
    xx=nanmoving_average(pwv,12*60/dt);% +- 12h
  elseif y==6
    tit='window 12h';
    xx=nanmoving_average(pwv,6*60/dt);% +- 6h
  end
  pwv=pwv-xx;


  figure(100+y); clf; hold on; 
  yy=pwv+xx;
  plot(jd-datenum(2011,1,1,0,0,0),yy(:,1),'-r');
  plot(jd-datenum(2011,1,1,0,0,0),xx(:,1),'-k','linewidth',2);
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
y=1; plot(reshape(data(y).mydist,numel(data(y).mydist),1), reshape(data(y).mycor,numel(data(y).mydist),1),'or')
y=2; plot(reshape(data(y).mydist,numel(data(y).mydist),1), reshape(data(y).mycor,numel(data(y).mydist),1),'xg')
y=3; plot(reshape(data(y).mydist,numel(data(y).mydist),1), reshape(data(y).mycor,numel(data(y).mydist),1),'+b')
y=4; plot(reshape(data(y).mydist,numel(data(y).mydist),1), reshape(data(y).mycor,numel(data(y).mydist),1),'*k')
y=5; plot(reshape(data(y).mydist,numel(data(y).mydist),1), reshape(data(y).mycor,numel(data(y).mydist),1),'sm')
y=6; plot(reshape(data(y).mydist,numel(data(y).mydist),1), reshape(data(y).mycor,numel(data(y).mydist),1),'dc')
ylim([0 1])
title(strrep(tag,'_',' '));
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

print(['figs/' tag '_gnss_corr_dist.png'],'-dpng')

%end-of-script