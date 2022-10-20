#include "Ciff.h"

#include "PngEncoder.h"

#include <stdexcept>
#include <limits>

void Ciff::read(Binreader& reader)
{
	reader.assertMagic<4>("CIFF");

	uint64_t headerSize = reader.read<uint64_t>();
	uint64_t contentSize = reader.read<uint64_t>();
	
	if (contentSize > maxDecodeSize)
		throw std::runtime_error("CIFF too large to decode");

	uint64_t widthL = reader.read<uint64_t>();
	uint64_t heightL = reader.read<uint64_t>();

	if (widthL > std::numeric_limits<uint32_t>::max() ||
		heightL > std::numeric_limits<uint32_t>::max() ||
		contentSize != widthL * heightL * 3)
		throw std::runtime_error("CIFF content size does not match image dimensions");

	width = static_cast<uint32_t>(widthL);
	height = static_cast<uint32_t>(heightL);

	// Skip the rest of the header, we don't care about tags.
	reader.skip(headerSize - (4 + sizeof(uint64_t) * 4)); // magic + headerSize + contentSize + width + height

	pixelBuffer.resize(contentSize);
	reader.read(pixelBuffer.data(), contentSize);
}

void Ciff::writePng(const char* path) const
{
	PngEncoder encoder;

	encoder.setOutPath(path);
	encoder.setImageHeader(width, height);
	encoder.encodeImage(pixelBuffer.data(), pixelBuffer.size());
}