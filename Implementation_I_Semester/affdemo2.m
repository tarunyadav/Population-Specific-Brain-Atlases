function [posinit]= affdemo2(filename,corners)

datapath='images';

  % read image
  %iptsetpref('ImshowAxesVisible','on');
  f1=il_rgb2gray(double(dicomread(sprintf('%s/%s',datapath,filename))));
  %f1 = edge(f2,'canny',.17);
  %f1 = edge(f2,'sobel');
  [ysize,xsize]=size(f1);
  %showgrey(f1)

  % set up parameters for point detection
  nptsmax=corners;   % max number of detected points (sorted by their strength values)
  kparam=0.04;  % constant for Harris corners
  pointtype=3;  % type of interest points, 1: Harris; 2: Laplace; 3: det(Hessian)
  sxl2=4;       % detection scales (variance)
  sxi2=2*sxl2;  % integration scale

  % detect points
  [posinit,valinit]=intpointdet(f1,kparam,sxl2,sxi2,pointtype,nptsmax);

  
%-------------------------------------------------------------Code for detecting finer feature points------------------------------------------------------
  % display detected points as ellipses
  %figure(gcf), clf
  
  %showgrey(f1), hold on
  %showellipticfeatures(posinit,[1 0 1]);
  
  %title('initial detection and shape estimate')
%   disp('press a key ...')
%   pause
% 
%   % set up parameters for adaptation
%   a1=1; a2=1; a3=1;
%   adaptflag=[a1 a2 a3]; % a1: adapt scale; a2: adapt shape; a3: adapt position 
%   sxstep=0.25;          % scale-increment factor  
%   maxiter=30;           % max. number of interations
%   sxmax=256;            % max spatial scale
%   displayflag=1         % 1: show adaptation process; 0: resume 
% 
%   % adapt points w.r.t. scale, shape and position
%   posall={};
%   valall={};
%   posevolall={};
%   for i=1:size(posinit,1)
%     disp(sprintf('point %d of %d',i,size(posinit,1)))
%     posinit(i,:)
%     [pos,posevol,val]=adaptintpointaffine(f1,posinit(i,:),pointtype,sxstep,maxiter,adaptflag,sxmax,displayflag);
%     posall{i}=pos;
%     valall{i}=val;
%     posevolall{i}=posevol;
%   end
% 
%   % select converged points
%   posallarray=[];
%   valallarray=[];
%   convflag=zeros(1,length(posall));
%   for i=1:length(posall)
%     if length(posall{i})>0
%       posallarray=[posallarray; posall{i}];
%       valallarray=[valallarray; valall{i}];
%       convflag(i)=1;
%     end
%   end
%   disp(sprintf('\nOverall convergence rate: %2.1f%%',100*sum(convflag)/length(convflag)))
% 
%   if 1 % show results
%     figure(gcf)
%     clf, showgrey(f1)
%     showellipticfeatures(posallarray);
%     title('result of scale and shape adaptation')
%     pause(0.1)
%   end
%---------------------------------------------------------------------------------------------------------------------------------------------------
  
end
