function [pos,val,cimg,L]=intpointdet(f,kparam,sxl2,sxi2,pointtype,npoints)

%
% [pos,val,cimg,L]=intpointdet(f,kparam,sxl2,sxi2,pointtype)
%
%   detects interest points in 'f' at scale sigma^2=sxl2. Available
%   pointdetectors are of 'pointtype':
%     1: harris (default)
%     2: Laplace: Lxx+Lyy
%     3: det(Hessian): Lxx*Lyy-Lxy^2
%     4: Ridge: (Lxx-Lyy)^2+4Lxy
%     5: Quadrature filters: test version
%        (related ref: "Integrated edge...", U.Koethe, ICCV03)
%   'kparam' is a constant for harris point detector; 'sxi2' is the scale
%   for integration of the second-moment matrix in the neighbourhood of a point.
%   'npoints' is the max number of returned (strongest) interest points.
%   The detected points are reported in pos=[x y sxl2 c11 c12 c22] where
%   x,y,sxl2 are point position and scale (original) and c11 c12 c22 are
%   coefficients of the second-moment (shape) matrix. 'val' is the corresponding
%   strength of interest points. Note that returned points are sorted w.r.t. val.
%   'cimg' is interest point function with maxima corresponding to (x,y).
%    'L' is f*Gauss(var=sxl2)
%
%   Author: Ivan Laptev, 2003
%           Computational Vision and Active Perception Laboratory (CVAP)
%           Dept. of Numerical Analysis and Computer Science
%           KTH, SE-100 44 Stockholm, Sweden
%           laptev@nada.kth.se
%

if nargin<5
  pointtype=1;
end

[ysize, xsize]=size(f);

% compute scale-normalised second order matrix
L=mydiscgaussfft(extend2(f,4,4),sxl2); 

Lx=crop2(filter2(dxmask,L,'same'),4,4)*sxl2^(1/2);
Ly=crop2(filter2(dymask,L,'same'),4,4)*sxl2^(1/2);
Lxm2=Lx.*Lx;
Lym2=Ly.*Ly;
Lxmy=Lx.*Ly;

Lxm2smooth=mydiscgaussfft(Lxm2,sxi2);
Lym2smooth=mydiscgaussfft(Lym2,sxi2);
Lxmysmooth=mydiscgaussfft(Lxmy,sxi2);

if pointtype==1 % harris points  
  detC=(Lxm2smooth.*Lym2smooth)-(Lxmysmooth.^2);
  trace2C=(Lxm2smooth+Lym2smooth).^2;
  
  %kparam=0.04;
  cimg=detC-kparam*trace2C;
end

if pointtype==2 % Lalplace points (Blobs / trace(Hessian) points)
  Lxx=crop2(filter2(dxxmask,L,'same'),4,4)*sxl2;
  Lyy=crop2(filter2(dyymask,L,'same'),4,4)*sxl2;
  cimg=(Lxx+Lyy).^2;
end

if pointtype==3 % det(H) points
  Lxx=crop2(filter2(dxxmask,L,'same'),4,4)*sxl2;
  Lxy=crop2(filter2(dxymask,L,'same'),4,4)*sxl2;
  Lyy=crop2(filter2(dyymask,L,'same'),4,4)*sxl2;
  cimg=abs(Lxx.*Lyy-Lxy.^2);
end

if pointtype==4 % Ridge points
  Lxx=crop2(filter2(dxxmask,L,'same'),4,4)*sxl2;
  Lxy=crop2(filter2(dxymask,L,'same'),4,4)*sxl2;
  Lyy=crop2(filter2(dyymask,L,'same'),4,4)*sxl2;
  cimg=abs((Lxx-Lyy).^2+4*(Lxy.^2));
end

if pointtype==5 % Quadrature filters
  s2=sxl2;
  filtsize=max(3,round(5*sqrt(sxl2)));
  t=-filtsize:filtsize;
  g=exp(-t.^2/(2*s2))/sqrt(2*pi*s2);
  
  f1=g.*(t.^2/s2-1)/s2;
  f2=g.*t/s2;
  f3=g.*(3.0-2.0/3.0*t.*t/s2).*t/sqrt(pi)/sqrt(s2)/s2;
  f4=g.*(1.0-2.0/3.0*t.*t/s2)/sqrt(pi)/sqrt(s2);
  
  e1=convsep(convsep(f,f3,2), g,1);
  e2=convsep(convsep(f,f4,2),-f2,1);
  e3=convsep(convsep(f,f2,2), f4,1);
  e4=convsep(convsep(f, g,2),-f3,1);

  gx = 0.75 * (e1 + e3);
  gy = 0.75 * (e2 + e4);

  hxx=convsep(convsep(f,f1,2), g,1);
  hxy=convsep(convsep(f,f2,2),-f2,1);
  hyy=convsep(convsep(f, g,2), f1,1);

  b11=gx.*gx+hxx.^2;
  b12=gx.*gy+hxy.^2;
  b22=gy.*gy+hyy.^2;

  Ebound=b11+b22;
  Eedge=sqrt((b11-b22).^2+4*b12.^2);
  cimg=-(Ebound-Eedge);
  if 1 % show ennergies
    h=figure;
    subplot(2,2,1), showgrey(f), title('original')
    subplot(2,2,2), showgrey(Ebound), title('Ebound')
    subplot(2,2,3), showgrey(Eedge), title('Eedge')
    subplot(2,2,4), showgrey(cimg), title('Ejunction')
    fprintf(' press key ...\n')
    pause
    close(h)
  end

  
end


% detect maxima
[position, value, anms] = locmax8(cimg);

pos=[];
val=[];
if size(position)>0
  pxall=position(:,2);
  pyall=position(:,1);

  % choose 'npoints' strongest responses
  [sv,si]=sort(-value);
  if nargin<6
    npoints=length(si)
  end
  px=pxall(si(1:min(npoints,length(si))));
  py=pyall(si(1:min(npoints,length(si))));
  val=-sv(1:min(npoints,length(si)));

  % threshold results
  %threshind=find(pv<=-thresh);
  %px=px(threshind);
  %py=py(threshind);

  ind=sub2ind([ysize xsize],py,px);
  c11=Lxm2smooth(ind);
  c12=Lxmysmooth(ind);
  c22=Lym2smooth(ind);

  pos=[px py sxl2*ones(size(px)) c11 c12 c12 c22];

  if 1 % discard points at image boundaries
    bound=2; % 2 pixel boundary
    insideind=find((px>bound).*(px<(xsize-bound)).*(py>bound).*(py<(ysize-bound)));
    pos=pos(insideind,:);
  end
end









