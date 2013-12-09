#include <opencv2/opencv.hpp>
#include "config.h"

using namespace cv;
using namespace std;

void scalarFilter(const Mat &src, Mat &dst, const Scalar &lower, const Scalar &higher,  bool flip, Rect &regionToSearch) {
	Range r1 = Range(MIN(src.rows, regionToSearch.y), MIN(src.rows, regionToSearch.height + regionToSearch.y));
	Range r2 = Range(MIN(src.cols, regionToSearch.x), MIN(src.cols, regionToSearch.width + regionToSearch.x));
	Mat searchArea = src(r1,r2);

	blur(searchArea, searchArea, Size(3, 3));

	/// orange if BGR to HSV: Scalar(0,120,120), Scalar(30,255,255)
	/// orange if RGB to HSV: Scalar(115,120,120), Scalar(125,255,255)
	inRange(searchArea, lower, higher, searchArea);

	erode(searchArea, searchArea, Mat(), Point(-1,-1), 2);
	dilate(searchArea, searchArea, Mat(), Point(-1,-1), 2);
	if(flip)
		bitwise_xor(searchArea, Scalar(255, 0, 0, 0), searchArea, NULL);

	//Always keep output image 480 x 640
	Mat tmp = src;
	tmp(r1,r2) = searchArea;

	//	imshow("ReplacedImage",tmp);
	dst = tmp;
}
