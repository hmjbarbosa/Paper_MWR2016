%
clear all
%close all

% standard deviation of series 1
mean1=10;
std1=1;

% standard deviation of series 2
mean2=20;
std2=2;

% correlation
cor12=0.3;

% covariance matrix
cov12=[std1^2, cor12*std1*std2; cor12*std1*std2, std2^2];

for i=1:100
  r=mvnrnd([mean1,mean2],cov12,100);
  mycor(i)=corr(r(:,1),r(:,2));
end

figure(1)
plot(r)

figure(2)
plot(r(:,1),r(:,2),'*')

figure(3)
plot(mycor)
mean(mycor)
std(mycor)

%