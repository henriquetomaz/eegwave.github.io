function [sl,slf,df,F,CC,D] = cohere_bootstrap_signif_level( x, y, p, nb, varargin )
% COHERE_BOOTSTRAP_SIGNIF_LEVEL - simple bootstrap to estimate
% significance level coherence.
%
% Usage: [sig_lev, sig_lev_f, df, freq ] = cohere_bootstrap_signif_level( ...
%                        x, y, p, nb, VARARGIN )
%
% where x and y are your time series, p is the significance level
% (i.e. 0.95 for a 95% significance level), nb is the number of
% bootstraps to compute.  p defaults to 0.95 and nb defaults to 100.
%
% VARARGIN are the extra arguments to be passed to the matlab cohere
% function.  The cohere function is in the Signal Processing Toolbox, so you
% will need that for this function to work.  Note that the matlab cohere
% function is in the process of being replaced by mscohere.  For
% compatibility, I am using cohere here.  If this function fails, that
% would be a first thing to check.
%
% If the last argument of varargin is not a string, then the string
% 'mean' is added on the end to detrend your data.
%
% Output arguments:
%
% sig_lev is the significance level.  It is computed as the average over all
% frequencies.  sig_lev_f gives the actual significance level computed for
% all frequencies.  df is the approximate number of degrees of freedom that
% this configuration corresponds to. freq are the frequencies at which the
% coherence was calculated.
% 
% This function works by randomizing your original time series to produce
% series that have no correlation and then computing the coherence.  This
% is repeated to get a range of values for the coherence at a frequency.
% The p*100% percential is used to determine the significance level.  
%
% If you don't have a time series and just want the value try
% x=y=rand(N,1), where N is the number of observations you want.
% 
% This method appears to produce values slightly over theoretical value.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 	$Id: cohere_bootstrap_signif_level.m,v 1.2 2005/01/08 02:49:29 dmk Exp $	
%
% Copyright (C) 2004 David M. Kaplan
% Licence: GPL (Gnu Public License)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 3
  p = 0.95;
end

if nargin < 4
  nb = 100;
end

if length(varargin) == 0 | ~isa(varargin{end},'char')
  varargin{end+1} = 'mean';
end

s = length(y);

[D,F]=cohere(x,y,varargin{:});
 
I = unidrnd( s, s, 1 );
[C,F] = cohere( x, y(I), varargin{:} );
CC=[ C(:)'; zeros(nb-1,length(C)) ];

for l = 1:nb-1
  I = unidrnd( s, s, 1 );
  C = cohere( x, y(I), varargin{:} );
  CC(l+1,:) = C(:)';
end

[n,xx]=hist(CC,1000);
n2 = cumsum(n);

slf = zeros(1,size(n2,2));
for k = 1:size(n2,2)
  [nn,ii] = unique( n2(:,k) );
  slf(k) = interp1( nn, xx(ii), nb*p, 'linear', 0 );
end
sl = mean(slf);

df = 2*s/length(F);

if nargout < 4
  clear F
end

if nargout < 3
  clear df
end

if nargout < 2
  clear slf
end
