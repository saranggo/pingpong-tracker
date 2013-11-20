#include <opencv2/opencv.hpp>
#include <string>
#include "ProjectileEst.cpp"
#include "config.h"

using namespace cv;
using namespace std;

extern void colorFilter(const Mat&, Mat&, const Scalar&, const Scalar&,  bool);
extern int detectEllipse(const Mat&, RotatedRect&, int, int, int);
int getNextImage(Mat&, Mat&, int n=-1);

bool pause = true;
int main( int argc, char** argv )
{
	string windowResult1 = "Result1";
	namedWindow(windowResult1, CV_WINDOW_AUTOSIZE );
	//string windowResult2 = "Result2";
	//namedWindow(windowResult2, CV_WINDOW_AUTOSIZE );

	Mat src_bgr, src_dep;
	getNextImage(src_bgr, src_dep, 18);
	ProjectileEst esti;
	while(getNextImage(src_bgr, src_dep))
	{
		/// color filter
		Mat cFilter;
		colorFilter(src_bgr, cFilter, Scalar(115,120,120), Scalar(125,255,255), false);

		/// DEBUG: display color-filtered image
		//imshow(windowResult1, cFilter);

		/// ellipse detection
		RotatedRect eDetect;
		Point3f currPos, nextPos;
		float nextConf = 0;
		if(detectEllipse(cFilter, eDetect, 150, 7, 7) == 1) {
			/// get current position
			currPos.x = eDetect.center.x;	//TODO: optimize
			currPos.y = eDetect.center.y;
			currPos.z = 1;

			/// estimate the next point
			esti.addPoint(currPos);
			nextConf = esti.estimateNext(nextPos);
		}
		else
			esti.invalidatePoints();

		/// DEBUG: display detected ellipse - rotated rectangle
		Point2f rect_points[4]; 
		eDetect.points(rect_points);
		for( int j = 0; j < 4; j++ )
			line(src_bgr, rect_points[j], rect_points[(j + 1) % 4], Scalar(255,0,0), 1, 8);
		if(nextConf == 1)
			circle(src_bgr, Point(nextPos.x, nextPos.y), 2, Scalar(0,0,255), -1, 8);
		imshow(windowResult1, src_bgr);

		if(pause)
			waitKey(0);
		else
			waitKey(10);
	}
	return(0);
}