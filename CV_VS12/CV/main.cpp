#include <opencv2/opencv.hpp>
#include <string>
#include <cmath>
#include <time.h>
#include "ProjectileEst.cpp"
#include "config.h"

using namespace cv;
using namespace std;

extern void scalarFilter(const Mat&, Mat&, const Scalar&, const Scalar&,  bool, Rect&);
extern int detectEllipse(const Mat&, RotatedRect&, int, int, int, Rect&);
extern int getNextImage(Mat&, Mat&, int n=-1);
extern Rect getWindow(Rect, float, float, Rect limit = Rect());

string getString(float f)
{
	stringstream ss (stringstream::in | stringstream::out);
	ss << f;
	return ss.str();
}

bool pause1 = true;
bool profileDetection = false;
int main( int argc, char** argv )
{
	string windowResult1 = "Result1";
	//namedWindow(windowResult1, CV_WINDOW_AUTOSIZE );
	string windowResult2 = "Result2";
	string windowResult3 = "Result3";
	string windowResult4 = "Result4";

	Mat src_bgr, src_dep;
	getNextImage(src_bgr, src_dep, 9);
	ProjectileEst esti;
	RotatedRect eDetect;
	Point3f currPos, nextPos;
	deque<Point3f> nextPositions;
	float nextError = 0, nextErrorAll = 0;
	Rect detectWindow = IMAGE_RECT;

	while(getNextImage(src_bgr, src_dep))
	{
		/// color filter
		Mat cFilter, src_hsv;
		cvtColor(src_bgr, src_hsv, CV_RGB2HSV);

		// DEBUG: display debug image
		//imshow(windowResult2, src_hsv);

		//scalarFilter(src_hsv, cFilter, Scalar(115,120,120), Scalar(125,255,255), false); // - set1
		scalarFilter(src_hsv, cFilter, Scalar(115,90,120), Scalar(150,255,255), false, detectWindow); // - set2

		// DEBUG: display debug image
		//imshow(windowResult3, cFilter);

		/// depth filter
		Mat dFilter;
		scalarFilter(src_dep, dFilter, Scalar(150), Scalar(255), false, detectWindow);

		//TODO: Either store points in world coordinates - estimate position in world and project to camera plane
		//		OR store points in image coordinates - estimate postition in image plane and project to world

		if(detectEllipse(cFilter, eDetect, 150, 7, 7, detectWindow) == 1) {
			/// get current position - acceleration on the Y axis
			Point3f rgbPos;
			rgbPos.x = eDetect.center.x;	//TODO: optimize
			rgbPos.y = eDetect.center.y;



			//TODO - use this for now. get depth images converted in rbg frame using kinect SDK
			//OR - appx by using nearest point in rect defined by obj's current position
			Point3f depPos;
			float MrgbArray[3][3] = CAMERA_MATRIX_RGB;
			float MdepArray[3][3] = CAMERA_MATRIX_DEPTH;
			depPos.x = MdepArray[0][0]*(rgbPos.x-MrgbArray[0][2])/MrgbArray[0][0] + MdepArray[0][2];
			depPos.y = MdepArray[1][1]*(rgbPos.y-MrgbArray[1][2])/MrgbArray[1][1] + MdepArray[1][2];
			depPos.x = MAX(0,MIN(depPos.x,src_dep.cols - 1));
			depPos.y = MAX(0,MIN(depPos.y,src_dep.rows - 1));
			
			//Manual offset which works - need to find a proper conversion from camera matrix
			depPos.x = depPos.x + 10;
			depPos.y = depPos.y - 95;
			//TODO:
			double maxValue = 0;
			Rect windowTemp = getWindow(Rect(depPos.x, depPos.y, eDetect.size.width, eDetect.size.height), 2, 10, IMAGE_RECT);
			Mat mask = Mat::zeros(src_dep.size(), CV_8U);
			Mat roi(mask, windowTemp);
			roi = Scalar(255, 255, 255);
			int maxIdx[2];
			minMaxIdx(src_dep, NULL, &maxValue, NULL, maxIdx, mask);
			currPos.z = (float)maxValue;

			// DEBUG: display xy in dep frame calculated from xy of color image. 
			// Also, the greatest dep val (nearest point) in a given rect
			Mat src_dep_temp = src_dep.clone();
			rectangle(src_dep_temp, windowTemp, Scalar(0,255,0));
			circle(src_dep_temp, Point(depPos.x, depPos.y), 2, Scalar(0,255,0));
			circle(src_dep_temp, Point(maxIdx[1], maxIdx[0]), 2, Scalar(0,255,0));
			imshow(windowResult3, src_dep_temp);

			//TODO: convert coordinates to world - using camera matrix
			currPos.x = (rgbPos.x - MrgbArray[0][2]) * currPos.z / MrgbArray[0][0];
			currPos.y = (rgbPos.y - MrgbArray[1][2]) * currPos.z / MrgbArray[1][1];

			//DEBUG: currPos out
			cout << currPos.x << " " << currPos.y << " " << currPos.z << endl;

			/// estimate the next point - TODO: use world coordinates after conversion
			esti.addPoint(rgbPos);
			nextError = esti.estimateNext(100, IMAGE_RECT, nextPositions);
			nextPos = nextPositions.front();

			// will work only with world coordinates
			//nextErrorAll = esti.estimateNextAll(nextPosAll);

			//TODO: convert estimated point to image plane

			// form a detection window based on the predicted position and the current dims of the object
			if(nextError == 0.0)
				detectWindow = IMAGE_RECT;
			else 
				detectWindow = getWindow(Rect(nextPos.x, nextPos.y, eDetect.size.width, eDetect.size.height), 3, 2*nextError, IMAGE_RECT);

		}
		else {
			esti.invalidatePoints();
			detectWindow = Rect(0,0,640,480);
			eDetect = RotatedRect();
		}

		
		if(profileDetection) {
			//Optimized
			clock_t dt1 = clock();
			cvtColor(src_bgr, src_hsv, CV_RGB2HSV);
			scalarFilter(src_hsv, cFilter, Scalar(115,90,120), Scalar(150,255,255), false);
			scalarFilter(src_dep, dFilter, Scalar(150), Scalar(255), false);
			detectEllipse(cFilter, eDetect, 150, 7, 7, detectWindow);
			dt1 = clock() - dt1;

			//Without optimization
			clock_t dt2 = clock();
			cvtColor(src_bgr, src_hsv, CV_RGB2HSV);
			scalarFilter(src_hsv, cFilter, Scalar(115,90,120), Scalar(150,255,255), false);
			scalarFilter(src_dep, dFilter, Scalar(150), Scalar(255), false);
			detectEllipse(cFilter, eDetect, 150, 7, 7, Rect(0,0,640,480));
			dt2 = clock() - dt2;

			cout << "Time: " << dt1 << "\t" << dt2 << endl;
		}


		/// DEBUG: display detected ellipse - rotated rectangle
		Point2f rect_points[4]; 
		eDetect.points(rect_points);
		for( int j = 0; j < 4; j++ )
			line(src_bgr, rect_points[j], rect_points[(j + 1) % 4], Scalar(255,0,0), 1, 8);
		for(int j = 0; j < nextPositions.size(); j++) {
			circle(src_bgr, Point(nextPositions.at(j).x, nextPositions.at(j).y), 2, Scalar(0,0,255), -1, 8);
		}
		putText(src_bgr, getString(nextError), Point(nextPos.x, nextPos.y), FONT_HERSHEY_PLAIN, 1, Scalar(0,0,255));
		rectangle(src_bgr, detectWindow, Scalar(0,255,0));
		imshow(windowResult1, src_bgr);

		if(pause1)
			waitKey(0);
		else
			waitKey(10);
	}
	return(0);
}