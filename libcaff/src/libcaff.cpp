#include "libcaff.h"

#include "Caff.h"

#include <string>
#include <fstream>

static std::string lastError = "";

bool libcaff_makePreview(const char* inPath, const char* outPath, size_t maxDecodeSize)
{
	try
	{
		std::fstream stream;
		stream.open(inPath, std::ios_base::in | std::ios_base::binary);
		if (!stream.is_open())
			throw CaffException("Failed to open input file");

		stream.exceptions(std::ios_base::failbit);

		Binreader reader(stream);

		Caff caff;
		caff.setMaxDecodeSize(maxDecodeSize);
		caff.read(reader);

		caff.getPreviewCiff().writePng(outPath);
	}
	catch (const std::exception& e)
	{
		lastError = std::string(e.what());
		return false;
	}

	return true;
}

const char* libcaff_getLastError()
{
	return lastError.c_str();
}
