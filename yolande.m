%close all
%clear all
%load all_stations_final_data_set_int_2011

ntime=length(y2011.jd);
nstation=y2011.nstation;

wlag=6;

widt=18;

figure(1)
% for each pair of stations
for st1=1:1%nstation-1
  for st2=20:20%st1+1:2%nstation
    
    % for each time period in 2011
    for t=37050:ntime-50
      data1=y2011.pwv(t-wlag:t+wlag,st1);
      %clf; plot(data1,'b'); hold on
      
      for lag=-widt:widt
        data2=y2011.pwv(t-wlag+lag:t+wlag+lag,st2);
        %p=plot(data2,'c');
        %if (lag==0)
        %  plot(data2,'r')
        %end
        
        correlat(st1,st2,t,lag+100)=corr(data1,data2);

        %correlat(st1,st2,t,lag+100)
        %ginput(1);
        %delete(p)
      end
      
      [Y,I]=max(correlat(st1,st2,t,100-widt:100+widt));
      lag=I-widt+1;
      maxcorr(st1, st2, t) = lag;
      
      %plot(y2011.pwv(t-wlag+lag:t+wlag+lag,st2),'g')
      
%      return
    end
    return
  end
end
%
