#pragma once

// Silence error about not using fopen_s
#ifdef _MSC_VER
#define _CRT_SECURE_NO_WARNINGS
#endif

#include <stdio.h>
#include <cstdint>

class PngEncoder
{
private:
	struct spng_ctx* ctx;
	FILE* file = nullptr;

	PngEncoder(const PngEncoder&) = delete;
	PngEncoder& operator=(const PngEncoder&) = delete;
public:
	PngEncoder();
	virtual ~PngEncoder();

	void setOutPath(const char* path);
	void setImageHeader(uint32_t width, uint32_t height);
	void encodeImage(const void* image, size_t length);
};