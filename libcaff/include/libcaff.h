#pragma once

#include <stddef.h>

#ifdef WIN32
#ifdef libcaff_EXPORTS
#define LIBCAFFAPI __declspec(dllexport)
#else
#define LIBCAFFAPI __declspec(dllimport)
#endif
#else
#define LIBCAFFAPI
#endif

#ifdef __cplusplus
extern "C" {
#endif

LIBCAFFAPI bool libcaff_makePreview(const char* inPath, const char* outPath, size_t maxDecodeSize);

LIBCAFFAPI const char* libcaff_getLastError();

#ifdef __cplusplus
}
#endif