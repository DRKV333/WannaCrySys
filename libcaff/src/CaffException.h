#pragma once

#include <stdexcept>

class CaffException : public std::runtime_error
{
public:
	using runtime_error::runtime_error;
};