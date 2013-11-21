#include <opencv2/opencv.hpp>
#include "config.h"

using namespace cv;
using namespace std;

void scalarFilter(const Mat &src, Mat &dst, const Scalar &lower, const Scalar &higher,  bool flip) {
	dst = src.clone();
	if(dst.channels() == 3) {
		cvtColor(dst, dst, CV_RGB2HSV);
	}
	blur(dst, dst, Size(3, 3));

	/// orange if BGR to HSV: Scalar(0,120,120), Scalar(30,255,255)
	/// orange if RGB to HSV: Scalar(115,120,120), Scalar(125,255,255)
	inRange(dst, lower, higher, dst);

	erode(dst, dst, Mat(), Point(-1,-1), 2);
	dilate(dst, dst, Mat(), Point(-1,-1), 2);
	if(flip)
		bitwise_xor(dst, Scalar(255, 0, 0, 0), dst, NULL);
}
