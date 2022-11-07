#pragma once

#include "Binreader.h"
#include "Ciff.h"

#include <cstdint>

class Caff
{
private:
	uint64_t numAnim = 0;
	Ciff previewCiff;
	
	void readHeaderBlock(Binreader& reader);
	void readCreditsBlock(Binreader& reader);

public:
	void setMaxDecodeSize(size_t size) { previewCiff.setMaxDecodeSize(size); }
	void read(Binreader& reader);

	uint64_t getNumAnim() const { return numAnim; }
	const Ciff& getPreviewCiff() const { return previewCiff; }
};