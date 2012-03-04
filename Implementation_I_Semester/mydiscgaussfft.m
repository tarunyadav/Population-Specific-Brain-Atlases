function pixels = mydiscgaussfft(inpic, sigma2)

% DISCGAUSSFFT(pic, sigma2) -- Convolves an image by the
% (separable) discrete analogue of the Gaussian kernel by
% performing the convolution in the Fourier domain.
% The parameter SIGMA2 is the variance of the kernel.

% Reference: Lindeberg "Scale-space theory in computer vision", Kluwer, 1994.

%ext=round(4*sqrt(sigma2));
%inpic=extend2(inpic,ext,ext);

%ftransform = fft2(inpic);
ftransform = fft(inpic,[],1);
ftransform = fft(ftransform,[],2);

[xsize ysize] = size(ftransform);
[x y] = meshgrid(0 : xsize-1, 0 : ysize-1);

%pixels = real(ifft2(exp(sigma2 * (cos(2 * pi*(x / xsize)) + cos(2 * pi*(y / ysize)) - 2))' .* ftransform));

pixels = ifft(exp(sigma2 * (cos(2 * pi*(x / xsize)) + cos(2 * pi*(y / ysize)) - 2))' .* ftransform,[],1);
pixels = real(ifft(pixels,[],2));

%pixels=pixels(ext+1:xsize-ext,ext+1:ysize-ext);
