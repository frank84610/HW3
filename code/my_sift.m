function [f,d] = my_sift(I)
%% this function use corner detector from HW2
%% and vl_siftdescriptor (http://www.vlfeat.org/matlab/vl_siftdescriptor.html)
%% to calculate feature locations and descriptors

% cal Hw2 corner detector to get f

% cal d = VL_SIFTDESCRIPTOR(GRAD, d) to get d
% note that I might need to be smoothed
% I_ = vl_imsmooth(im2double(I), sqrt(f(3)^2 - 0.5^2)) ;
% [Ix, Iy] = vl_grad(I_) ;
% mod      = sqrt(Ix.^2 + Iy.^2) ;
% ang      = atan2(Iy,Ix) ;
% grd      = shiftdim(cat(3,mod,ang),2) ;
% grd      = single(grd) ;
% d        = vl_siftdescriptor(grd, f) ;
