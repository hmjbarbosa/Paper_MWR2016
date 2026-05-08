clear all 
close all

%% =====================================================================
%% PREPARE PLOT
%% =====================================================================

mlat1=-3.5; mlat2=-2.5;
mlon1=-60.7; mlon2=-59.5;

widpx=1050;
widcm=8.5;
dpi=floor(widpx/widcm*2.54);
xyprop=(mlat2-mlat1)/(mlon2-mlon1);

f=figure(1); clf; 
set(gca,'position',[0.12 0.12 .8 .75]);
%set(gcf,'units','centimeters','position',[0,0,widcm,widcm*xyprop]); %
%set(gcf,'PaperPositionMode','auto')

%set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 widcm widcm*xyprop])
%'PaperSize',[8.5 6.0],

hold on; grid on; box on;
view(2); % from top
set(f,'Color',[1 1 1]);
set(gca,'color',[1 1 1]);
set(gca,'ylim',[mlat1 mlat2]);
set(gca,'xlim',[mlon1 mlon2]);
set(gca,'YDir','Normal');
pbaspect(daspect)

n=get(gca,'xtick');
set(gca,'xticklabel',compose('%.1f',n));
n=get(gca,'ytick');
set(gca,'yticklabel',compose('%.1f',n));

%% =====================================================================
%% SITES
%% =====================================================================

% list of stations
tmp=read_mixed_csv('station_file_list_T02_2011_2012',' ');

nstation=size(tmp,1);
name=tmp(:,1);
lat=str2double(tmp(:,2));
lon=str2double(tmp(:,3));
clear tmp

nstation=nstation+1;
name{nstation}='GOAM';
lat(nstation)=-3.228888; 
lon(nstation)=-60.5897;

%mean(reshape(~isnan(data(:,:,7:27)),nevents*ntimes,nstation),1)

dens=[0.7846    0.8356    0.9529    0.9104    0.6406    0.6037 ...
      0.5800    0.5458    0.6882    0.8165    0.7142    0.5965 0.0836 ...
      0.4495    0.6565    0.5224    0.7026    0.9998 0.8805    0.6397 ...
      0.4789    0];
    
% plot all sites
for i=1:nstation
  if ((lon(i)>=mlon1) && (lon(i)<=mlon2) && ...
      (lat(i)>=mlat1) && (lat(i)<=mlat2))
    
    clear col
    if (dens(i)<0.40)
      col='k';
    end
    if ((dens(i)>=0.40) && (dens(i)<0.60))
      col='r';
    end
    if ((dens(i)>=0.60) && (dens(i)<0.80))
      col='y';
    end
    if (dens(i)>=0.80)
      col='g';
    end
    plot3(lon(i),lat(i),0, 'Marker','o','linewidth',1,...
          'MarkerEdgeColor','k','MarkerFace',col,'MarkerSize',7);
  end
end

for i=1:nstation
  if ((lon(i)>=mlon1) && (lon(i)<=mlon2) && ...
      (lat(i)>=mlat1) && (lat(i)<=mlat2))
    switch i
     case 1
      text(lon(i),lat(i)-0.02,name{i},'fontsize',9,'color',[1 1 1])
     case 2
      text(lon(i)-0.03,lat(i)+0.03,name{i},'fontsize',9,'color',[1 1 1])
     case 3 
      text(lon(i)-0.05,lat(i)-0.03,name{i},'fontsize',9,'color',[1 1 1])
     case 4
      text(lon(i)-0.09,lat(i)-0.02,name{i},'fontsize',9,'color',[1 1 1])
     case 9
      text(lon(i)-0.08,lat(i)-0.02,name{i},'fontsize',9,'color',[1 1 1])
     case 13 
      text(lon(i)-0.1,lat(i),name{i},'fontsize',9,'color',[1 1 1])
     case 14
      text(lon(i)-0.02,lat(i)+0.02,name{i},'fontsize',9,'color',[1 1 1])
     case 18
      text(lon(i)-0.05,lat(i)+0.03,name{i},'fontsize',9,'color',[1 1 1])
     case 20 
      text(lon(i)+0.015,lat(i)-0.015,name{i},'fontsize',9,'color',[1 1 1])
     case 21 
      text(lon(i)-0.1,lat(i),name{i},'fontsize',9,'color',[1 1 1])
     otherwise
      text(lon(i)+0.015,lat(i)+0.015,name{i},'fontsize',9,'color',[1 1 1])
    end
  end
end

%% =====================================================================
%% BACKGROUND IMAGE FROM GOOGLE EARTH
%% =====================================================================

% google earth background
toread=1;
if exist([pwd '/googleearth.mat'],'file')==2
  load googleearth.mat
  % does the image cover the desired region?
  if ~((mlon1<min(lonVect)) || (mlon2>max(lonVect)) || ...
      (mlat1<min(latVect)) || (mlat2>max(latVect)))
    toread=0;
  end
  % is the size of the image too much bigger then requested?
  if (distance(mlat1,mlon1,mlat2,mlon2) < 0.3*...
      distance(min(latVect),min(lonVect),...
               max(latVect),max(lonVect)))
    toread=1;
  end
end
if (toread>0)
  disp('connecting to google earth servers...');
  [lonVect, latVect, imag]=plot_google_map('maptype','satellite');
  save('googleearth.mat','lonVect','latVect','imag');
end

% google earth background
set(gca,'ylim',[mlat1 mlat2]);
set(gca,'xlim',[mlon1 mlon2]);
h=image(lonVect,latVect,imag);
uistack(h,'bottom'); 
xlabel('Longitude')
ylabel('Latitude')
prettify(gca); 
set(gca,'box','off')

a2 = axes('YAxisLocation', 'Right','xaxislocation','top','position',[0.12 0.12 .8 .75]);
set(a2,'color','none'); 
set(a2,'xlim',[0 distance(mlat1,mlon1,mlat1,mlon2)*pi()*6371/180])
set(a2,'ylim',[0 distance(mlat1,mlon1,mlat2,mlon1)*pi()*6371/180])
pbaspect(daspect)
xlabel(a2,'Distance (km)')
ylabel(a2,'Distance (km)')
prettify(a2)
set(a2,'box','off')

leg=['\bf{Dense Network}' newline ...
     '$40\% \leq Freq < 60\%$' newline ...
     '$60\% \leq Freq < 80\%$' newline ...
     '$80\% \leq Freq $' newline ];

annotation('textbox',[0.253 0.727 0.18 0.14],'string','', ...
           'backgroundcolor',[1 1 1],'edgecolor',[0 0 0],...
           'fitboxtotext','off','interpreter','latex');

annotation('ellipse',[0.263 0.805 0.014 0.017],'facecolor',[1 0 0],'edgecolor',[0 0 0]);
annotation('ellipse',[0.263 0.775 0.014 0.017],'facecolor',[1 1 0],'edgecolor',[0 0 0]);
annotation('ellipse',[0.263 0.745 0.014 0.017],'facecolor',[0 1 0],'edgecolor',[0 0 0]);

annotation('textbox',[0.273 0.7 0.45 0.28],'string', leg, 'fontsize',11,...
             'linestyle','none',...
             'horizontalalignment','left','verticalalignment','bottom',...
             'interpreter','latex');

figname='figs/figure1_map_gnss';
print([figname '.png'],'-dpng',['-r' num2str(dpi)]);
print([figname '.eps'],'-depsc2');
saveas(gca,[figname '.fig'],'fig');

% end-of-script