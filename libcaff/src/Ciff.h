#pragma once

#include "Binreader.h"

#include <vector>

class Ciff
{
private:
	size_t maxDecodeSize = 1000 * 1000 * 3;
	std::vector<char> pixelBuffer;
	uint32_t width;
	uint32_t height;

public:
	void setMaxDecodeSize(size_t size) { maxDecodeSize = size; }
	void read(Binreader& reader);
	void writePng(const char* path) const;
};