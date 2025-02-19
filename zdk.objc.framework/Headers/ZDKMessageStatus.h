# import <Foundation/Foundation.h>

/** \brief Message sending status
*/
typedef NS_ENUM(int, ZDKMessageStatus)
{

	/** \brief Invalid - information not available
	*/
	ms_NA,

	/** \brief Message is in a process of sending
	*/
	ms_Sending,

	/** \brief Message is sent successfully
	*/
	ms_Sent,

	/** \brief Message sent failed
	*/
	ms_SendingFailed,
};
