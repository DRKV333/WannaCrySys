#pragma once

#include "CaffException.h"

#include <istream>
#include <string>
#include <cstring>

// Assume native byte order is little is little endian, so we don't have to worry about swapping anything.
#if !(defined(_M_IX86) || (defined(_M_AMD64) && !defined(_M_ARM)) || defined(__i386__) || defined(__x86_64__) || defined(__cppcheck__))
#error Architecture might not be little endian...
#endif

class Binreader
{
private:
	std::basic_istream<char>& stream;

public:
	explicit Binreader(std::basic_istream<char>& stream)
		: stream(stream) {}

	void read(char* buffer, size_t size)
	{
		stream.read(buffer, size);
	}

	template <typename T>
	T read()
	{
		T buffer;
		read(reinterpret_cast<char*>(&buffer), sizeof(T));
		return buffer;
	}

	template <size_t size>
	void assertMagic(char* magic)
	{
		char buffer[size];
		read(buffer, size);
		if (std::memcmp(buffer, magic, size) != 0)
			throw CaffException("Bad magic");
	}

	void skip(size_t size)
	{
		stream.seekg(size, std::ios_base::cur);
	}
};