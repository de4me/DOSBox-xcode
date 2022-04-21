//
//  AppDelegate.h
//  DOSBox
//
//  Created by DE4ME on 21.04.2022.
//


#ifndef _AppDelegate_h_
#define _AppDelegate_h_

#import <Cocoa/Cocoa.h>


extern int gArgc;
extern const char** gArgv;
extern BOOL gFinderLaunch;
extern BOOL gCalledAppMainline;


@interface DOSBoxApplication: NSApplication
@end

@interface AppDelegate: NSObject <NSApplicationDelegate>
@end


#endif /* _AppDelegate_h_ */
