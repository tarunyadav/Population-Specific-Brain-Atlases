function result=convsep(f,filt,dim)

%
% result=convsep(f,filt,dim)
%
%  Separable convolution of n-dimensional signal 'f'
%  with filter 'filt' along dimension 'dim'
%

fshift=shiftdim(f,dim-1);
result=conv2(fshift(:),filt(:),'same');
result=shiftdim(reshape(result,size(fshift)),ndims(f)-(dim-1));
