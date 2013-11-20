#include <string>
#include <list>
#include <opencv2/opencv.hpp>
#include "config.h"

using namespace std;
using namespace cv;

class ProjectileEst {
	int _maxHistory;
	deque<Point3f> _points;
	Point3f _position;
	Point3f _velocity;
	Point3f _acceleration;
	bool _recalculateVectors;

	// TODO: implement as a circular queue
	//vector<Point3f> points;			
	//int head;
	//int tail;

	void init(int maxHistoryPoints) {
		_maxHistory = maxHistoryPoints;
		_recalculateVectors = true;

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
		_recalculateVectors = true;
		_points.push_front(point);
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

	void getVectors(Point3f &position_out, Point3f &velocity_out, Point3f &acceleration_out) {
		//TODO: use time (or frames) as dt while calculating vectors??
		if(_points.size() == 0)
			return;
		_position = Point3f(0,0,0);
		_velocity = Point3f(0,0,0);
		_acceleration = Point3f(0,0,0);
		
		if(_recalculateVectors) {
			// temp: considering last three points
			if(_points.size() >= 1) {
				_position = _points.at(0);
			}
			if(_points.size() >= 2) {
				_velocity.x = _points.at(0).x - _points.at(1).x;		//TODO: optimize
				_velocity.y = _points.at(0).y - _points.at(1).y;
				_velocity.z = _points.at(0).z - _points.at(1).z;
			}
			if(_points.size() >= 3) {
				float dx01 = _points.at(0).x - _points.at(1).x;
				float dx12 = _points.at(1).x - _points.at(2).x;
				float dy01 = _points.at(0).y - _points.at(1).y;
				float dy12 = _points.at(1).y - _points.at(2).y;
				float dz01 = _points.at(0).z - _points.at(1).z;
				float dz12 = _points.at(1).z - _points.at(2).z;

				_acceleration.x = dx01 - dx12;
				_acceleration.y = dy01 - dy12;
				_acceleration.z = dz01 - dz12;
			}
		}

		position_out = _position;
		velocity_out = _velocity;
		acceleration_out = _acceleration;
		_recalculateVectors = false;
	}

	void invalidatePoints() {
		_points.clear();
	}
};