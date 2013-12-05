#include <opencv2/opencv.hpp>
#include "config.h"

using namespace cv;
using namespace std;

Rect getWindow(Rect original, float multiplier, float offset) {
	Rect newWindow;

	float maxHW = MAX(original.width, original.height);
	newWindow.x = MAX(0, original.x - maxHW * multiplier / 2 - offset);
	newWindow.width = maxHW * multiplier + 2 * offset;
	newWindow.y = MAX(0, original.y - maxHW * multiplier / 2 - offset);
	newWindow.height = maxHW * multiplier + 2 * offset;

	return newWindow;
}
