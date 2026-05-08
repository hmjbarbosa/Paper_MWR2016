function [BETA,R,J,COVB,MSE,ERRORMODELINFO] = nlinfitwxy(X,Y,XE,YE,MODEL,BETA0,dontdisp)
%NLINFITWXY Nonlinear least-square regression with errors in X and Y
%   performed using the MATLAB function NLINFIT() and propagating
%   ERRX into ERRY. 
%
%   By default, NLINFIT can only consider measurement errors in the
%   dependent variable (ERRY). For that, you should give them the
%   usual weights (in statistical sense):
%
%       W=1./ERRY.^2;
%       BETA=NLINFIT(X, Y, MODEL, BETA0, 'weights',W);
%
%   BETA0 is a vector containing initial values for the coefficients.
%   There is no automatic way to consider the dependent variable's
%   measurement error, ERRX. This can be done using the derivative of
%   the MODEL function, which we compute as:
%
%      EPS=1e-6*min(diff(unique(sort(X))));
%      deriv=@(beta,x) (MODEL(beta,x+EPS)-MODEL(beta,x-EPS))/(2*EPS);
%
%   where we use the smallest distance between X values * 1e-6 as the
%   EPS to calculate the derivative at each point:
%
%       deriv(beta, X)
%
%   and we can translate ERRX into something like ERRY doing
%
%       ERRX.*deriv(beta,X)
%
%   Which can then be combined with ERRY, assuming they are
%   independent: 
%
%       TotErrSquared = ERRY.^2 + (ERRX.*deriv(beta,X)).^2
%       W = 1./TotErrSquared
%
%   Since our estimate of the Total Squared Error depends on the
%   derivative which in turns depend on the parameters of the function
%   to be fitted, we need a convergence loop! First estimate is done
%   with BETA0, and the followings with the last BETA calculated. We
%   stop when two consecutive calls to NLINFIT() return the same value
%   of BETA (relative change < 1e-6).
% 
%   The output is the same as NLINFIT() for all the parameters, except
%   ERRORMODELINFO which we extended to include:
%
%      ERRORMODELINFO.NITER     % number of interactions
%      ERRORMODELINFO.EPS       % EPS used in derivative
%      ERRORMODELINFO.W         % final combined weights 
%      ERRORMODELINFO.NPAR      % number of parameters in model
%      ERRORMODELINFO.NDF       % degrees of freedom
%      ERRORMODELINFO.BETAERR   % error in parameters
%      ERRORMODELINFO.BETACONF  % 95% confidence intervals
%      ERRORMODELINFO.MCOR      % correlation matrix
%      ERRORMODELINFO.YPRED     % Y predicted values
%      ERRORMODELINFO.YPREDp95  % plus 95% conf lim for YPRED
%      ERRORMODELINFO.YPREDm95  % minus 95% conf lim for YPRED
%
%   To get all possible output, do:
%
%      [BETA,R,J,COVB,MSE,ERRORMODELINFO] = ...
%          nlinfit(X, Y, XERR, YERR, MODEL, BETA0);
%
%   To get the 95% confidence interval for the parameters:
%
%      BETACONF=nlparci(BETA,R,'COVAR',COVB)
%
%   To get the 95% confidence interval for the prediction of the
%   nonlinear regression:
%
%      [YPRED, DELTA] = nlpredci(MODEL,X,BETA,R,'covar',COVB)
%
%   By: Henrique Barbosa, hbarbosa@if.usp.br
%   2015/oct/19 First version
%   2015/oct/20 Added error estimates and formatted the output
%   2015/oct/21 Fixed the calculation of R-square. 
%               Old: RSQ=1-MSE*NDF/nanvar(sqrt(W).*YPRED);
%               New: RSQ=1-nansum(R.^2)/nansum(W.*(Y-nanmean(Y)).^2);
%
%   See also NLINFIT

EPS=1e-8*min(diff(unique(sort(X))));

deriv=@(beta,x) (MODEL(beta,x+EPS)-MODEL(beta,x-EPS))/(2*EPS);

NITER=0;
while 1

  NITER=NITER+1;
  TE=(YE.^2 + (XE.*deriv(BETA0,X)).^2);
  if any(TE==0)
    error('nlinfitwxy: points with 0 uncertainty are not allowed!');
  end
  W=1./TE;
  
  [BETA,R,J,COVB,MSE,ERRORMODELINFO] = ...
      nlinfit(X, Y, MODEL, BETA0, 'weights',W);

  if all( abs((BETA-BETA0)./BETA0) < 1e-8 )
    break
  else
    BETA0=BETA;
  end
end

% update weights after final BETA was found
W=1./(YE.^2 + (XE.*deriv(BETA0,X)).^2);

% number of model parameters
NPAR=size(J,2);

% number of degrees of freedom
NDF=sum(~isnan(J(:,1)))-NPAR;

% error in parameter estimates
BETAERR=sqrt(diag(COVB/MSE))';

% 95% confidence interval
BETACONF=nlparci(BETA,R,'COVAR',COVB)';

% correlation matrix
MCOR=diag(1./BETAERR)*(COVB/MSE)*diag(1./BETAERR);

% 95% confidence interval for the prediction 
[YPRED, DELTA] = nlpredci(MODEL,X,BETA,R,'covar',COVB,'mse',MSE,'alpha', ...
                         0.05,'predopt','observation','weights',W);
%'errormodelinfo',ERRORMODELINFO);

% R squared (R2)
% old way was wrong!!
%    RSQ=1-MSE*NDF/nanvar(sqrt(W).*YPRED);
% Firstly because denominator should be Y and not YPRED
% Secondly because nanvar divides the sum of the squares by N-1,
% while MSE*NDF is simply the sum of the squares.
RSQ=1-nansum(R.^2)/nansum(W.*(Y-nanmean(Y)).^2);

% R squared adjusted (R2adj)
RSQadj=1-(1-RSQ)*(NDF+NPAR-1)/(NDF-1);

% ==> can only be calculated without NAN
%% Hat matrix
%H=J*inv(J'*J)*J';
%% leverage
%h=diag(H);
%% Cook's distance 
%dcook=R.^2.*h./(1-h).^2/EMI.NDF/MSE;

% save extra output to the user
ERRORMODELINFO.NITER=NITER;
ERRORMODELINFO.EPS=EPS;
ERRORMODELINFO.W=W;
ERRORMODELINFO.NPAR=NPAR;
ERRORMODELINFO.NDF=NDF;
ERRORMODELINFO.BETAERR=BETAERR;
ERRORMODELINFO.BETACONF=BETACONF;
ERRORMODELINFO.MCOR=MCOR;
ERRORMODELINFO.YPRED=YPRED;
ERRORMODELINFO.YPREDp95=YPRED+DELTA;
ERRORMODELINFO.YPREDm95=YPRED-DELTA;
ERRORMODELINFO.RSQ=RSQ;
ERRORMODELINFO.RSQadj=RSQadj;

ERRORMODELINFO.BETA=BETA;
ERRORMODELINFO.R=R;
ERRORMODELINFO.J=J;
ERRORMODELINFO.COVB=COVB;
ERRORMODELINFO.MSE=MSE;

if ~exist('dontdisp','var')
  % display some basic fitting output to the user
  disp('Nonlinear fit with errors in X and Y using model:')
  disp(MODEL)
  disp(sprintf('Number of parameters     \t%d',NPAR))
  disp(sprintf('Mean sq error (MSE)      \t%f',MSE))
  disp(sprintf('Chi2 (MSE*NDF)           \t%f',MSE*NDF))
  disp(sprintf('Degrees of freedom (NDF) \t%d',NDF))
  disp(sprintf('R squared (RSQ)          \t%f',RSQ))
  disp(sprintf('Sum of residuals         \t%g',nansum(R)))
  disp(sprintf('Interactions (NITER)     \t%d',NITER))
  
  disp(' ')
  disp(sprintf('Parameter \tValue    \tUncertainty \t95 confidence'))
  disp([1:length(BETA); BETA; BETAERR; BETACONF]')

  disp('Covariance matrix')
  disp(COVB/MSE)

  disp('Correlation matrix')
  disp(MCOR)
end
%