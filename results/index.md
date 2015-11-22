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
1. Matching SIFT Descriptors (SIFTSimpleMatcher.m)

First get the size of descriptors
	
	num1=size(descriptor1,1);
	num2=size(descriptor2,1);
	
Then use a for loop to run through 1 to num1.In the loop, first use `repmat` to get `d1_tmp`, which has same number of rows as descriptor2, with data in every rows are same as row"i" in descriptor1, then calculate the distance by `distance=sqrt(sum((d1_tmp-descriptor2).^2,2))`. And then sort the `distance` , if the smallest value in `distance` is smaller than threshold(here is 0.7)*the next smallest value, save its information into `match` array.

	for i=1:num1
		d1_tmp=repmat(descriptor1(i,:), num2, 1);
		distance=sqrt(sum((d1_tmp-descriptor2).^2,2));
		distance_tmp=sort(distance);
		if distance_tmp(1)<thresh*distance_tmp(2)
		match=[match; i, find(distance==distance_tmp(1))];
		end
	end

2. Fitting the Transformation Matrix (ComputeAffineMatrix.m)

First,convert the input points to homogeneous coordintes.

	P1 = [Pt1';ones(1,N)];
	P2 = [Pt2';ones(1,N)];

Then by using `\`, we can get the transformation matrix `H`.

	H = (P1'\P2')';

3. RANSAC (RANSACFit.m)
	
## Results

<table border=1>
<tr>
<td>
<img src="../data/Hanging1.png" width="30%"/>
<img src="../data/Hanging2.png" width="30%"/>
<img src="../results/Hanging.jpg" width="40%"/>
</td>
</tr>
</table>


<table border=2>
<tr>
<td>
<img src="../data/MelakwaLake1.png" width="30%"/>
<img src="../data/MelakwaLake2.png" width="30%"/>
<img src="../results/MelakwaLake.jpg" width="50%"/>
</td>
</tr>
</table>


<table border=3>
<tr>
<td>
<img src="../data/uttower1.jpg" width="30%"/>
<img src="../data/uttower2.jpg" width="30%"/>
<img src="../results/uttower_pano.jpg" width="50%"/>
</td>
</tr>
</table>


<table border=4>
<tr>
<td>
<img src="../data/yosemite1.jpg" width="40%"/>
<img src="../data/yosemite2.jpg" width="40%"/>
<img src="../data/yosemite3.jpg" width="40%"/>
<img src="../data/yosemite4.jpg" width="40%"/>
<img src="../results/yosemite.jpg" width="100%"/>
</td>
</tr>
</table>


<table border=5>
<tr>
<td>
<img src="../data/Rainier1.png" width="30%"/>
<img src="../data/Rainier2.png" width="30%"/>
<img src="../data/Rainier3.png" width="30%"/>
<img src="../data/Rainier4.png" width="30%"/>
<img src="../data/Rainier5.png" width="30%"/>
<img src="../data/Rainier6.png" width="30%"/>
<img src="../results/Rainier.jpg" width="80%"/>
</td>
</tr>
</table>


<table border=6>
<tr>
<td>
<img src="../data/desktop.jpg" width="30%"/>
<img src="../data/desktop2.jpg" width="30%"/>
<img src="../data/desktop3.jpg" width="30%"/>
<img src="../results/desktop.jpg" width="80%"/>
</td>
</tr>
</table>

<table border=7>
<tr>
<td>
<img src="../data/landscape1.jpg" width="30%"/>
<img src="../data/landscape2.jpg" width="30%"/>
<img src="../data/landscape3.jpg" width="30%"/>
<img src="../data/landscape4.jpg" width="30%"/>
<img src="../data/landscape5.jpg" width="30%"/>
<img src="../data/landscape6.jpg" width="30%"/>
<img src="../data/landscape7.jpg" width="30%"/>
<img src="../results/landscape.jpg" width="100%"/>
</td>
</tr>
</table>
