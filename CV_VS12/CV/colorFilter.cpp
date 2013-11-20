#include <opencv2/opencv.hpp>

using namespace cv;
using namespace std;

void colorFilter(const Mat &src, Mat &dst, const Scalar &lower, const Scalar &higher,  bool flip) {
	Mat imgTemp = src.clone();

	// TODO: blur
	/// orange if BGR to HSV: Scalar(0,120,120), Scalar(30,255,255)
	/// orange if RGB to HSV: Scalar(115,120,120), Scalar(125,255,255)
	cvtColor(imgTemp, imgTemp, CV_RGB2HSV);
	blur(imgTemp, imgTemp, Size(3, 3));
	inRange(imgTemp, lower, higher, dst);
	erode(dst, dst, Mat(), Point(-1,-1), 2);
	dilate(dst, dst, Mat(), Point(-1,-1), 2);
	if(flip)
		bitwise_xor(dst, Scalar(255, 0, 0, 0), dst, NULL);
}
