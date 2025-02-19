# import <Foundation/Foundation.h>

/** \brief Banafo Service error enum
*
*  This enum is used to enumerate all the possible events all the ZDK internally created Banafo requests can have.
*/
typedef NS_ENUM(int, ZDKBanafoEventType)
{

	/** \brief A request for creating a new Banafo Call has been sent. The result of this event is always ResultCode::Ok.
	*/
	bet_CallStarted,

	/** \brief The request for creating a new Banafo Call has finished. If Banafo Call ID has been obtained successfully
	*  the result is ResultCode::Ok otherwise it shows the error.
	*/
	bet_CallFinished,

	/** \brief A request for creating a new Banafo Recording has been sent. The result of this event is always ResultCode::Ok.
	*/
	bet_CallRecordingStarted,

	/** \brief The request for creating a new Banafo Recording has finished. If Banafo Recording ID has been obtained
	*  successfully the result is ResultCode::Ok otherwise it shows the error.
	*/
	bet_CallRecordingFinished,
};
