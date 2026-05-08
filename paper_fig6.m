clear all
close all

figure(50); clf; hold on;

for opt=1:2

clear BETA R J COVB MSE EMI ID T0 X Y clin col data ev filedt h i idx j ...
    lat lon mask maxdist maxtime mintime mycor mydist myleg mylist ...
    mymodel name nevents npts nstation ntimes p step t tag tmp ...
    typ var ymin z ctt15clean figname jd
    
% list of stations
tmp=read_mixed_csv(['station_file_list_T02_2011_2012'],' ');

nstation=size(tmp,1);
name=tmp(:,1);
lat=str2double(tmp(:,2));
lon=str2double(tmp(:,3));
clear tmp

% the last lines in the files are the T0 of each event (which vary)
% for the diurnal cycle files, however, this is always 8pm.
T0=0; % hours
filedt=5; % min
tofit=1;

switch opt
 case 1
  tag=['Dry_Season_PWV']; nevents=27; var='PWV';T0=0; ctt15clean=0; ymin=0;maxdist=150;
  ID='_14hr_interval_2011_2012';
 case 2
  tag=['Wet_Season_PWV']; nevents=24; var='PWV';T0=0; ctt15clean=0; ymin=0;maxdist=150;
  ID='_14hr_interval_2011_2012';
end

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
%tag=['BG_' tag];
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

% now do the correlation
disp('correlation...')
mycor=nan(nstation, nstation, maxtime-mintime+1);
mydist=nan(nstation, nstation); 

npts=mycor;
z=0; clear mylist
for t=mintime:maxtime
  idx=1+abs(t);
  for i=1:nstation
    for j=1:i
      %if (i==16 | j==16 | i==13 | j==13 | i==12 | j==12) continue; end
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
      
      mydist(i,j)=distance(lat(i),lon(i),lat(j),lon(j))*pi()*6371./180.; 
      %mydist(j,i)=mydist(i,j);

      if ~isempty(X) & sum(~mask)>40 %& mydist(i,j)>50.
        mycor(i,j,idx)=corr(X,Y);
        %mycor(j,i,idx)=mycor(i,j,idx);
        if mycor(i,j,idx)<=0
          z=z+1; mylist(z)=i; z=z+1; mylist(z)=j;
          disp({'t, i, j, corr, npts=', t, i, j, mycor(i,j,idx), sum(~mask)})
        end
      end
      
    end
  end
end

%tag=['50km_' tag];

%=======================================================================================
% faz o grafico

col{1}='b';  typ{1}='o'; 
col{2}='r';  typ{2}='x'; 
col{3}='g';  typ{3}='+'; 
col{4}='c';  typ{4}='*'; 
col{5}='m';  typ{5}='s'; 
col{6}='k';  typ{6}='d'; 
             typ{7}='v'; 
             typ{8}='^'; 
             typ{9}='p'; 
             typ{10}='h';

figure(opt); clf; hold on;
for t=mintime:maxtime
  idx=1+abs(t);

  Y=mycor(:,:,idx); Y=reshape(Y, numel(Y), 1);
  X=mydist(:,:);    X=reshape(X, numel(X), 1);
  mask=isnan(X)|isnan(Y);
  X(mask)=[];
  Y(mask)=[];

  if (t>=-6)
    plot(X,Y,[col{mod(idx,6)+1} typ{mod(idx,10)+1}]);
  end
end
%=======================================================================================

clear myleg
z=0; 
for t=mintime:maxtime
  idx=1+abs(t);

  Y=mycor(:,:,idx); Y=reshape(Y, numel(Y), 1);
  X=mydist(:,:);    X=reshape(X, numel(X), 1);
  mask=isnan(X)|isnan(Y)|X>maxdist;
  X(mask)=[];
  Y(mask)=[];

  %mymodel=@(b,x) (b(1)+b(2)*x);
  mymodel=@(b,x) (1+b(1)*x);
  [BETA,R,J,COVB,MSE,EMI] = ...
      nlinfitwxy(X,Y,zeros(size(X)),ones(size(Y))*1,mymodel,[1]);

  if (t>=-6)
    p=plot([1:150],mymodel(BETA,[1:150]),col{mod(idx,6)+1});
    set(p,'linewidth',2);
    z=z+1; myleg{z}=sprintf('%g h',t*step+T0);
  end

  %disp(['t= ' num2str(t)]);
  %sprintf('%f ',BETA(1), EMI.BETACONF(:,1))
  %sprintf('%f ',BETA(2), EMI.BETACONF(:,2))

  clin(idx,:)=[BETA(1), EMI.BETACONF(:,1)', t];
  %cang(idx,:)=[BETA(2), EMI.BETACONF(:,2)', t];
end
ylim([ymin 1])
xlabel('Distance between stations (km)')
ylabel('Correlation coefficient')
legend(myleg,'Location','southwest')
%title([strrep(tag,'_',' ')]);
prettify(gca); grid;
figname=['figs/' tag '_correlation_distance' ID '.png'];
%print(figname,'-dpng');

%=======================================================================================

disp('Angular Coefficient')
%disp('Linear Coefficient')
disp(sprintf('\t\t95%% conf. interval'))
disp(sprintf('value \t\tlow \t\thigh \t\ttime'))
disp(sprintf('%f\t%f\t%f\t%g\n',clin'))

X=(clin(:,4)-0.5)*step + T0;
Y=clin(:,1);

%figure(50); clf; hold on;
figure(50)
p=errorbar(X, Y, clin(:,2)-Y, clin(:,3)-Y,[col{opt} typ{opt}]);

if tofit>0
  mymodel=@(b,x) (b(1)*exp(x/b(2))+b(3));
  %mymodel=@(b,x) (b(1)*x+b(2));
  [BETA,R,J,COVB,MSE,EMI] = ...
      nlinfitwxy(X,Y,...
                 zeros(size(X)),(clin(:,3)-clin(:,2))*0.5,...
                 mymodel,[-2e-3  1 -1e-3]);
  
  disp(sprintf('%f\t%f\t%f\t%g\n',BETA(1),EMI.BETACONF(:,1)))
  disp(sprintf('%f\t%f\t%f\t%g\n',BETA(2),EMI.BETACONF(:,2)))
  disp(sprintf('%f\t%f\t%f\t%g\n',BETA(3),EMI.BETACONF(:,3)))
  
  finex=(min(X):0.1:max(X));
  p=plot(finex,mymodel(BETA,finex),col{opt});
  set(p,'linewidth',2);

  leg{opt}=sprintf('$\\tau$ = %5.3f [%5.3f ; %5.3f] h', BETA(2), EMI.BETACONF(1,2), EMI.BETACONF(2,2));

end

%=======================================================================================

end % loop over opt

myfit=['Nonlinear fit using model:' char(10) 'Slope(t) = A + B exp(t / $\tau$)' char(10) ...
       'Dry, ' leg{1} char(10) 'Wet, ' leg{2} ];

h=annotation('textbox',[0.15 0.15 0.41 0.15],'string','', ...
           'backgroundcolor',[1 1 1],'edgecolor',[0 0 0],'fontsize',12,...
           'fitboxtotext','off','interpreter','latex');

xlim=get(gca,'xlim');
ylim=get(gca,'ylim');

%t=text(xlim(1)+diff(xlim)*0.15, ylim(1)+diff(ylim)*0.15, myfit, 'fontsize',12,...
t=annotation('textbox',[0.15 0.15 0.45 0.18],'string', myfit, 'fontsize',12,...
             'linestyle','none',...
             'horizontalalignment','left','verticalalignment','bottom',...
             'interpreter','latex');

xlabel('Time ($h$)','Interpreter','LaTex')
ylabel('Slope ($km^{-1}$)','Interpreter','LaTex')
%title([strrep(tag,'_',' ')]);
prettify(gca); grid;
%ylim([-8e-3 0]);

figname=['figs/figure6_Dry_Wet_angular_vs_hours'];
print([figname '.png'],'-dpng');
print([figname '.eps'],'-depsc2');
saveas(gca,[figname '.fig'],'fig');

disp(['ntimes= ' num2str(ntimes)])
disp(['nevents= ' num2str(nevents)])
disp(['nstation= ' num2str(nstation)])

  
  
%


