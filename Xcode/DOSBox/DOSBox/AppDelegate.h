//
//  AppDelegate.h
//  DOSBox
//
//  Created by DE4ME on 21.04.2022.
//


#ifndef _AppDelegate_h_
#define _AppDelegate_h_


#import <Cocoa/Cocoa.h>


extern BOOL gFinderLaunch;


//MARK: - DOSBoxApplication


@interface DOSBoxApplication: NSApplication
@end


//MARK: - AppDelegate


NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate: NSObject <NSApplicationDelegate>

@property (readonly) NSURL* _Nullable url;

@end

NS_ASSUME_NONNULL_END

#endif /* _AppDelegate_h_ */
