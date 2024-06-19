//
//  TextManager.h
//  LibLibrary
//
//  Created by Bence Balint on 11/7/12.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface TextManager : NSObject

// e.g.: [TextManager localizedObject:dict forKey:@"titles"]
//
// {
//   ...
//   "titles" : {
//     "en" : "Help",
//     "de" : "Hilfe"
//   }
//   ...
// }
//
+ (id) localizedObject:(NSDictionary*)dictionary forKey:(NSString*)key;
+ (id) localizedObject:(NSDictionary*)dictionary forKey:(NSString*)key fallback:(id)fallback;
+ (id) localizedObject:(NSDictionary*)possibles;
+ (id) localizedObject:(NSDictionary*)possibles fallback:(id)fallback;

// line break preprocessing
+ (NSString*) replacementForLineBreak:(NSString*)string orientation:(UIInterfaceOrientation)orientation;
+ (NSString*) preprocessedLineBreaks:(NSString*)string orientation:(UIInterfaceOrientation)orientation;

// preprocess line breaks for interface orientaion and replaces texts defined in translations dictionary
+ (NSString*) preprocessedString:(NSString*)string translations:(NSDictionary*)translations;
+ (NSString*) preprocessedString:(NSString*)string translations:(NSDictionary*)translations orientation:(UIInterfaceOrientation)orientation;
+ (NSString*) preprocessString:(NSString*)string markupString:(NSString*)markupString replacementString:(NSString*)replacementString;

#if HAVE_CORE_TEXT
// shorthand attributed helpers
+ (NSMutableAttributedString*) attributedString:(NSString*)string font:(UIFont*)font color:(UIColor*)color;
+ (NSRange) nextMarkup:(NSString*)string markups:(NSArray*)markups;

// preprocess line breaks for interface orientaion and replaces texts defined in translations dictionary
+ (NSAttributedString*) preprocessedAttributedString:(NSString*)string
										  normalFont:(UIFont*)normalFont
										 normalColor:(UIColor*)normalColor
									  highlightFonts:(NSArray*)highlightFonts
									 highlightColors:(NSArray*)highlightColors
										translations:(NSDictionary*)translations;

+ (NSAttributedString*) preprocessedAttributedString:(NSString*)string
										  normalFont:(UIFont*)normalFont
										 normalColor:(UIColor*)normalColor
									  highlightFonts:(NSArray*)highlightFonts
									 highlightColors:(NSArray*)highlightColors
										translations:(NSDictionary*)translations
										 orientation:(UIInterfaceOrientation)orientation;

+ (NSAttributedString*) preprocessAttributedString:(NSString*)string
									 markupStrings:(NSArray*)markupStrings
								replacementStrings:(NSArray*)replacementStrings
										normalFont:(UIFont*)normalFont
									   normalColor:(UIColor*)normalColor
									highlightFonts:(NSArray*)highlightFonts
								   highlightColors:(NSArray*)highlightColors;
#endif

@end
