#include <opencv2/opencv.hpp>
#include <string>
#include "config.h"

using namespace cv;
using namespace std;

int getNextImageTest(Mat &dst_bgr, Mat &dst_dep, int numFrame = -1) {
	static int frameNo;
	if(numFrame != -1)
		frameNo = numFrame;
	else
		frameNo++;

	ostringstream pathBGRStream;
	pathBGRStream << IMG_PATH << "\\rgb\\" << frameNo << ".jpg";
	string pathBGR = pathBGRStream.str();

	ostringstream pathDepthStream;
	pathDepthStream << IMG_PATH << "\\depth\\" << frameNo << ".jpg";
	string pathDepth = pathDepthStream.str();

#ifdef DBG
	cout << frameNo << endl;
#endif

	dst_bgr = imread(pathBGR, 1);
	dst_dep = imread(pathDepth, 1);
	if(!dst_bgr.data)
		return 0;
	return 1;
}

int getNextImageCam(Mat &dst_bgr, Mat &dst_dep) {
	return 0;
}

int getNextImage(Mat &dst_bgr, Mat &dst_dep, int numFrame = -1) {
#ifdef USE_TEST_IMAGES
	return getNextImageTest(dst_bgr, dst_dep, numFrame);
#else
	return getNextImageCam(dst_bgr, dst_dep);
#endif
}