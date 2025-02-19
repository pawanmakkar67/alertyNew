# import <Foundation/Foundation.h>

/** \brief Video frame format types
*/
typedef NS_ENUM(int, ZDKVideoFrameFormat)
{

	/** \brief 12bpp YUV420 planar
	*/
	vff_YUV420p,

	/** \brief 24bpp interleaved RGBA non-planar
	*/
	vff_RGBA,

	/** \brief 24bpp interleaved ARGB non-planar
	*/
	vff_ARGB,
};
