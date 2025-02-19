# import <Foundation/Foundation.h>

/** \brief Call recording type
*
*  Specifies which streams are captured in a call recording
*/
typedef NS_ENUM(int, ZDKRecordingType)
{

	/** \brief Undefined recording type
	*/
	rt_Unknown = 0,

	/** \brief Mix local and remote talk in one channel (mono)
	*/
	rt_Mixed,

	/** \brief Only store local talk
	*/
	rt_Local,

	/** \brief Only store remote talk
	*/
	rt_Remote,

	/** \brief Record local talk as left channel and remote talk as right channel
	*/
	rt_Stereo,
};
