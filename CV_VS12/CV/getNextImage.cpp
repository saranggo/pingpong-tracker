#include <opencv2/opencv.hpp>
#include <string>
#include "config.h"

using namespace cv;
using namespace std;

int getNextImage(Mat &dst_bgr, Mat &dst_dep, int numFrame = -1) {
	static int frameNo;
	if(numFrame != -1)
		frameNo = numFrame;
	else
		frameNo++;

	char path[100];
	sprintf(path, "H:\\Private\\Fall 13\\Project\\image_color\\frame%04d.jpg", frameNo);

#ifdef DBG
	cout << path << endl;
#endif

	dst_bgr = imread(path, 1);
	if(!dst_bgr.data)
		return 0;
	return 1;
}