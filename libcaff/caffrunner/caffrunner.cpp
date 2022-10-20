#include "libcaff.h"

#include <iostream>

int main(int argc, char* argv[])
{
	if (argc != 3)
		return 1;

	bool result = libcaff_makePreview(argv[1], argv[2], 10000 * 10000);
	if (!result)
	{
		std::cout << libcaff_getLastError();
		return 2;
	}

	return 0;
}