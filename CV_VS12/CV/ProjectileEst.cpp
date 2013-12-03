#include <string>
#include <list>
#include <tuple>
#include <time.h>
#include <opencv2/opencv.hpp>
#include "config.h"

using namespace std;
using namespace cv;

struct VectorXYZT {
	float x;
	float y;
	float z;
	float time;

	VectorXYZT(float x, float y, float z, float time): x(x), y(y), z(z), time(time) { }
};

//tuple <data, sec>
//return: [p,p_dot]
static Mat QFit(deque<tuple<float, float>> &data)
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
static Mat LinFit(deque<tuple<float, float>> &data)
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

// SVD for Ax = b
//tuple <data, sec>
//return: [a0,a1,a2,a3] for a0 + a1*t + a2*t*t + a3*t*t*t = q
static Mat FitUsingSVD(deque<tuple<float, float>> &data) {
	//TODO: use q,qdot,qdotdot instead of q,qdot??
	if(data.size() < 3)
		return Mat();

	Mat A = Mat(data.size() * 2, 4, CV_32FC1);
	Mat b = Mat(data.size() * 2, 1, CV_32FC1);
	Mat u, vt, w, ut, v;
	for (int i = 0; i < (int)data.size() - 1; i++)
	{
		float t1 = get<1>(data.at(i));
		float t2 = t1 * t1;
		float t3 = t2 * t1;

		A.at<float>(i*2, 0) = 1;
		A.at<float>(i*2, 1) = t1;
		A.at<float>(i*2, 2) = t2;
		A.at<float>(i*2, 3) = t3;

		A.at<float>(i*2+1, 0) = 0;
		A.at<float>(i*2+1, 1) = 1;
		A.at<float>(i*2+1, 2) = 2 * t1;
		A.at<float>(i*2+1, 3) = 3 * t2;

		b.at<float>(i*2, 0) = get<0>(data.at(i));
		b.at<float>(i*2+1, 0) = (get<0>(data.at(i+1)) - get<0>(data.at(i))) / (get<1>(data.at(i+1)) - get<1>(data.at(i)));
	}
	SVD::compute(A, w, u, vt, SVD::MODIFY_A);
	transpose(u, ut);
	transpose(vt, v);
	Mat bp = ut * b;
	Mat y = Mat(4, 1, CV_32FC1);
	//TODO: use element wise division function from opencv
	for (int i = 0; i < 4; i++)
	{
		y.at<float>(i, 0) = bp.at<float>(i, 0) / w.at<float>(i, 0);
	}
	Mat x = v * y;
	return x;
}

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
		deque<Point3f> nextPoints;
		float error = estimateNext(1, Rect(), nextPoints);
		nextPoint = nextPoints.front();

		return error;
	}

	float estimateNext(int numPoints, Rect limit, deque<Point3f> &nextPoints) {
		bool terminate = false;
		nextPoints = deque<Point3f>();
		Point3f position;
		Point3f velocity;
		Point3f acceleration;
		float error = getVectors(position, velocity, acceleration);
		for(int i = 0; i < numPoints; i++) {
			Point3f nextPoint;
			nextPoint = position + velocity + 0.5 * acceleration;
			nextPoints.push_back(nextPoint);

			position = nextPoint;
			velocity = velocity + acceleration;

			if(nextPoint.x < limit.x || nextPoint.y < limit.y || nextPoint.x > (limit.x + limit.width) || nextPoint.y > (limit.y + limit.height))
				break;
		}

		return error;
	}

	float estimateNextAll(Point3f &nextPoint) {
		Point3f position;
		Point3f velocity;
		Point3f acceleration;
		float error = getVectorsAll(position, velocity, acceleration);

		nextPoint.x = position.x + velocity.x + 0.5 * acceleration.x;
		nextPoint.y = position.y + velocity.y + 0.5 * acceleration.y;
		nextPoint.z = position.z + velocity.z + 0.5 * acceleration.z;

		return error;
	}

	float getVectorsAll(Point3f &position_out, Point3f &velocity_out, Point3f &acceleration_out) {
		if(_points.size() == 0)
			return 0;
		Point3f position = Point3f(0,0,0);
		Point3f velocity = Point3f(0,0,0);
		Point3f acceleration = Point3f(0,0,0);

		deque<tuple<float,float>> positionX;
		deque<tuple<float,float>> positionY;
		deque<tuple<float,float>> positionZ;

		for(deque<VectorXYZT>::iterator iter = _points.begin(); iter != _points.end(); ++iter) {
			positionX.push_front(make_tuple((*iter).x, (*iter).time));
			positionY.push_front(make_tuple((*iter).y, (*iter).time));
			positionZ.push_front(make_tuple((*iter).z, (*iter).time));
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
		acceleration_out = acceleration;

		//TODO: debug/fix and use this instead
		if(false) {
			Mat ax = FitUsingSVD(positionX);
			Mat ay = FitUsingSVD(positionY);
			Mat az = FitUsingSVD(positionZ);
			if(ax.rows == 0)
				return 0;

			float time1 = _points.at(0).time;
			float time2 = time1 * time1;
			float time3 = time2 * time1;

			float a0 = ax.at<float>(0, 0);
			float a1 = ax.at<float>(1, 0);
			float a2 = ax.at<float>(2, 0);
			float a3 = ax.at<float>(3, 0);
			position.x = a0 + a1 * time1 + a2 * time2 + a3 * time3;
			velocity.x = a1 + 2 * a2 * time1 + 3 * a3 * time2;
			acceleration.x = 2 * a2 + 6 * a3 * time1;

			a0 = ay.at<float>(0, 0);
			a1 = ay.at<float>(1, 0);
			a2 = ay.at<float>(2, 0);
			a3 = ay.at<float>(3, 0);
			position.y = a0 + a1 * time1 + a2 * time2 + a3 * time3;
			velocity.y = a1 + 2 * a2 * time1 + 3 * a3 * time2;
			acceleration.y = 2 * a2 + 6 * a3 * time1;

			a0 = az.at<float>(0, 0);
			a1 = az.at<float>(1, 0);
			a2 = az.at<float>(2, 0);
			a3 = az.at<float>(3, 0);
			position.z = a0 + a1 * time1 + a2 * time2 + a3 * time3;
			velocity.z = a1 + 2 * a2 * time1 + 3 * a3 * time2;	
			acceleration.z = 2 * a2 + 6 * a3 * time1;

			position_out = position;
			velocity_out = velocity;
			acceleration_out = acceleration;
		}

		return 1;
	}

	// only using last three points
	float getVectors(Point3f &position_out, Point3f &velocity_out, Point3f &acceleration_out) {
		//TODO: use time (or frames) as dt while calculating vectors??
		if(_points.size() == 0)
			return 0;
		Point3f position = Point3f(0,0,0);
		Point3f velocity = Point3f(0,0,0);
		Point3f acceleration = Point3f(0,0,0);

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

		//TODO: debug/fix and use this instead
		if(true){
			deque<Point3f> vels;
			vels.clear();
			deque<Point3f> accels;
			accels.clear();
			Point3f accelAvg = Point3f(0,0,0); 
			float divFactor = 1;
			for(int i = 0; i < (int)_points.size() - 1; i++)
				vels.push_back(Point3f(_points.at(i).x - _points.at(i+1).x, _points.at(i).y - _points.at(i+1).y, _points.at(i).z - _points.at(i+1).z));
			for(int i = 0; i < (int)vels.size() - 1; i++) {
				Point3f acc = Point3f(vels.at(i).x - vels.at(i+1).x, vels.at(i).y - vels.at(i+1).y, vels.at(i).z - vels.at(i+1).z);
				accels.push_back(acc);
				accelAvg += acc * ((int)vels.size() - i);
				divFactor += ((int)vels.size() - i);
			}
			if(accels.size() != 0)
				//accelAvg = accelAvg * (float)(1.0 / ((int)vels.size() - 1));
					accelAvg = accelAvg * (float)(1.0 / divFactor);

			if(_points.size() == 0)
				position_out = Point3f(_points.at(0).x, _points.at(0).y, _points.at(0).z);
			if(vels.size() != 0)
				velocity_out = vels.front();
			if(accels.size() != 0)
				acceleration_out = accelAvg;
		}

		float error = sqrtf(((acceleration.x - acceleration_out.x) * (acceleration.x - acceleration_out.x)
			+ (acceleration.y - acceleration_out.y) * (acceleration.y - acceleration_out.y) 
			+ (acceleration.z - acceleration_out.z) * (acceleration.z - acceleration_out.z))/3);

		return error;
	}

	void invalidatePoints() {
		_points.clear();
	}
};