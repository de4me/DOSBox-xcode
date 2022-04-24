//
//  AppDelegate.m
//  DOSBox
//
//  Created by DE4ME on 21.04.2022.
//


#include "AppDelegate.h"
#include <sys/param.h> /* for MAXPATHLEN */
#include <unistd.h>


@import SDL;


#include "NSString_Utils.h"


BOOL gFinderLaunch;
BOOL gCalledAppMainline = FALSE;


//MARK: - DOSBoxApplication


@implementation DOSBoxApplication

/* Invoked from the Quit menu item */
- (void)terminate:(id)sender
{
    /* Post a SDL_QUIT event */
    SDL_Event event;
    event.type = SDL_QUIT;
    SDL_PushEvent(&event);
}

@end


//MARK: - AppDelegate


@interface AppDelegate()

@property NSURL* url;

@end


/* The main class of the application, the application's delegate */
@implementation AppDelegate


/* Set the working directory to the .app's parent directory */
- (void)setupWorkingDirectory:(BOOL)shouldChdir
{
    if (shouldChdir) {
        char parentdir[MAXPATHLEN];
        CFURLRef url = CFBundleCopyBundleURL(CFBundleGetMainBundle());
        CFURLRef url2 = CFURLCreateCopyDeletingLastPathComponent(0, url);
        if (CFURLGetFileSystemRepresentation(url2, 1, (UInt8 *)parentdir, MAXPATHLEN)) {
            chdir(parentdir);   /* chdir to the binary app's parent */
        }
        CFRelease(url);
        CFRelease(url2);
    }
}

/*
 * Catch document open requests...this lets us notice files when the app
 *  was launched by double-clicking a document, or when a document was
 *  dragged/dropped on the app's icon. You need to have a
 *  CFBundleDocumentsType section in your Info.plist to get this message,
 *  apparently.
 *
 * Files are added to gArgv, so to the app, they'll look like command line
 *  arguments. Previously, apps launched from the finder had nothing but
 *  an argv[0].
 *
 * This message may be received multiple times to open several docs on launch.
 *
 * This message is ignored once the app's mainline has been called.
 */
- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
{
    NSString* mime_type = filename.mimeType;
    if ([mime_type isEqualToString:@"public.dosbox-application"]) {
        NSURL* url = [NSURL fileURLWithPath:filename];
        if (gCalledAppMainline) {
            NSWorkspace* work_space = NSWorkspace.sharedWorkspace;
#if (MAC_OS_X_VERSION_MIN_REQUIRED >= 101500)
            NSWorkspaceOpenConfiguration* config = [NSWorkspaceOpenConfiguration new];
            config.createsNewApplicationInstance = TRUE;
            [work_space openApplicationAtURL:url configuration:config completionHandler:NULL];
#elif (MAC_OS_X_VERSION_MAX_ALLOWED >= 101500)
            if (@available(macOS 10.15, *)) {
                NSWorkspaceOpenConfiguration* config = [NSWorkspaceOpenConfiguration new];
                config.createsNewApplicationInstance = TRUE;
                [work_space openApplicationAtURL:url configuration:config completionHandler:NULL];
            } else {
                [work_space openURL:url options:NSWorkspaceLaunchNewInstance configuration:NSDictionary.dictionary error:NULL];
            }
#else
            [work_space openURL:url options:NSWorkspaceLaunchNewInstance configuration:NSDictionary.dictionary error:NULL];
#endif
            return FALSE;
        } else {
            chdir(filename.UTF8String);
            gFinderLaunch = FALSE;
            self.url = url;
            return TRUE;
        }
    } else {
        if (!gFinderLaunch)  /* MacOS is passing command line args. */
            return FALSE;
        if (gCalledAppMainline)  /* app has started, ignore this document. */
            return FALSE;
        return TRUE;
    }
}

/* Called when the internal event loop has just started running */
- (void)applicationDidFinishLaunching:(NSNotification *)note
{
    /* Set the working directory to the .app's parent directory */
    [self setupWorkingDirectory:gFinderLaunch];
    /* Hand off to main application code */
    gCalledAppMainline = TRUE;
    [self performSelectorOnMainThread:@selector(run) withObject:NULL waitUntilDone:FALSE];
}

- (void)run
{
    NSArray<NSString*>* arguments = [[NSProcessInfo processInfo] arguments];
    int argc = arguments.count;
    const char** argv = malloc(sizeof(const char*) * argc);
    [arguments enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        argv[idx] = obj.UTF8String;
    }];
    int status = SDL_main(argc, (char**)argv);
    free(argv);
    /* We're done, thank you for playing */
    exit(status);
}


@end

