# 陳冠言 <span style="color:red">(102061243)</span>

# Project 3: Panorama Stitching

## Overview
Panoramic stitching is an early success of computer vision. Matthew Brown and David G. Lowe published a famous [panoramic image stitching paper](http://www.cs.ubc.ca/~lowe/papers/07brown.pdf) in 2007. Since then, automatic panorama stitching technology has been widely adopted in many applications such as Google Street View, panorama photos on smartphones, and stitching software such as [Photosynth](http://photosynth.net/) and [AutoStitch](http://cs.bath.ac.uk/brown/autostitch/autostitch.html).

In this programming assignment, we will match SIFT keypoints from multiple images to build a single panoramic image. This will involve several tasks:

* Detect SIFT points and extract SIFT descriptor for each keypoint in an image using vlfeat, or
  detect Corner points and extract SIFT descriptor (vlfeat).

* Compare two sets of SIFT descriptors coming from two different images and find matching keypoints (`SIFTSimpleMatcher.m`).

* Given a list of matching keypoints, use least-square method to find the affine transformation matrix that maps positions in image 1 to positions in image 2 (`ComputeAffineMatrix.m`).

* Use RANSAC to give a more robust estimate of affine transformation matrix (`RANSACFit.m`).

* Given that transformation matrix, use it to transform (shift, scale, or skew) image 1 and overlay it on top of image 2, forming a panorama. 

* Stitch multiple images together under a simplified case of real-world scenario ('MultipleStitch.m').

## Implementation
First set the parameters for corner detection and the filters for image filtering, dx is the gradient filter for x-axis, dy is the gradient filter for y-axis, and g is the gaussian filter
	
    	sigma=2;
    	n_x_sigma = 6;
    	alpha = 0.04;
    	Thrshold=20;  
    	r=6; 
	
    	dx = [-1 0 1; -1 0 1; -1 0 1];
    	dy = dx'; 
    	g = fspecial('gaussian',max(1,fix(2*n_x_sigma*sigma)), sigma);
    		
Then load the original picture and change it into grayscale

<img src="../data/Im.jpg" width="50%"/>
    	
    	frame = imread('data/Im.jpg');
    	I = double(frame);
    	I_gray = I(:,:,1)* 0.299+I(:,:,2)* 0.587+I(:,:,1)* 0.114;
    		
Calculate Ix and Iy by using function `imfilter` and filter `dx`, `dy`
    	
    	Ix=imfilter(I_gray, dx);
    	Iy=imfilter(I_gray, dy);
    	
Get the components of second moment matrix      
### M = [[Ix2 Ixy];[Iyx Iy2]]
Because that Ix2,Iy2,Ixy should be Gaussian smoothed, so use the function `imfilter` again with the gaussian filter after calculation
    	
    	Ix2=imfilter((Ix.*Ix),g);
    	Iy2=imfilter((Iy.*Iy),g);
    	Ixy=imfilter((Ix.*Iy),g);

By using `imagesc`, we can see Ixy

<img src="../results/Ixy.jpg"  width="50%"/>
	
Then get the corner response function 
### R = det(M)-alpha*trace(M)^2
And map it to 0~1000

    	R = (Ix2.*Iy2-Ixy.^2)-alpha*((Ix2+Iy2).^2) ;
    	R=(1000/max(max(R)))*R;
    	
Then use the function `ordfilt2` to complment a maxfilter, here the function B = ordfilt2(A,order,domain) will replace each element in A by the "order"th element in the sorted set of neighbors specified by the nonzero elements in domain.
Because we want to implement a maxfilter, so we replace each element by the biggest orderth "sze^2" in the domain sze*sze

	MX=ordfilt2(R,sze^2,ones(sze));
	
Then we want to find the corner in the original picture, the corner will be the local max that bigger than threshold in R, so we find local max points by (R==MX) and find the points that bigger than threshold by (R>Thrshold), combine them together will get RBinary

	RBinary=(R==MX) & (R>Thrshold);

And by the information of RBinary, we can plot the corners on the original figure, finally get the corner detected picture

<img src="../results/corner1.jpg" width="50%"/>


## Installation
1. Download and unpack [VLFeat binary package](http://www.vlfeat.org/download.html)

2. Enter `run('VLFEATROOT/toolbox/vl_setup')` in MATLAB command line

3. Download the code and open `StitchTester.m` ,set the input image `('../data/yosemite*.jpg') ` and output path `'../results/yosemite.jpg'`then run the code .
	
## Results

###House
<table border=1>
<tr>
<td>
<img src="../data/Im.jpg" width="40%"/>
<img src="../results/Ixy.jpg"  width="40%"/>
<img src="../results/corner1.jpg" width="70%"/>
</td>
</tr>
</table>

###Chessboard
<table border=2>
<tr>
<td>
<img src="../data/chessboard.jpg" width="40%"/>
<img src="../results/Ixy2.jpg"  width="40%"/>
<img src="../results/corner2.jpg" width="70%"/>
</td>
</tr>
</table>

###Taipei 101
<table border=3>
<tr>
<td>
<img src="../data/101.jpg" width="30%"/>
<img src="../results/Ixy3.jpg"  width="30%"/>
<img src="../results/corner3.jpg" width="50%"/>
</td>
</tr>
</table>

###Tennis Racquet
<table border=4>
<tr>
<td>
<img src="../data/Racquet.JPG" width="40%"/>
<img src="../results/Ixy4.jpg"  width="40%"/>
<img src="../results/corner4.jpg" width="70%"/>
</td>
</tr>
</table>
