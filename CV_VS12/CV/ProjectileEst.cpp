#include <string>
#include <list>
#include <tuple>
#include <time.h>
#include <opencv2/opencv.hpp>
#include "config.h"

using namespace std;
using namespace cv;

//tuple <data, sec>
//return: [p,p_dot]
static Mat QFit(deque<tuple<float, float>> data)
{
	Mat A = Mat(2, 2, CV_32FC1);
	Mat b = Mat(2, 1, CV_32FC1);

	float sumTi = 0;
	float sumTiSq = 0;
	float sumTiCub = 0;
	float sumDat = 0;
	float sumDatTi = 0;
	for(deque<tuple<float, float>>::iterator j=data.begin(); j!=data.end(); ++j) {
		float data = get<0>(*j);
		float sec = get<1>(*j);
		sumTi += sec;
		sumTiSq += sec * sec;
		sumTiCub += sec * sec * sec;
		sumDat += data;
		sumDatTi += sec * data;
	}

	A.at<float>(0,0) = data.size();
	A.at<float>(0,1) = sumTi;
	A.at<float>(1,0) = sumTi;
	A.at<float>(1,1) = sumTiSq;

	b.at<float>(0) = sumDat - _g_ / 2 * sumTiSq;
	b.at<float>(1) = sumDatTi - _g_ / 2 * sumTiCub;

	Mat pMat = A.inv() * b;
	return pMat;
}

//tuple <data, sec>
//return: [p,p_dot]
static Mat LinFit(deque<tuple<float, float>> data)
{
	Mat A = Mat(2, 2, CV_32FC1);
	Mat b = Mat(2, 1, CV_32FC1);

	float sumTi = 0;
	float sumTiSq = 0;
	float sumDat = 0;
	float sumDatTi = 0;
	for(deque<tuple<float, float>>::iterator j=data.begin(); j!=data.end(); ++j) {
		float data = get<0>(*j);
		float sec = get<1>(*j);
		sumTi += sec;
		sumTiSq += sec * sec;
		sumDat += data;
		sumDatTi += sec * data;
	}

	A.at<float>(0,0) = data.size();
	A.at<float>(0,1) = sumTi;
	A.at<float>(1,0) = sumTi;
	A.at<float>(1,1) = sumTiSq;

	b.at<float>(0) = sumDat;
	b.at<float>(1) = sumDatTi;

	Mat pMat = A.inv() * b;
	return pMat;
}

struct VectorXYZT {
	float x;
	float y;
	float z;
	float time;

	VectorXYZT(float x, float y, float z, float time): x(x), y(y), z(z), time(time) { }
};

class ProjectileEst {
	int _maxHistory;
	deque<VectorXYZT> _points;
	clock_t _baseTime;
	float debug_time;

	// TODO: implement as a circular queue
	//vector<Point3f> points;			
	//int head;
	//int tail;

	void init(int maxHistoryPoints) {
		_maxHistory = maxHistoryPoints;
		debug_time = 0;
		//points.reserve = maxHistory;
		//head = 0;
		//tail = 0;
	}

public:
	ProjectileEst() {
		init(10);
	}
	ProjectileEst(int maxHistoryPoints) {
		init(maxHistoryPoints);
	}

	void addPoint(Point3f &point) {
		clock_t time = clock();
		if(_points.size() == 0)
			_baseTime = time;
		float time_ms = debug_time++;//(_baseTime - time) / (double)(CLOCKS_PER_SEC / 1000);

		_points.push_front(VectorXYZT(point.x, point.y, point.z, time_ms));
		if(_points.size() > 10)
			_points.pop_back();
	}

	float estimateNext(Point3f &nextPoint) {
		Point3f position;
		Point3f velocity;
		Point3f acceleration;
		getVectors(position, velocity, acceleration);

		nextPoint.x = position.x + velocity.x + acceleration.x;
		nextPoint.y = position.y + velocity.y + acceleration.y;
		nextPoint.z = position.z + velocity.z + acceleration.z;

		//TODO: calculate confidence
		return 1;
	}

	float estimateNextAll(Point3f &nextPoint) {
		Point3f position;
		Point3f velocity;
		getVectors(position, velocity);

		nextPoint.x = position.x + velocity.x;
		nextPoint.y = position.y + velocity.y;
		nextPoint.z = position.z + velocity.z;

		//TODO: calculate confidence
		return 1;
	}

	void getVectors(Point3f &position_out, Point3f &velocity_out) {
		if(_points.size() == 0)
			return;
		Point3f position = Point3f(0,0,0);
		Point3f velocity = Point3f(0,0,0);

		deque<tuple<float,float>> positionX;
		deque<tuple<float,float>> positionY;
		deque<tuple<float,float>> positionZ;

		for(deque<VectorXYZT>::iterator iter = _points.begin(); iter != _points.end(); ++iter) {
			positionX.push_back(make_tuple((*iter).x, (*iter).time));
			positionY.push_back(make_tuple((*iter).y, (*iter).time));
			positionZ.push_back(make_tuple((*iter).z, (*iter).time));
		}

		Mat xvect = LinFit(positionX);
		Mat yvect = QFit(positionY);
		Mat zvect = LinFit(positionZ);

		position.x = xvect.at<float>(0, 0);
		position.y = yvect.at<float>(0, 0);
		position.z = zvect.at<float>(0, 0);
		velocity.x = xvect.at<float>(1, 0);
		velocity.y = yvect.at<float>(1, 0);
		velocity.z = zvect.at<float>(1, 0);

		position_out = position;
		velocity_out = velocity;
	}

	void getVectors(Point3f &position_out, Point3f &velocity_out, Point3f &acceleration_out) {
		//TODO: use time (or frames) as dt while calculating vectors??
		//TODO: use all points to calculate trajectory and then calculate vectors using trajectory
		if(_points.size() == 0)
			return;
		Point3f position = Point3f(0,0,0);
		Point3f velocity = Point3f(0,0,0);
		Point3f acceleration = Point3f(0,0,0);

		// temp: considering last three points
		if(_points.size() >= 1) {
			position = Point3f(_points.at(0).x, _points.at(0).y, _points.at(0).z);
		}
		if(_points.size() >= 2) {
			velocity.x = _points.at(0).x - _points.at(1).x;		//TODO: optimize
			velocity.y = _points.at(0).y - _points.at(1).y;
			velocity.z = _points.at(0).z - _points.at(1).z;
		}
		if(_points.size() >= 3) {
			float dx01 = _points.at(0).x - _points.at(1).x;
			float dx12 = _points.at(1).x - _points.at(2).x;
			float dy01 = _points.at(0).y - _points.at(1).y;
			float dy12 = _points.at(1).y - _points.at(2).y;
			float dz01 = _points.at(0).z - _points.at(1).z;
			float dz12 = _points.at(1).z - _points.at(2).z;

			acceleration.x = dx01 - dx12;
			acceleration.y = dy01 - dy12;
			acceleration.z = dz01 - dz12;
		}

		position_out = position;
		velocity_out = velocity;
		acceleration_out = acceleration;
	}

	void invalidatePoints() {
		_points.clear();
	}
};