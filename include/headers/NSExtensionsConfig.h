//
//  NSExtensionsConfig.h
//
// Copyright (c) 2008-2010 Bence Balint
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//


// Extensions behavior
#define HAVE_CRYPTO											1
#define HAVE_CRYPTO_SECURITY								1
#define HAVE_LIBZ											1
#define HAVE_ECC											1
#define ENABLE_DEBUG_TEXTS									1
#define ENABLE_LIKELY_UNLIKELY								1
#define ENABLE_PRIVATE_FRAMEWORKS							0
#define ENABLE_BANNED_FRAMEWORKS							0


// Xcode 4 and above defines 'DEBUG' macro for debug builds
#ifdef DEBUG
	#undef CONFIGURATION_DEBUG
	#define CONFIGURATION_DEBUG								1
#endif


// Automatic logging setup for 'CONFIGURATION_DEBUG'
#undef DEBUG_LOG
#if CONFIGURATION_DEBUG
	#define DEBUG_LOG										1
#else
	#define DEBUG_LOG										0
#endif
#undef DEBUG_LONG_LOG
#if CONFIGURATION_DEBUG
	#define DEBUG_LONG_LOG									1
#else
	#define DEBUG_LONG_LOG									0
#endif


// Log
#define LOG_URL												1		// URLFetcher
#define LOG_ERR												1		// Error related
#define LOG_IAP												1		// InApp-Purchase
#define LOG_APNS											1		// Apple Push Notification Service
#define LOG_PD												1		// ParallelDownload
#define LOG_RF												1		// Reachability flags
#define LOG_UI												1		// UI/Appflow related
#define LOG_DBG												1		// Debug related
#define LOG_LOG												1		// log related
#define LOG_TEST											1		// for small tests
#define LOG_SERVICE											1		// default service messages
#define LOG_EA												1		// External Accessories

#if !DEBUG_LOG
	#undef LOG_ERR
	#define LOG_ERR											0
	#undef LOG_URL
	#define LOG_URL											0
	#undef LOG_IAP
	#define LOG_IAP											0
	#undef LOG_APNS
	#define LOG_APNS										0
	#undef LOG_PD
	#define LOG_PD											0
	#undef LOG_RF
	#define LOG_RF											0
	#undef LOG_UI
	#define LOG_UI											0
	#undef LOG_DBG
	#define LOG_DBG											0
	#undef LOG_LOG
	#define LOG_LOG											0
	#undef LOG_TEST
	#define LOG_TEST										0
	#undef LOG_SERVICE
	#define LOG_SERVICE										0
	#undef LOG_EA
	#define LOG_EA											0
#endif


// Import the rest (app specific config redefines)
#import "config.nsextensions.h"

