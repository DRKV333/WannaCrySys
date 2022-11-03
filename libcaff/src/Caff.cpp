#include "Caff.h"

#include "CaffException.h"

void Caff::readHeaderBlock(Binreader& reader)
{
	uint64_t blockSize = reader.read<uint64_t>();
	if (blockSize != 20)
		throw CaffException("Bad CAFF header block size");

	reader.assertMagic<4>("CAFF");
	
	uint64_t headerSize = reader.read<uint64_t>();
	if (headerSize != 20)
		throw CaffException("Bad CAFF header size");

	numAnim = reader.read<uint64_t>();
}

void Caff::readCreditsBlock(Binreader& reader)
{
	uint64_t blockSize = reader.read<uint64_t>();
	
	// Don't care about credits for now, just skip the block.
	reader.skip(blockSize);
}

void Caff::read(Binreader& reader)
{
	uint8_t blockId = reader.read<uint8_t>();
	if (blockId != 1)
		throw CaffException("Expected CAFF header block");

	readHeaderBlock(reader);

	bool hadCreditsBlock = false;
	while (true)
	{
		blockId = reader.read<uint8_t>();

		if (blockId == 1)
		{
			throw CaffException("Duplicate CAFF header block");
		}
		else if (blockId == 2)
		{
			if (hadCreditsBlock)
				throw CaffException("Duplicate CAFF credits block");
			hadCreditsBlock = true;

			readCreditsBlock(reader);
		}
		else if (blockId == 3)
		{
			// For the preview, we only care about the first frame.
			reader.skip(sizeof(uint64_t) + sizeof(uint64_t)); // Block size + duration
			previewCiff.read(reader);
			break;
		}
		else
		{
			throw CaffException("Invalid CAFF clock type");
		}
	}
}
