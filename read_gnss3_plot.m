clear all
close all

load('9hr_interval_output_2011.mat');

nstation=y2011.nstation;
lat=y2011.lat;
lon=y2011.lon;

nevents=36;
ntimes=size(y2011.tmp,1)/nevents;

% reshape the data and separate the events
for t=1:ntimes
  for ev=1:nevents
    tmp(t,ev, :)=y2011.tmp((t-1)*nevents+ev, :);
  end
end

% now add an extra column with the number of hours before time-0
for ev=1:nevents
  for t=1:ntimes
    tmp(t,ev, 28)=(tmp(t,ev,2)-tmp(ntimes,ev,2))*24;
  end
end

% now do the correlation
mycor=nan(nstation, nstation, 10);
mydist=nan(nstation, nstation); 

for t=-9:0
  idx=1+abs(t);
  for i=1:nstation
    for j=1:i-1
      X=tmp(:,:,6+i);
      Y=tmp(:,:,6+j);
      h=ceil(tmp(:,:,28));
      
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
        %if mycor(i,j)<0
        %  disp({'y, i, j, corr, npts=', y, i, j, mycor(i,j), sum(~mask)})
        %end
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
for t=-5:0
  idx=1+abs(t);

  Y=mycor(:,:,idx); Y=reshape(Y, numel(Y), 1);
  X=mydist(:,:);    X=reshape(X, numel(X), 1);
  mask=isnan(X)|isnan(Y);
  X(mask)=[];
  Y(mask)=[];
  
  plot(X,Y,[col{idx} typ{idx}]);
end

for t=-5:-0
  idx=1+abs(t);

  Y=mycor(:,:,idx); Y=reshape(Y, numel(Y), 1);
  X=mydist(:,:);    X=reshape(X, numel(X), 1);
  mask=isnan(X)|isnan(Y);
  X(mask)=[];
  Y(mask)=[];
  
  mymodel=@(b,x) (b(1)+b(2)*x);
  [BETA,R,J,COVB,MSE,ERRORMODELINFO] = ...
      nlinfitwxy(X,Y,zeros(size(X)),ones(size(Y))*1,mymodel,[1 1]);

  p=plot([1:150],mymodel(BETA,[1:150]),col{idx});

  disp(['t= ' num2str(t)]);
  sprintf('%f ',BETA(1), ERRORMODELINFO.BETACONF(:,1))
  sprintf('%f ',BETA(2), ERRORMODELINFO.BETACONF(:,2))

  clin(idx,:)=[BETA(1), ERRORMODELINFO.BETACONF(:,1)', t];
  cang(idx,:)=[BETA(2), ERRORMODELINFO.BETACONF(:,2)', t];
  
  %p=plot(X,ERRORMODELINFO.YPRED,col{idx});
  %curve=fit(X,Y,'poly1')
  %p=plot(curve,col{idx});
  set(p,'linewidth',2);
  
end

disp('Linear Coefficient')
disp(sprintf('\t\t95%% conf. interval'))
disp(sprintf('value \t\tlow \t\thigh \t\ttime'))
disp(sprintf('%f\t%f\t%f\t%g\n',clin'))

disp('Angular Coefficient')
disp(sprintf('\t\t95%% conf. interval'))
disp(sprintf('value \t\tlow \t\thigh \t\ttime'))
disp(sprintf('%g\t%g\t%g\t%g\n',cang'))

%ylim([0.5 1])
xlabel('distance between stations (km)')
ylabel('pearson correlation coefficient')
legend('-5h','-4h','-3h','-2h','-1h','0h','Location','southwest')
%legend('-9h','-8h','-7h','-6h','-5h','-4h','-3h','-2h','-1h','0h','Location','southwest')
prettify(gca)
print('testing_to_david.png','-dpng')

clear X Y
figure(2); clf; hold on;
for i=1:nstation
  Y(:,i)=squeeze(nanmean(tmp(:,:,i+6),2));
  X=((1:size(Y,1))-size(Y,1))*5/60;
  plot(X,Y(:,i))
end
plot(X,nanmean(Y,2),'k','linewidth',2)
xlabel('hours')
ylabel('derivative')
prettify(gca)
grid on
print('time_evolution.png','-dpng')
% fim
