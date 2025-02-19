# import <Foundation/Foundation.h>

/** \brief Audio file format type
*/
typedef NS_ENUM(int, ZDKAudioFileFormat)
{

	/** \brief Raw audio - uncompressed PCM in a WAV/RIFF format
	*/
	aff_WAV,

	/** \brief MPEG Layer-3 compressed audio
	*/
	aff_MP3,
};
