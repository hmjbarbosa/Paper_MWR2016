clear all
close all

%=======================================================================================

% list of stations
tmp=read_mixed_csv(['station_file_list_T02_2011_2012'],' ');

nstation=size(tmp,1);
name=tmp(:,1);
lat=str2double(tmp(:,2));
lon=str2double(tmp(:,3));
clear tmp

%=======================================================================================

% the last lines in the files are the T0 of each event (which vary)
% for the diurnal cycle files, however, this is always 8pm.
T0=0; % hours
filedt=5; % min

tag=['All_PWV']; nevents=67; var='PWV';T0=0; ctt15clean=0; ymin=0;maxdist=150;
ID='_14hr_interval_2011_2012';

%=======================================================================================
% read data
disp('reading data...')
tmp=importdata([tag ID '.dat'],' ',3);
tmp=tmp.data;
tmp(tmp<-900)=nan;

% CTT only have data at 0, 15, 30 and 45min
if ctt15clean>0
  filedt=15;
  for i=size(tmp,1):-1:1
    if ~(mod(tmp(i,6),15)==0)
      tmp(i,:)=[];
    end
  end
end

ntimes=size(tmp,1)/nevents;
if (mod(ntimes,1)>0.01)
  error('ntimes is not integer!')
else
  disp(['ntimes= ' num2str(ntimes)])
  disp(['nevents= ' num2str(nevents)])
  disp(['nstation= ' num2str(nstation)])
end

% reshape the data and separate the events
for t=1:ntimes
  for ev=1:nevents
    data(t,ev,:)=tmp((t-1)*nevents+ev, :);
  end
end

% keep only the last 8 hours
%ntimes=8*60/filedt;
%data=data(end-ntimes+1:end,:,:);

% verify if events are in sequential order
jd=data(:,:,1)+data(:,:,2)/365.25;
% bug 8-may-2026 this was always false! correct code checks if any value is negative
%if any(diff(reshape(jd,ntimes*nevents,1)))<0
if any(diff(reshape(jd,ntimes*nevents,1))<0)
  disp('something wrong... date goes back in time!')
  return
end

% remove the average event
%for st=1:nstation
%  for ev=1:nevents
%    data(:,ev,6+st)=data(:,ev,6+st)-nanmean(data(:,ev,6+st));
%  end
%end

% now add an extra column with the Julian date (col=2 from David is
% not good!) - BUG found on 15/mar/2016 about 18:50 sao paulo time

for ev=1:nevents
  for t=1:ntimes
    data(t,ev, 28)=datenum(data(t,ev,1),data(t,ev,3),data(t,ev,4),...
			   data(t,ev,5),data(t,ev,6),0          );
  end
end

% now add an extra column with the number of steps before T=0

step=1; % in hours

for ev=1:nevents
  for t=1:ntimes
    % column 29 with steps (fractional) before T=0
    data(t,ev, 29)=(data(t,ev,28)-data(ntimes,ev,28))*24/step;
  end
end

mintime=ceil(min(reshape(data(:,:,29), numel(data(:,:,29)), 1)));
maxtime=ceil(max(reshape(data(:,:,29), numel(data(:,:,29)), 1)));

%=======================================================================================
% distance
mydist=nan(nstation, nstation); 

for i=1:nstation
  for j=1:i
    mydist(i,j)=distance(lat(i),lon(i),lat(j),lon(j))*pi()*6371./180.; 
    mydist(j,i)=mydist(i,j);
  end
end

%=======================================================================================
%% CORRELATION
%=======================================================================================

  
% now do the correlation
disp('correlation...')
mycor=nan(nstation, nstation, maxtime-mintime+1);
npts=mycor;

% for each time interval
for t=mintime:maxtime
  idx=1+abs(t);
  for i=1:nstation
    for j=1:i
      X=data(:,:,6+i);
      Y=data(:,:,6+j);
      h=ceil(data(:,:,29)-0.001);
      
      X(h~=t)=[];
      Y(h~=t)=[];
      
      X=reshape(X, numel(X), 1);
      Y=reshape(Y, numel(Y), 1);
      
      mask=isnan(X)|isnan(Y);
      X(mask)=[];
      Y(mask)=[];
      
      npts(i,j,idx)=sum(~mask);
      
      if ~isempty(X) & sum(~mask)>40
        mycor(i,j,idx)=corr(X,Y);
        %mycor(j,i,idx)=mycor(i,j,idx);
      end
      
    end
  end
end

%=======================================================================================
% MONTE-CARLO
%=======================================================================================
col{1}='b';  typ{1}='o'; 
col{2}='g';  typ{2}='x'; 
col{3}='r';  typ{3}='+'; 
col{4}='c';  typ{4}='*'; 
col{5}='m';  typ{5}='s'; 
col{6}='k';  typ{6}='d'; 
             typ{7}='v'; 
             typ{8}='^'; 
             typ{9}='p'; 
             typ{10}='h';

disp('monte-carlo...')
saved_cor=mycor;

% MONTE-CARLO LOOP ON THE NUMBER OF REMOVED STATIONS
for remST=1:19
  figure(remST); clf; hold on;
  title(['removing N= ' num2str(remST-1)])
  disp(['removing N=' num2str(remST-1)])
  
  % BOOTSTRAP.... REPEAT 100 TIMES
  for bstrap=1:100

    % refresh the total correlations
    mycor=saved_cor;
    
    % remove stations
    mylist=randperm(nstation, remST-1);
    for ll=1:remST-1
      mycor(mylist(ll),:,:)=nan;
      mycor(:,mylist(ll),:)=nan;
    end
    
    for t=mintime:maxtime
      idx=1+abs(t);
      
      Y=mycor(:,:,idx); Y=reshape(Y, numel(Y), 1);
      X=mydist(:,:);    X=reshape(X, numel(X), 1);
      mask=isnan(X)|isnan(Y)|X>maxdist;
      X(mask)=[];
      Y(mask)=[];
      
      mymodel=@(b,x) (b(2)+b(1)*x);
      [BETA,R,J,COVB,MSE,EMI] = ...
	  nlinfitwxy(X,Y,zeros(size(X)),ones(size(Y))*1,mymodel,[1 1],0);
      
      clin(remST, bstrap,idx,:)=[BETA(1), EMI.BETACONF(:,1)', t];  
      cang(remST, bstrap,idx,:)=[BETA(2), EMI.BETACONF(:,2)', t];  
     
      if (t>=-6 & bstrap==1)	
        plot(X,Y,[col{mod(idx,6)+1} typ{mod(idx,10)+1}]);
        p=plot([1:150],mymodel(BETA,[1:150]),col{mod(idx,6)+1});
        set(p,'linewidth',2);
      end
      
    end % loop over time

  end % repeat for the same # of removals
  
  prettify(gca); grid; ylim([0 1])
  print('-dpng',['figs/free_monte-carlo-Correlation_bstrap1_removing_N' ...
		 num2str(remST-1) '.png'])
  
  figure(100+remST); clf; hold on;
  X=squeeze((clin(remST,1,:,4)-0.5)*step + T0);
  Y=squeeze(nanmean(clin(remST,:,:,1)));
  Ystd=squeeze(nanstd(clin(remST,:,:,1)));
  p=errorbar(X, Y, Ystd, Ystd, '*k');

  mymodel=@(b,x) (b(1)*exp(x/b(2))+b(3));
  errX=zeros(size(X));
  errY=squeeze(nanmean(clin(remST,:,:,3)-clin(remST,:,:,2)))*0.5;
  [BETA,R,J,COVB,MSE,EMI] = ...
      nlinfitwxy(X,Y,errX,errY,mymodel,[-2e-3  1 -1e-3]);
  finex=(min(X):0.1:max(X));
  p=plot(finex,mymodel(BETA,finex),'k');
  set(p,'linewidth',2);

  Y=squeeze(nanmean(clin(1,:,:,1)));
  Ystd=squeeze(nanstd(clin(1,:,:,1)));
  p=errorbar(X, Y, Ystd, Ystd, 'ro');

  errX=zeros(size(X));
  errY=squeeze(nanmean(clin(1,:,:,3)-clin(1,:,:,2)))*0.5;
  [BETA,R,J,COVB,MSE,EMI] = ...
      nlinfitwxy(X,Y,errX,errY,mymodel,[-2e-3  1 -1e-3]);
  finex=(min(X):0.1:max(X));
  p=plot(finex,mymodel(BETA,finex),'r');
  set(p,'linewidth',2);

  ylim([-5e-3 0])
  xlabel('Time (h)')
  ylabel('Slope (1/km)')
  title(['N= ' num2str(remST-1)]);
  prettify(gca); grid; 
  print('-dpng',['figs/free_monte-carlo-Slopes_N' num2str(remST-1) '.png'])

end % change # of removals

%=======================================================================================

figure(50); clf; hold on;

for remST=1:19  
  X=squeeze((clin(remST,1,:,4)-0.5)*step + T0);
  Y=squeeze(nanmean(clin(remST,:,:,1)));
  Ystd=squeeze(nanstd(clin(remST,:,:,1)));

  plot(X,Y,col{mod(remST,6)+1})
end

xlabel('Time (h)')
ylabel('Slope (1/km)')
title([strrep(tag,'_',' ')]);
prettify(gca); grid; 
print('-dpng',['figs/free_monte-carlo-Slopes_all.png'])


%ylim([-8e-3 0]);

%%mymodel=@(b,x) (b(1)*exp(x/b(2))+b(3));
%mymodel=@(b,x) (b(1)*x+b(2));
%[BETA,R,J,COVB,MSE,EMI] = ...
%    nlinfitwxy(X,Y,...
%	       zeros(size(X)),(clin(:,3)-clin(:,2))*0.5,...
%	       mymodel,[1 1]);

%disp(sprintf('%f\t%f\t%f\t%g\n',BETA(1),EMI.BETACONF(:,1)))
%disp(sprintf('%f\t%f\t%f\t%g\n',BETA(2),EMI.BETACONF(:,2)))
%disp(sprintf('%f\t%f\t%f\t%g\n',BETA(3),EMI.BETACONF(:,3)))

%finex=(min(X):0.1:max(X));
%p=plot(finex,mymodel(BETA,finex),'r');
%set(p,'linewidth',2);

%myfit={'Nonlinear fit using model:'; 'Slope(t) = A + B exp(t / C)'; ...
%      sprintf('A = %9.3e [%9.3e ; %9.3e] km^{-1}', BETA(3), EMI.BETACONF(1,3), EMI.BETACONF(2,3)); ...
%      sprintf('B = %9.3e [%9.3e ; %9.3e] km^{-1}', BETA(1), EMI.BETACONF(1,1), EMI.BETACONF(2,1)); ...
%      sprintf('C = %5.3f [%5.3f ; %5.3f] h', BETA(2), EMI.BETACONF(1,2), EMI.BETACONF(2,2)) };

%annotation('textbox',[0.15 0.15 0.55 0.24],'string',myfit, ...
%	   'backgroundcolor',[1 1 1],'edgecolor',[0 0 0],'fontsize',12,...
%	   'fitboxtotext','off');

%figname=['figs/' tag '_angular_vs_hours' ID '.png'];
%print(figname,'-dpng');


%


