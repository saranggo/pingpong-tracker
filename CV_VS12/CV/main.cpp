#include <opencv2/opencv.hpp>
#include <string>
#include <cmath>
#include "ProjectileEst.cpp"
#include "config.h"

using namespace cv;
using namespace std;

extern void scalarFilter(const Mat&, Mat&, const Scalar&, const Scalar&,  bool);
extern int detectEllipse(const Mat&, RotatedRect&, int, int, int, Rect&);
int getNextImage(Mat&, Mat&, int n=-1);

string getString(float f)
{
	stringstream ss (stringstream::in | stringstream::out);
	ss << f;
	return ss.str();
}

bool pause1 = true;
int main( int argc, char** argv )
{
	string windowResult1 = "Result1";
	//namedWindow(windowResult1, CV_WINDOW_AUTOSIZE );
	string windowResult2 = "Result2";
	string windowResult3 = "Result3";
	string windowResult4 = "Result4";
	//namedWindow(windowResult2, CV_WINDOW_AUTOSIZE );
	//Mat rbg2dep = [

	Mat src_bgr, src_dep;
	getNextImage(src_bgr, src_dep, 18);
	ProjectileEst esti;
	while(getNextImage(src_bgr, src_dep))
	{
		/// color filter
		Mat cFilter, src_hsv;
		cvtColor(src_bgr, src_hsv, CV_RGB2HSV);
		scalarFilter(src_hsv, cFilter, Scalar(115,120,120), Scalar(125,255,255), false);

		/// depth filter
		Mat dFilter;
		scalarFilter(src_dep, dFilter, Scalar(150), Scalar(255), false);

		// DEBUG: display filtered image
		//imshow(windowResult1, src_dep);

		/// ellipse detection
		RotatedRect eDetect;
		Point3f currPos, nextPos, nextPosAll;
		float nextError = 0, nextErrorAll = 0;

		//TODO: Either store points in world coordinates - estimate position in world and project to camera plane
		//		OR store points in image coordinates - estimate postition in image plane and project to world

		Rect r = Rect(Point(30,30), Point(600, 400)); //TODO: Replace w/Confidence Rectangle Window

		//TODO: get next estimate with error. form bb for detection
		if(detectEllipse(cFilter, eDetect, 150, 7, 7, r) == 1) {
			/// get current position - acceleration on the Y axis
			Point3f rgbPos;
			rgbPos.x = eDetect.center.x;	//TODO: optimize
			rgbPos.y = eDetect.center.y;



			//DEBUG - use this for now. get depth images converted in rbg frame using kinect SDK
			Point3f depPos;
			float MrgbArray[3][3] = CAMERA_MATRIX_RGB;
			float MdepArray[3][3] = CAMERA_MATRIX_DEPTH;
			depPos.x = MdepArray[0][0]*(rgbPos.x-MrgbArray[0][2])/MrgbArray[0][0] + MdepArray[0][2];
			depPos.y = MdepArray[1][1]*(rgbPos.y-MrgbArray[1][2])/MrgbArray[1][1] + MdepArray[1][2];
			
			/*
			Mat Mrgb = Mat(3, 3, CV_32FC1, MrgbArray);
			Mat Mdep = Mat(3, 3, CV_32FC1, MdepArray);
			Mat MrgbInv = Mrgb.inv();
			Mat Mdep_rgbInv = Mdep * MrgbInv;
			depPos.x = Mdep_rgbInv.at<float>(0, 0) * rgbPos.x + Mdep_rgbInv.at<float>(0, 1) * rgbPos.y + Mdep_rgbInv.at<float>(0, 2) * 1;
			depPos.y = Mdep_rgbInv.at<float>(1, 0) * rgbPos.x + Mdep_rgbInv.at<float>(1, 1) * rgbPos.y + Mdep_rgbInv.at<float>(1, 2) * 1;
			*/

			currPos.x = depPos.x + 10;
			currPos.y = depPos.y - 95;
			currPos.z = src_dep.at<uchar>(depPos.x, depPos.y);




			// DEBUG: display xy from color image to depth image
			circle(src_dep, Point(currPos.x, currPos.y), 2, Scalar(0,0,255), -1, 8);
			imshow(windowResult1, src_dep);

			//TODO: convert coordinates to real world - using camera matrix

			/// estimate the next point
			esti.addPoint(currPos);
			nextError = esti.estimateNext(nextPos);

			// will work only with world coordinates
			//nextErrorAll = esti.estimateNextAll(nextPosAll);

			//TODO: convert estimated point to image plane
		}
		else
			esti.invalidatePoints();

		/// DEBUG: display detected ellipse - rotated rectangle
		Point2f rect_points[4]; 
		eDetect.points(rect_points);
		for( int j = 0; j < 4; j++ )
			line(src_bgr, rect_points[j], rect_points[(j + 1) % 4], Scalar(255,0,0), 1, 8);
		circle(src_bgr, Point(nextPos.x, nextPos.y), 2, Scalar(0,0,255), -1, 8);
		putText(src_bgr, getString(nextError), Point(nextPos.x, nextPos.y), FONT_HERSHEY_PLAIN, 1, Scalar(0,0,255));
		//circle(src_bgr, Point(nextPosAll.x, nextPosAll.y), 2, Scalar(0,255,0), -1, 8);
		imshow(windowResult2, src_bgr);

		if(pause1)
			waitKey(0);
		else
			waitKey(10);
	}
	return(0);
}