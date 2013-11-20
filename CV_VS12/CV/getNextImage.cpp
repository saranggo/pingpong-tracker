#include <opencv2/opencv.hpp>
#include <string>

using namespace cv;
using namespace std;

int getNextImage(Mat &dst, int numFrame = -1) {
	static int frameNo;
	if(numFrame != -1)
		frameNo = numFrame;
	else
		frameNo++;

	char path[100];
	sprintf(path, "H:\\Private\\Fall 13\\Project\\image_color\\frame%04d.jpg", frameNo);
	dst = imread(path, 1);
	if(!dst.data)
		return 0;
	return 1;
}