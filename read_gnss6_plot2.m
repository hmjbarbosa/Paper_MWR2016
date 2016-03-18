clear all
close all

load('Dry_CTT_season_data_2011.mat');
load('Dry_to_Wet_CTT_season_data_2011.mat');
load('Wet_CTT_season_data_2012.mat');

for y=1:3
  y
  if y==1
    pwv=Dry_CTT.pwv; jd=Dry_CTT.jd; nstation=Dry_CTT.nstation; lat=Dry_CTT.lat; lon=Dry_CTT.lon; tag='Dry_CTT';
    tit='Dry season';
  elseif y==2
    pwv=Dry_to_Wet_CTT.pwv; jd=Dry_to_Wet_CTT.jd; nstation=Dry_to_Wet_CTT.nstation; lat=Dry_to_Wet_CTT.lat; lon=Dry_to_Wet_CTT.lon; tag='Dry_to_Wet_CTT';
    tit='Dry to Wet season';
  elseif y==3
    pwv=Wet_CTT.pwv; jd=Wet_CTT.jd; nstation=Wet_CTT.nstation; lat=Wet_CTT.lat; lon=Wet_CTT.lon; tag='Wet_CTT';
    tit='Wet season';
  end
  tag='seasons';
  
  %tmp=datevec(jd);
  %n=size(tmp,1);
  %for i=n:-1:1
  %  if ~(mod(tmp(i,5),15)==0)
  %    pwv(i,:)=[];
  %    jd(i)=[];
  %  end
  %end

  data(y).mycor=nan(nstation, nstation);
  data(y).mydist=data(y).mycor;

  for i=1:nstation
    for j=1:i
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
%y=1; plot(reshape(data(y).mydist,numel(data(y).mydist),1), reshape(data(y).mycor,numel(data(y).mydist),1),'og')
y=2; plot(reshape(data(y).mydist,numel(data(y).mydist),1), reshape(data(y).mycor,numel(data(y).mydist),1),'xr')
y=3; plot(reshape(data(y).mydist,numel(data(y).mydist),1), reshape(data(y).mycor,numel(data(y).mydist),1),'+b')
ylim([0.4 1])
title('CTT');
%legend('Dry season','Wet season', 'Location','northeast');
legend('Dry to Wet season','Wet season', 'Location','northeast');

mymodel=@(b,x) (1+b(1)*x);
y=1;
X=reshape(data(y).mydist,numel(data(y).mydist),1);
Y=reshape(data(y).mycor,numel(data(y).mydist),1);
[BETA1,R1,J1,COVB1,MSE1,EMI1] = ...
    nlinfitwxy(X,Y,zeros(size(X)),ones(size(Y))*1,mymodel,[1]);
plot([1:140],mymodel(BETA1,[1:140]),'r-','linewidth',2);

y=3;
X=reshape(data(y).mydist,numel(data(y).mydist),1);
Y=reshape(data(y).mycor,numel(data(y).mydist),1);
[BETA2,R2,J2,COVB2,MSE2,EMI2] = ...
    nlinfitwxy(X,Y,zeros(size(X)),ones(size(Y))*1,mymodel,[1]);
plot([1:140],mymodel(BETA2,[1:140]),'b-','linewidth',2);

myfit={'f(x) = 1 + A * x'; ...
       sprintf('Dry,  A = %9.2e [%9.2e ; %9.2e] km^{-1}', BETA1(1), EMI1.BETACONF(1,1), EMI1.BETACONF(2,1)); ...
       sprintf('Wet,  B = %9.2e [%9.2e ; %9.2e] km^{-1}', BETA2(1), EMI2.BETACONF(1,1), EMI2.BETACONF(2,1))};

annotation('textbox',[0.15 0.13 0.50 0.15],'string',' ', ...
	   'backgroundcolor',[1 1 1],'edgecolor',[0 0 0],'fontsize',12,...
	   'fitboxtotext','off');

annotation('textbox',[0.15 0.13 0.53 0.15],'string',myfit, ...
	   'backgroundcolor','none','edgecolor','none','fontsize',12,...
	   'fitboxtotext','on');

xlabel('distance between stations (km)')
ylabel('pearson correlation coefficient')
prettify(gca); grid on; 

print(['figs/CTT_seasons_gnss_corr_dist.png'],'-dpng')

%end-of-script