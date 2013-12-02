/*******************************************************************
This is a simple MEX file that accepts as inputs an image and the
size of a Gausian filter(two parameters). Then it applies the filter
to the image by calling the OpenCV function cvSmooth and returns the 
filtered image to a matlab variable.
********************************************************************/

#include <opencv/cv.h>
#include <opencv/highgui.h>
#include <opencv2/opencv.hpp>
#include "config.h"

using namespace cv;
using namespace std;

bool debug = false;
int detectEllipse(const Mat &src, RotatedRect &target_out, int grayThresh, int ellipseMinMinorSize, int ellipseMinMajorSize, Rect &regionToSearch) {

	Mat src_gray;
	Mat edges_output;
	vector<vector<Point> > contours;
	vector<Vec4i> hierarchy;

	/// Convert to grayscale (optionally)
	if(src.channels() == 3)
		cvtColor( src, src_gray, CV_BGR2GRAY );
	else
		src_gray = src.clone();

	//Matrix subset of image containing only rectangle search area
	Mat searchArea(src_gray, Range(regionToSearch.y, regionToSearch.height + regionToSearch.y), Range(regionToSearch.x, regionToSearch.width + regionToSearch.x));


	/// Detect edges
	threshold( searchArea, edges_output, grayThresh, 255, THRESH_BINARY );
	
	/// Find contours
	findContours( edges_output, contours, hierarchy, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE, Point(0, 0) ); //CV_RETR_TREE, CV_RETR_CCOMP

	/// Find the rotated rectangles and ellipses for each contour
	vector<RotatedRect> minRect( contours.size() );
	vector<RotatedRect> minEllipse( contours.size() );

	for( int i = 0; i < contours.size(); i++ ) {
		minRect[i] = minAreaRect( Mat(contours[i]) );
		if( min(minRect[i].size.height,minRect[i].size.width) > ellipseMinMinorSize && max(minRect[i].size.height,minRect[i].size.width) > ellipseMinMajorSize ) { 
			minEllipse[i] = fitEllipse( Mat(contours[i]) ); 
		}
	}

	/// Find max rect
	Mat drawing = Mat::zeros( edges_output.size(), CV_8UC3 );
	int maxSizeIndex = -1;
	int tempMaxSize = 0;
	for( int i = 0; i< contours.size(); i++ )
	{
		if(tempMaxSize < minEllipse[i].size.height * minEllipse[i].size.width) {
			tempMaxSize = minEllipse[i].size.height * minEllipse[i].size.width;
			maxSizeIndex = i;
		}

		if(debug) {
			/// debug: draw contours
			drawContours( drawing, contours, i, Scalar(0,0,255), 1, 8, vector<Vec4i>(), 0, Point() );
		}
	}

	if(maxSizeIndex != -1) {
		target_out = minRect[maxSizeIndex];

		
		target_out.center.x = target_out.center.x + regionToSearch.x;
		target_out.center.y = target_out.center.y + regionToSearch.y;

		if(debug) {
			/// debug: draw ellipse
			ellipse( drawing, minEllipse[maxSizeIndex], Scalar(255,0,0), 2, 8 );
			/// debug: draw rotated rectangle
			Point2f rect_points[4]; minRect[maxSizeIndex].points( rect_points );
			for( int j = 0; j < 4; j++ )
				line( drawing, rect_points[j], rect_points[(j+1)%4], Scalar(0,255,0), 1, 8 );
		}
	}

	if(debug) {
		string debug_window = "detectEllipse Debug";
		namedWindow(debug_window, CV_WINDOW_AUTOSIZE );
		imshow(debug_window, drawing);
	}

	if(maxSizeIndex == -1) return 0;
	return 1;
}
