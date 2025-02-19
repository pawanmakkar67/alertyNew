//
// ZDKLog.h
// ZDK
//

#ifndef ZDKLog_h
#define ZDKLog_h

#import <Foundation/Foundation.h>
#import "ZDKLoggingFacility.h"
#import "ZDKLoggingLevel.h"
#import "ZDKResult.h"
#import "ZDKZHandle.h"
#import "ZDKResult.h"
@protocol ZDKResult;

NS_ASSUME_NONNULL_BEGIN

/** \brief Debug logging facility
*/
@protocol ZDKLog <ZDKZHandle>

/** \brief Configures the list with all enabled logging facilities
*
*  Debug log entries will be added only from the listed facilities.
*
*  \param[in] value  The list with all active logging facilities
*
*  \see LoggingFacility
*/
@property(nonatomic) NSArray<NSNumber*>*  activeFacilities;

/** \brief Starts logging
*
*  Starts the log facility. It will be used automatically by most library subsystems to log various events. If
*  logging has already started it will be closed and reopened.
*
*  Can be called before startContext() and/or after stopContext(). The log facility has its own life separate from
*  the context.
*
*  The log files are always opened in append mode.
*
*  The logging facility will maintain up to two files and automatically rotate them. To enable rotation, set a
*  non-zero maximum file size in "maxSizeBytes" and set the secondary log file name in "oldFileName". If
*  "maxSizeBytes" or "oldFileName" are zero, rotation will be disabled.
*
*  The rotation consists of the following operations:
*  1. The log file handle is closed.
*  2. If the old file exists, it is removed.
*  3. The log file is renamed.
*  4. The log file handle is reopened.
*
*  Both file names MUST reside on the same logical file system.
*
*  All messages are first filtered by level. The "maxLevel" parameter sets the highest acceptable value, or in
*  other words, the minimum severity level that will be logged. Confusingly, for legacy reasons, the lowest number
*  has the highest severity.
*
*  The log format is CSV-like with the sequence " | " (space, pipe, space) as delimiter. The column count is
*  fixed. All columns up to the last will not contain the pipe symbol but may contain white space. The last column
*  is special, as it may contain unescaped pipe symbols and new lines, especially when the network stacks dump
*  entire network messages.
*
*  Care must be taken when writing automated log parsers.
*
*  Here are the columns with example values:
*  1. Log level (textual): DEBUG, ZDKNFO, ...
*  2. Timestamp: 20160217-163725.551
*  3. Subsystem tag: RESIP:APP, MSRP, WRAPPER, ...
*  4. Thread id: 12204, 0xfefeb000
*  5. Source file and line: audio_builder.cpp:93
*  6. Log message: Unregister source= 0x80f3a4d0 ...
*
*  \param[in] fileName  Main log file name
*  \param[in] oldFileName  Secondary log file. Only used if "maxSizeBytes" is greater than 0.
*  \param[in] maxLevel  Maximum level to log. Messages with higher level values, meaning lower severity are
*             automatically dropped before filtering.
*  \param[in] maxSizeBytes  Maximum size for a single log file. Affects both the main and the secondary file,
*             resulting in maximum twice as much space used.
*
*  \return Result of the opening
*
*  \see LoggingLevel, ZDKResult
*/
-(id<ZDKResult>)logOpen:(NSString*)fileName oldFileName:(NSString* _Nullable)oldFileName maxLevel:(ZDKLoggingLevel)maxLevel maxSizeBytes:(long int)maxSizeBytes ;
/** \brief Log a message
*
*  Adds a log entry to the log.
*
*  The log format allows putting a "subsystem" in one of the log columns.  The subsystem names are short uppercase
*  only tags, optionally followed by a colon ':' and a snother short uppercase only tag signifying a sub-sub-system.
*
*  Custom subsystems used by the SDK user must follow the same rules to keep the log parsers simple.
*
*  Here is a (mostly complete) list of the tags in use:
*
*  RESIP:APP is used extensively in the library but will
*            gradually be phased out in favor of WRAPPER
*  WRAPPER   is going to be used for the call managers
*  RESIP     (with the exception of :APP) is used by the
*            SIP stack and some platform wrapper utilities
*  ZRTP      is the ZRTP implementation
*  MSRP      is the MSRP implementation
*
*  No parameters are optional.
*
*  \param[in] level  Log level. If it is higher than the current configured maximum log level the message will be ignored.
*  \param[in] facility  Short subsystem name in the form of TAG or TAG:SUBTAG
*  \param[in] facilityName  String representation of the subsystem
*  \param[in] sourceFileName  Source file name
*  \param[in] sourceLine  Source file line
*  \param[in] message  The log message itself
*
*  \see LoggingLevel, LoggingFacility, logOpen()
*/
-(void)logMessage:(ZDKLoggingLevel)level facility:(ZDKLoggingFacility)facility facilityName:(NSString*)facilityName sourceFileName:(NSString*)sourceFileName sourceLine:(int)sourceLine message:(NSString*)message ;
/** \brief Stops logging
*
*  Closes the current log file, if open. Any further log requests, both internal and external, will do nothing.
*
*  \return Result of the closing
*
*  \see ZDKResult
*/
-(id<ZDKResult>)logClose;
/** \brief Checks whether the given logging facility is enabled
*
*  \param[in] value  The logging facility to be checked
*
*  \return Whether or not the given facillity should be logged
*
*  \see LoggingFacility
*/
-(BOOL)shouldLogFacility:(ZDKLoggingFacility)value ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
