#include "PngEncoder.h"

#include "spng.h"

#include <stdexcept>

PngEncoder::PngEncoder()
{
	ctx = spng_ctx_new(SPNG_CTX_ENCODER);
	if (ctx == nullptr)
		throw std::runtime_error("Failed to create SPNG context");
}

PngEncoder::~PngEncoder()
{
	spng_ctx_free(ctx);
	if (file != nullptr)
		fclose(file);
}

void PngEncoder::setOutPath(const char* path)
{
	file = fopen(path, "wb");
	if (file == nullptr)
		throw std::runtime_error("Failed to open output file");
	spng_set_png_file(ctx, file);
}

void PngEncoder::setImageHeader(uint32_t width, uint32_t height)
{
	spng_ihdr header = { 0 };

	header.width = width;
	header.height = height;
	header.color_type = spng_color_type::SPNG_COLOR_TYPE_TRUECOLOR;
	header.bit_depth = 8;

	spng_set_ihdr(ctx, &header);
}

void PngEncoder::encodeImage(const void* image, size_t length)
{
	int result = spng_encode_image(ctx, image, length, SPNG_FMT_PNG, SPNG_ENCODE_FINALIZE);
	if (result != 0)
		throw std::runtime_error("Failed to write image data");
}