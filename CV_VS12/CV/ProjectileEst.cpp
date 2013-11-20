#include <string>
#include <list>
#include <opencv2/opencv.hpp>

using namespace std;
using namespace cv;

class ProjectileEst {
	int _maxHistory;
	deque<Point3f> _points;
	Point3f _nextPoint;
	float _nextPointConf;
	bool _recalculateNextPoint;

	// TODO: implement as a circular queue
	//vector<Point3f> points;			
	//int head;
	//int tail;

	void init(int maxHistoryPoints) {
		_maxHistory = maxHistoryPoints;
		_recalculateNextPoint = true;

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
		_recalculateNextPoint = true;
		_points.push_front(point);
		if(_points.size() > 10)
			_points.pop_back();
	}

	float estimateNext(Point3f &nextPoint) {
		if(_points.size() == 0)
			return 0;
		if(!_recalculateNextPoint) {
			nextPoint = _nextPoint;
			return _nextPointConf;
		}

		// temp: considering last three points
		if(_points.size() == 1) {
			_nextPoint = _points.at(0);
			_nextPointConf = 1;
		}
		else if(_points.size() == 2) {
			_nextPoint.x = _points.at(0).x + _points.at(0).x - _points.at(1).x;		//TODO: optimize
			_nextPoint.y = _points.at(0).y + _points.at(0).y - _points.at(1).y;
			_nextPoint.z = _points.at(0).z + _points.at(0).z - _points.at(1).z;
			_nextPointConf = 1;
		}
		else {
			float dx01 = _points.at(0).x - _points.at(1).x;
			float dx12 = _points.at(1).x - _points.at(2).x;
			float dy01 = _points.at(0).y - _points.at(1).y;
			float dy12 = _points.at(1).y - _points.at(2).y;
			float dz01 = _points.at(0).z - _points.at(1).z;
			float dz12 = _points.at(1).z - _points.at(2).z;

			float dx = dx01 + dx01 - dx12;
			float dy = dy01 + dy01 - dy12;
			float dz = dz01 + dz01 - dz12;

			_nextPoint.x = _points.at(0).x + dx;
			_nextPoint.y = _points.at(0).y + dy;
			_nextPoint.z = _points.at(0).z + dz;
		}

		nextPoint = _nextPoint;
		return _nextPointConf;
	}

	void getVectors(Vec3f &position, Vec3f &velocity, Vec3f &acceleration) {
		// TODO: get positions, velocities and accelerations in the three axes
	}

	void invalidatePoints() {
		_points.clear();
	}
};