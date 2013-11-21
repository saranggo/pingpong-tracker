#include <opencv2/opencv.hpp>
#include "config.h"

using namespace cv;
using namespace std;

void scalarFilter(const Mat &src, Mat &dst, const Scalar &lower, const Scalar &higher,  bool flip) {
	Mat imgTemp = src.clone();
	blur(imgTemp, imgTemp, Size(3, 3));

	/// orange if BGR to HSV: Scalar(0,120,120), Scalar(30,255,255)
	/// orange if RGB to HSV: Scalar(115,120,120), Scalar(125,255,255)
	inRange(imgTemp, lower, higher, imgTemp);

	erode(imgTemp, imgTemp, Mat(), Point(-1,-1), 2);
	dilate(imgTemp, imgTemp, Mat(), Point(-1,-1), 2);
	if(flip)
		bitwise_xor(imgTemp, Scalar(255, 0, 0, 0), imgTemp, NULL);

	dst = imgTemp;
}
