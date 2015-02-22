//
//  EXMacros.h
//
//  Created by Mike Johnson on 7/13/12.
//  Copyright (c) 2012 Exorcyze Studios. All rights reserved.
//

#warning REMOVE ANY EXTRANEOUS INCLUDES
#import <QuartzCore/QuartzCore.h>
#import "NSData+Helper.h"
#import "NSDate+Conversions.h"
#import "NSObject+Delay.h"
#import "NSString+Calculations.h"
#import "NSUserDefaults+Defaults.h"
#import "UIColor+Extensions.h"
#import "UIControl+Creation.h"
#import "UIView+Frame.h"
#import "UIImageView+LoadURL.h"
#import "UINavigation+Custom.h"

#define IS_EMPTY_STRING(str) (!(str) || ![(str) isKindOfClass:NSString.class] || [(str) length] == 0 || [(str) isEqualToString:@"(null)"] || [(str) isEqualToString:@"<null>"] )

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog( @"%s:%d > %@", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__] )
#else
#define NSLog(...)
#define ASLLog(...)
#endif

// Singleton ShareInstance
#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) static dispatch_once_t pred = 0; __strong static id _sharedObject = nil; dispatch_once(&pred, ^{ _sharedObject = block(); }); return _sharedObject;

// IOS Version
#pragma mark - == IOS Version ==

#define IOS_VERSION(version) ([[[UIDevice currentDevice] systemVersion] hasPrefix:version])
#define VERSION_IDENTIFIER ([UIDevice currentDevice] systemVersion])

// Device Types
#pragma mark - == Device Types ==

#define DEVICE_IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define DEVICE_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define DEVICE_IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2)
#define DEVICE_IS_SIMULATOR (TARGET_IPHONE_SIMULATOR)
#define DEVICE_IDENTIFIER ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"iPad" : @"iPhone")

// Battery State
#pragma mark - == Device Battery State ==

#define DEVICE_BATTERYSTATE_FULL ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateFull)
#define DEVICE_BATTERYSTATE_CHARGING ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateCharging)
#define DEVICE_BATTERYSTATE_UNPLUGGED ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateUnplugged)
#define DEVICE_BATTERYSTATE_UNKOWN ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateUnknown)

// Device Orientations
#pragma mark - == Device Orientations ==

#define DEVICE_ORIENTATION_PORTRAIT_ALL ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown)
#define DEVICE_ORIENTATION_PORTRAIT ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait)
#define DEVICE_ORIENTATION_PORTRAIT_UPSIDEDOWN ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown)

#define DEVICE_ORIENTATION_LANDSCAPE_ALL ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight)
#define DEVICE_ORIENTATION_LANDSCAPE_LEFT ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft)
#define DEVICE_ORIENTATION_LANDSCAPE_RIGHT ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight)

#define DEVICE_ORIENTATION_FACE_ALL [[UIDevice currentDevice] orientation] == UIDeviceOrientationFaceUp || [[UIDevice currentDevice] orientation] == UIDeviceOrientationFaceDown
#define DEVICE_ORIENTATION_FACE_UP ([[UIDevice currentDevice] orientation] == UIDeviceOrientationFaceUp)
#define DEVICE_ORIENTATION_FACE_DOWN ([[UIDevice currentDevice] orientation] == UIDeviceOrientationFaceDown)

#define DEVICE_ORIENTATION_UNKOWN ([[UIDevice currentDevice] orientation] == UIDeviceOrientationUnknown)

// Statusbar Orientations
#pragma mark - == Statusbar Orientations ==

#define STATUSBAR_ORIENTATION_PORTRAIT_ALL ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown)
#define STATUSBAR_ORIENTATION_PORTRAIT ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait)
#define STATUSBAR_ORIENTATION_PORTRAIT_UPSIDEDOWN ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown)

#define STATUSBAR_ORIENTATION_LANDSCAPE_ALL (STATUSBAR_ORIENTATION_LANDSCAPE_LEFT || STATUSBAR_ORIENTATION_LANDSCAPE_RIGHT)
#define STATUSBAR_ORIENTATION_LANDSCAPE_LEFT ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft)
#define STATUSBAR_ORIENTATION_LANDSCAPE_RIGHT ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)

// Interface Orientations
#pragma mark - == Interface Orientations ==

#define INTERFACE_ORIENTATION_PORTRAIT_ALL ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown)
#define INTERFACE_ORIENTATION_LANDSCAPE_ALL ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)

// Screen Sizes
#pragma mark - == Screen Sizes ==

//#define SCREEN_SIZE ([UIScreen mainScreen].bounds.size)
#define STATUS_BAR_SIZE ( [[UIApplication sharedApplication] isStatusBarHidden] ? 0 : 20 )
#define NAV_BAR_HEIGHT self.navigationController.navigationBar.height
#define SCREEN_SIZE CGSizeMake( [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - STATUS_BAR_SIZE )
#define SCREEN_SIZE_ORIENTED ( ( INTERFACE_ORIENTATION_LANDSCAPE_ALL ) ? CGSizeMake( [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width - STATUS_BAR_SIZE ) : CGSizeMake( [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - STATUS_BAR_SIZE ) )
#define SCREEN_BOUNDS_ORIENTED  ( ( INTERFACE_ORIENTATION_LANDSCAPE_ALL ) ? CGRectMake( 0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width - STATUS_BAR_SIZE ) : CGRectMake( 0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - STATUS_BAR_SIZE ) )

// Strings
#pragma mark - == Strings ==

#define isStringEmpty(string) (string == nil || [string length] <= 0 || [string isEqualToString:@""] || [string isEqualToString:@" "] || [string isEqualToString:@"\n"] || [string isEqualToString:@"\t"])
#define isStringNotEmpty(string) (string != nil && [string length] > 0 && ![string isEqualToString:@""] && ![string isEqualToString:@" "] && ![string isEqualToString:@"\n"] && ![string isEqualToString:@"\t"])
#define APP_DOCUMENTS_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

// Math
#pragma mark - == Math ==

#define degreesToRadians(degrees) ((degrees) / 180.0 * M_PI)
#define radiansToDegrees(radians) ((radians) * (180.0 / M_PI))
#define MATH_PI (3.14159265358979323846264338327950288f)

// Object Wrappers
#pragma mark - == Object Wrappers ==

#define NSNumberFromBool( b ) [NSNumber numberWithBool:b]
#define NSNumberFromInt( i ) [NSNumber numberWithInt:i]
#define boolFromNSNumber( b ) [b boolValue]
#define intFromNSNumber( i ) [i intValue]
#define SAFE_INT_VALUE( i ) ( i ) ? ( [(i) isKindOfClass:[NSNull class]] ? 0 : [i integerValue] ) : 0







