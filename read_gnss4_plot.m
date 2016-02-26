clear all
close all

% list of stations
tmp=read_mixed_csv(['station_file_list_T02_2011_2012'],' ');

nstation=size(tmp,1);
name=tmp(:,1);
lat=str2double(tmp(:,2));
lon=str2double(tmp(:,3));
clear tmp

%tag=['All_Derivatives']; nevents=67; var='dPWVdt';
tag=['All_PWV']; nevents=67; var='PWV';
%tag=['Daytime_Derivatives']; nevents=55; var='dPWVdt';
tag=['Daytime_PWV']; nevents=55; var='PWV';

%load([tag '_9hr_interval_2011_2012.mat']);

% read data
disp('reading data...')
tmp=importdata([tag '_9hr_interval_2011_2012.dat'],' ',3);
tmp=tmp.data;
tmp(tmp<-900)=nan;

ntimes=size(tmp,1)/nevents;

% reshape the data and separate the events
for t=1:ntimes
  for ev=1:nevents
    data(t,ev, :)=tmp((t-1)*nevents+ev, :);
  end
end

% now add an extra column with the number of hours before time-0
for ev=1:nevents
  for t=1:ntimes
    data(t,ev, 28)=(data(t,ev,2)-data(ntimes,ev,2))*24;
  end
end

% now do the correlation
mycor=nan(nstation, nstation, 10);
mydist=nan(nstation, nstation); 

for t=-9:0
  idx=1+abs(t);
  for i=1:nstation
    for j=1:i
      X=data(:,:,6+i);
      Y=data(:,:,6+j);
      h=ceil(data(:,:,28));
      
      X=reshape(X, numel(X), 1);
      Y=reshape(Y, numel(Y), 1);
      
      X(h~=t)=[];
      Y(h~=t)=[];
      
      mask=isnan(X)|isnan(Y);
      X(mask)=[];
      Y(mask)=[];

      if ~isempty(X) 
        mycor(i,j,idx)=corr(X,Y);
        %mycor(j,i,idx)=mycor(i,j,idx);
        if mycor(i,j)<0
          disp({'t, i, j, corr, npts=', t, i, j, mycor(i,j), sum(~mask)})
        end
      end
      
      mydist(i,j)=distance(lat(i),lon(i),lat(j),lon(j))*pi()*6371./180.; 
      %mydist(j,i)=mydist(i,j);
    end
  end
end

% faz o grafico
col{1}='b';  typ{1}='o'; 
col{2}='g';  typ{2}='x'; 
col{3}='r';  typ{3}='+'; 
col{4}='c';  typ{4}='*'; 
col{5}='m';  typ{5}='s'; 
col{6}='k';  typ{6}='d'; 
col{7}='b';  typ{7}='v'; 
col{8}='g';  typ{8}='^'; 
col{9}='r';  typ{9}='p'; 
col{10}='c'; typ{10}='h';

figure(1); clf; hold on;
for t=-9:0
  idx=1+abs(t);

  Y=mycor(:,:,idx); Y=reshape(Y, numel(Y), 1);
  X=mydist(:,:);    X=reshape(X, numel(X), 1);
  mask=isnan(X)|isnan(Y);
  X(mask)=[];
  Y(mask)=[];
  
  plot(X,Y,[col{idx} typ{idx}]);
end

for t=-9:-0
  idx=1+abs(t);

  Y=mycor(:,:,idx); Y=reshape(Y, numel(Y), 1);
  X=mydist(:,:);    X=reshape(X, numel(X), 1);
  mask=isnan(X)|isnan(Y);
  X(mask)=[];
  Y(mask)=[];
  
  %mymodel=@(b,x) (b(1)+b(2)*x);
  mymodel=@(b,x) (1+b(1)*x);
  [BETA,R,J,COVB,MSE,ERRORMODELINFO] = ...
      nlinfitwxy(X,Y,zeros(size(X)),ones(size(Y))*1,mymodel,[1]);

  p=plot([1:150],mymodel(BETA,[1:150]),col{idx});
  set(p,'linewidth',2);

  disp(['t= ' num2str(t)]);
  sprintf('%f ',BETA(1), ERRORMODELINFO.BETACONF(:,1))
  %sprintf('%f ',BETA(2), ERRORMODELINFO.BETACONF(:,2))

  clin(idx,:)=[BETA(1), ERRORMODELINFO.BETACONF(:,1)', t];
  %cang(idx,:)=[BETA(2), ERRORMODELINFO.BETACONF(:,2)', t];
  
  %p=plot(X,ERRORMODELINFO.YPRED,col{idx});
  %curve=fit(X,Y,'poly1')
  %p=plot(curve,col{idx});
  
end
%ylim([0.5 1])
xlabel('distance between stations (km)')
ylabel('pearson correlation coefficient')
%legend('-5h','-4h','-3h','-2h','-1h','0h','Location','southwest')
legend('-9h','-8h','-7h','-6h','-5h','-4h','-3h','-2h','-1h','0h','Location','southwest')
title([strrep(tag,'_',' ')]);
prettify(gca); grid;
print([tag '_testing_to_david.png'],'-dpng')

%=======================================================================================

disp('Angular Coefficient')
%disp('Linear Coefficient')
disp(sprintf('\t\t95%% conf. interval'))
disp(sprintf('value \t\tlow \t\thigh \t\ttime'))
disp(sprintf('%f\t%f\t%f\t%g\n',clin'))

%disp('Angular Coefficient')
%disp(sprintf('\t\t95%% conf. interval'))
%disp(sprintf('value \t\tlow \t\thigh \t\ttime'))
%disp(sprintf('%g\t%g\t%g\t%g\n',cang'))

X=clin(:,4)-0.5;
Y=clin(:,1);
figure(50); clf; hold on;
p=errorbar(X, Y, clin(:,2)-Y, clin(:,3)-Y,'*k');

xlabel('Time (h)')
ylabel('Slope (1/km)')
prettify(gca); grid;

mymodel=@(b,x) (b(1)*exp(b(2)*x)+b(3));
%mymodel=@(b,x) (b(1)*x+b(2));
[BETA,R,J,COVB,MSE,ERRORMODELINFO] = ...
    nlinfitwxy(X,Y,...
	       zeros(size(X)),(clin(:,3)-clin(:,2))*0.5,...
	       mymodel,[1 1 1]);

disp(sprintf('%f\t%f\t%f\t%g\n',BETA(1),ERRORMODELINFO.BETACONF(:,1)))
disp(sprintf('%f\t%f\t%f\t%g\n',BETA(2),ERRORMODELINFO.BETACONF(:,2)))
disp(sprintf('%f\t%f\t%f\t%g\n',BETA(3),ERRORMODELINFO.BETACONF(:,3)))

finex=(min(X):0.1:max(X));
p=plot(finex,mymodel(BETA,finex),'r');
set(p,'linewidth',2);

annotation('textbox',[0.1 0.1 0.5 0.5]);

print([tag '_angular_vs_hours.png'],'-dpng')

return
%=======================================================================================
% times series, averaged over events
clear X Y
figure(100); clf; hold on;
for i=1:nstation
  Y(:,i)=squeeze(nanmean(data(:,:,i+6),2));
  X=((1:size(Y,1))-size(Y,1))*5/60;
  plot(X,Y(:,i))
end
plot(X,nanmean(Y,2),'k','linewidth',2)
xlabel('hours')
ylabel(var);
title([strrep(tag,'_',' ') 'averaged over events, lines = stations']);
prettify(gca); grid on
print([tag '_time_evolution_per_station.png'],'-dpng')
% fim

%=======================================================================================
% times series, averaged over stations
clear X Y
figure(200); clf; hold on
for i=1:nevents
  Y(:,i)=squeeze(nanmean(data(:,i,7:end-1),3));
  X=((1:size(Y,1))-size(Y,1))*5/60;
  plot(X,Y(:,i))
end
plot(X,nanmean(Y,2),'k','linewidth',2)
xlabel('hours');
ylabel(var);
title([strrep(tag,'_',' ') 'averaged over stations, lines = events']);
prettify(gca); grid on; 
print([tag '_time_evolution_per_event.png'],'-dpng')
%fim