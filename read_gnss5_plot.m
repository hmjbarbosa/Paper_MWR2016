clear all

fid=fopen('allfigures.tex','w');
fprintf(fid,'%s\n','\documentclass[a4papper]{article}');
fprintf(fid,'%s\n','\usepackage{graphicx}');
fprintf(fid,'%s\n','\setlength{\headheight}{0cm} ');
fprintf(fid,'%s\n','\setlength{\headsep}{0cm}');
fprintf(fid,'%s\n','\setlength{\textheight}{23.7cm} ');
fprintf(fid,'%s\n','\setlength{\textwidth}{18cm}');
fprintf(fid,'%s\n','\setlength{\oddsidemargin}{-1cm} ');
fprintf(fid,'%s\n','\setlength{\evensidemargin}{-1cm}');
fprintf(fid,'%s\n','\setlength{\topmargin}{-1cm} ');
fprintf(fid,'%s\n','\setlength{\topskip}{0cm}');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','\begin{document}');

for opt=3:3
%for opt=1:21

close all

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
  continue
  tag=['All_Derivatives']; nevents=67; var='dPWVdt';T0=0; ctt15clean=0; ymin=-1;maxdist=40;
  ID='_9hr_interval_2011_2012';
 case 2
  continue
  tag=['Daytime_Derivatives']; nevents=55; var='dPWVdt';T0=0; ctt15clean=0; ymin=-1;maxdist=40;
  ID='_9hr_interval_2011_2012';
 case 3
  tag=['All_PWV']; nevents=67; var='PWV';T0=0; ctt15clean=0; ymin=0;maxdist=150;
  ID='_14hr_interval_2011_2012';
 case 4
  tag=['Daytime_PWV']; nevents=55; var='PWV';T0=0; ctt15clean=0; ymin=0;maxdist=150;
  ID='_14hr_interval_2011_2012';
 case 5
  tag=['Nightime_PWV']; nevents=12; var='PWV';T0=0; ctt15clean=0; ymin=0;maxdist=150;
  ID='_14hr_interval_2011_2012'; 
 case 6
  tag=['Dry_Season_PWV']; nevents=27; var='PWV';T0=0; ctt15clean=0; ymin=0;maxdist=150;
  ID='_14hr_interval_2011_2012';
 case 7
  tag=['Wet_Season_PWV']; nevents=24; var='PWV';T0=0; ctt15clean=0; ymin=0;maxdist=150;
  ID='_14hr_interval_2011_2012';
 case 8
  continue
  tag=['Smoothed_1hr_All_PWV']; nevents=67; var='PWV';T0=0; ctt15clean=0; ymin=0.4;maxdist=150;
  ID='_14hr_interval_2011_2012';
 case 9
  continue
  tag=['Smoothed_1hr_All_Derivatives']; nevents=67; var='dPWVdt';T0=0; ctt15clean=0; ymin=-1;maxdist=40;
  ID='_14hr_interval_2011_2012';
 case 10 
  continue
  tag=['Smoothed_1hr_Daytime_PWV']; nevents=55; var='PWV';T0=0; ctt15clean=0; ymin=0.4;maxdist=150;
  ID='_14hr_interval_2011_2012';
 case 11
  continue
  tag=['Smoothed_1hr_Daytime_Derivatives']; nevents=55; var='dPWVdt';T0=0; ctt15clean=0; ymin=-1;maxdist=40;
  ID='_14hr_interval_2011_2012';
 case 12
  tag=['Convective_CTT_events']; nevents=69; var='CTT'; T0=0; ctt15clean=1;ymin=0;maxdist=150;
  ID='_14hr_interval_output';
%  tag=['Daytime_CTT']; nevents=55; var='CTT'; T0=0; ctt15clean=1;ymin=0;maxdist=150;
%  ID='_14hr_interval_2011_2012';
 case 13
  continue
  tag=['Daytime_CTT_no_missing_PWV']; nevents=55; var='CTT'; T0=0; ctt15clean=1;ymin=0;maxdist=150;
  ID='_14hr_interval_2011_2012';
 case 14
  tag=['Diurnal_Cycle_Dry_to_Wet']; nevents=91; var='PWV'; T0=20;ctt15clean=0; ymin=0.4;maxdist=150;
  ID='_12hr_interval_output';tofit=0;
 case 15
  tag=['Diurnal_Cycle_Wet']; nevents=119; var='PWV'; T0=20;ctt15clean=0; ymin=0.4;maxdist=150;
  ID='_12hr_interval_output';tofit=0;
 case 16
  tag=['Non_Convective_Events_2011']; nevents=60; var='PWV';T0=0; ctt15clean=0; ymin=0.4;maxdist=150;
  ID='_12hr_interval_output';tofit=0;
 case 17
  tag=['Daytime_Non_Convective_Events_2011_2012']; nevents=30; var='PWV';T0=0; ctt15clean=0; ymin=0.4;maxdist=150;
  ID='_12hr_interval_output';
 case 18
  tag=['All_PWV_events']; nevents=67; var='PWV';T0=0; ctt15clean=0; ymin=0;maxdist=150;
  ID='_14hr_interval_output_anomalies';
 case 19
  tag=['All_PWV_events']; nevents=67; var='PWV';T0=0; ctt15clean=0; ymin=0;maxdist=150;
  ID='_8hr_interval_output';
 case 20
  tag=['All_Pressure_events']; nevents=67; var='PWV';T0=0; ctt15clean=0; ymin=0;maxdist=150;
  ID='_14hr_interval_output'; tofit=0;
 case 21
  tag=['All_PWV_events']; nevents=67; var='PWV';T0=0; ctt15clean=0; ymin=0;maxdist=150;
  ID='_14hr_interval_removed_output';
end

% read data
disp('reading data...')
tmp=importdata([tag ID '.dat'],' ',3);
tmp=tmp.data;
tmp(tmp<-900)=nan;

%tmp(:,7)=rand(size(tmp(:,7)));
%for i=8:27
%  tmp(:,i)=tmp(:,7);
%end


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

fprintf(fid,'\n%s\n','\begin{figure}[h]');
fprintf(fid,'%s\n','\centering');

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
if any(diff(reshape(jd,ntimes*nevents,1)))<0
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

col{1}='r';  typ{1}='+'; 
col{2}='k';  typ{2}='h'; 
col{3}='b';  typ{3}='o'; 
col{4}='c';  typ{4}='*'; 
col{5}='y';  typ{5}='s'; 
col{6}='g';  typ{6}='d'; 
col{7}='m';  typ{7}='v'; 
             typ{8}='^'; 
             typ{9}='p'; 
             typ{10}='h';

%col{5}=[0.08 0.46 0];	     

col{2}=[160 0 200 ]./255;
col{3}=[240 0 130 ]./255;
col{4}=[230 175 45]./255;
col{5}=[160 230 50]./255;
col{6}=[0 200 200 ]./255;
col{7}=[30  60 255]./255;
col{1}='k';

	     
figure(1); clf; hold on;
for t=mintime:maxtime
  idx=1+abs(t);

  Y=mycor(:,:,idx); Y=reshape(Y, numel(Y), 1);
  X=mydist(:,:);    X=reshape(X, numel(X), 1);
  mask=isnan(X)|isnan(Y);
  X(mask)=[];
  Y(mask)=[];

  if (t>=-6)
%    p=plot(X,Y,[col{mod(idx,6)+1} typ{mod(idx,10)+1}]);
    p=plot(X,Y,typ{mod(idx,10)+1});
    set(p,'color',col{mod(idx,7)+1},'markerfacecolor',col{mod(idx,7)+1});
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
    p=plot([1:150],mymodel(BETA,[1:150]));
    set(p,'linewidth',2,'color',col{mod(idx,7)+1});
    z=z+1; myleg{z}=sprintf('%g h',t*step+T0);
  end

  %disp(['t= ' num2str(t)]);
  %sprintf('%f ',BETA(1), EMI.BETACONF(:,1))
  %sprintf('%f ',BETA(2), EMI.BETACONF(:,2))

  clin(idx,:)=[BETA(1), EMI.BETACONF(:,1)', t];
  %cang(idx,:)=[BETA(2), EMI.BETACONF(:,2)', t];
end
ylim([ymin 1])
xlabel('Distance Between Stations (km)')
ylabel('Correlation Coefficient')
legend(myleg,'Location','southwest')
%title([strrep(tag,'_',' ')]);
prettify(gca); grid;
figname=['figs/' tag '_correlation_distance' ID '.png'];
print(figname,'-dpng');
print([figname '.eps'],'-depsc2');
saveas(gca,[figname '.fig'],'fig');
fprintf(fid,'%s\n',['\includegraphics[width=0.45\linewidth]{' figname '}']);

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

X=(clin(:,4)-0.5)*step + T0;
Y=clin(:,1);

figure(50); clf; hold on;
p=errorbar(X, Y, clin(:,2)-Y, clin(:,3)-Y,'*k');

xlabel('Time (h)')
ylabel('Slope (1/km)')
%title([strrep(tag,'_',' ')]);
prettify(gca); grid;
%ylim([-8e-3 0]);

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
  p=plot(finex,mymodel(BETA,finex),'r');
  set(p,'linewidth',2);
  
  myfit=['Nonlinear fit using model:' char(10) 'Slope(t) = A + B exp(t / $\tau$)' char(10) ...
	 sprintf('$\\tau$ = %5.3f [%5.3f ; %5.3f] h', BETA(2), EMI.BETACONF(1,2), EMI.BETACONF(2,2)) ];

  %myfit={'Nonlinear fit using model:'; 'Slope(t) = A + B exp(t / C)'; ...
  %      sprintf('A = %9.3e [%9.3e ; %9.3e] km^{-1}', BETA(3), EMI.BETACONF(1,3), EMI.BETACONF(2,3)); ...
  %      sprintf('B = %9.3e [%9.3e ; %9.3e] km^{-1}', BETA(1), EMI.BETACONF(1,1), EMI.BETACONF(2,1)); ...
  %      sprintf('C = %5.3f [%5.3f ; %5.3f] h', BETA(2), EMI.BETACONF(1,2), EMI.BETACONF(2,2)) };
  %myfit={'Nonlinear fit using model:'; 'Slope(t) = A + B exp(t / C)'; ...
  %       sprintf('A = %9.3e km^{-1}', BETA(3)); ...
  %       sprintf('B = %9.3e km^{-1}', BETA(1)); ...
  %       sprintf('C = %5.3f h', BETA(2)) };

  %annotation('textbox',[0.15 0.15 0.30 0.24],'string',myfit, ...
%  annotation('textbox',[0.15 0.15 0.55 0.24],'string',myfit, ...
%             'backgroundcolor',[1 1 1],'edgecolor',[0 0 0],'fontsize',12,...
%             'fitboxtotext','off',  'interpreter','latex');
h=annotation('textbox',[0.15 0.15 0.38 0.12],'string','', ...
           'backgroundcolor',[1 1 1],'edgecolor',[0 0 0],'fontsize',12,...
           'fitboxtotext','off','interpreter','latex');
t=annotation('textbox',[0.15 0.15 0.42 0.15],'string', myfit, 'fontsize',12,...
             'linestyle','none',...
             'horizontalalignment','left','verticalalignment','bottom',...
             'interpreter','latex');
end

figname=['figs/' tag '_angular_vs_hours' ID '.png'];
print(figname,'-dpng');
print([figname '.eps'],'-depsc2');
saveas(gca,[figname '.fig'],'fig');

fprintf(fid,'%s\n',['\includegraphics[width=0.45\linewidth]{' figname '}']);

%=======================================================================================
% times series, averaged over events
clear X Y
figure(100); clf; hold on;
for i=1:nstation
  Z(:,i)=squeeze(nanmean(~isnan(data(:,:,i+6)),2));
  Y(:,i)=squeeze(nanmean(data(:,:,i+6),2));
  X=((1:size(Y,1))-size(Y,1))*filedt/60 + T0;
  plot(X,Y(:,i))
end
plot(X,nanmean(Y,2),'k','linewidth',2)
xlabel('hours')
ylabel(var);
title([strrep(tag,'_',' ') '  averaged over events, lines = stations']);
prettify(gca); grid on
figname=['figs/' tag '_time_evolution_per_station' ID '.png'];
print(figname,'-dpng')
fprintf(fid,'%s\n',['\includegraphics[width=0.45\linewidth]{' figname '}']);

% fim
tmp=datevec(datenum(2012,1,1)+X/24);
ffid=fopen('all_67_events_timestep_anomalies_OK.dat','w');
for i=1:size(Y,1)
  for j=1:nstation
    if (j==13)
      A=fwrite(ffid,sprintf('%4d  %2d  %2d  %2d  %2d  %s  %.2f  %.2f  %.2f  %.3f\n',...
                           tmp(i,1:5), name{j}, lat(j), lon(j), -999.99,...
                            -999.99 ));
    else
      A=fwrite(ffid,sprintf('%4d  %2d  %2d  %2d  %2d  %s  %.2f  %.2f  %.2f  %.3f\n',...
                           tmp(i,1:5), name{j}, lat(j), lon(j), Y(i,j)-nanmean(Y(:,j)),...
                            Z(i,j)));
    end
  end
end
fclose(ffid);

%=======================================================================================
% times series, averaged over stations
clear X Y
figure(200); clf; hold on
for i=1:nevents
  Y(:,i)=squeeze(nanmean(data(:,i,7:27),3));
  X=((1:size(Y,1))-size(Y,1))*filedt/60 + T0;
  plot(X,Y(:,i))
end
plot(X,nanmean(Y,2),'k','linewidth',2)
xlabel('hours');
ylabel(var);
title([strrep(tag,'_',' ') '  averaged over stations, lines = events']);
prettify(gca); grid on; 
figname=['figs/' tag '_time_evolution_per_event' ID '.png'];
print(figname,'-dpng')
fprintf(fid,'%s\n',['\includegraphics[width=0.45\linewidth]{' figname '}']);

%=======================================================================================
% histogram of number of points
figure(300); clf; hold on
hist(reshape(npts,numel(npts),1),50);
xlabel('number of points used in correlation');
ylabel('frequency');
title([strrep(tag,'_',' ') ]);
prettify(gca); grid on; 
legend(['N= ' num2str(sum(reshape(npts>40,numel(npts),1))) ...
        ' /  ' num2str(0.5*nstation*(nstation+1)*ntimes*filedt/60)])
figname=['figs/' tag '_hist_npts' ID '.png'];
print(figname,'-dpng')
fprintf(fid,'%s\n',['\includegraphics[width=0.45\linewidth]{' figname '}']);


%=======================================================================================
% for each station, number of data points points x time
figure(400); clf; hold on
plot(X,squeeze(sum(~isnan(data(:,:,7:27)),2)),'o-')
xlabel('hours');
ylabel('# of event per station');
title([strrep(tag,'_',' ') ]);
prettify(gca); grid on; 
figname=['figs/' tag '_npts_time' ID '.png'];
print(figname,'-dpng')
fprintf(fid,'%s\n',['\includegraphics[width=0.45\linewidth]{' figname '}']);

%fim

fprintf(fid,'%s\n',['\caption{' strrep([tag ID],'_','\_') '.dat' ...
                    ', ntimes=' num2str(ntimes) ...
                    ', nevents=' num2str(nevents) ...
                    ', nstation=' num2str(nstation) ...
                    ', max dist=' num2str(maxdist) ...
		    ', file dt=' num2str(filedt) '}']);

fprintf(fid,'%s\n','\end{figure}');

%=======================================================================================
% for each station, average number of points

figure(500); clf; hold on
%plot(1:21,squeeze(sum(sum(~isnan(data(:,:,7:27)),2),1)),'o-')
plot(1:21,mean(reshape(~isnan(data(:,:,7:27)),nevents*ntimes,nstation),1),'o-')

end % loop over opt


fprintf(fid,'%s\n','\end{document}');
fclose(fid);


disp(['ntimes= ' num2str(ntimes)])
disp(['nevents= ' num2str(nevents)])
disp(['nstation= ' num2str(nstation)])

  
  
%


