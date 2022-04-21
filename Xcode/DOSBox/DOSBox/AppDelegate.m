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


int gArgc;
const char** gArgv;
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
    const char *temparg;
    size_t arglen;
    char *arg;
    const char **newargv;

    if (!gFinderLaunch)  /* MacOS is passing command line args. */
        return FALSE;

    if (gCalledAppMainline)  /* app has started, ignore this document. */
        return FALSE;

    temparg = [filename UTF8String];
    arglen = SDL_strlen(temparg) + 1;
    arg = (char *) SDL_malloc(arglen);
    if (arg == NULL)
        return FALSE;

    newargv = (const char **) realloc(gArgv, sizeof (char *) * (gArgc + 2));
    if (newargv == NULL)
    {
        SDL_free(arg);
        return FALSE;
    }
    gArgv = newargv;

    SDL_strlcpy(arg, temparg, arglen);
    gArgv[gArgc++] = arg;
    gArgv[gArgc] = NULL;
    return TRUE;
}

/* Called when the internal event loop has just started running */
- (void)applicationDidFinishLaunching:(NSNotification *)note
{
    [self performSelectorOnMainThread:@selector(run) withObject:NULL waitUntilDone:FALSE];
}

- (void)run
{
    int status;

    /* Set the working directory to the .app's parent directory */
    [self setupWorkingDirectory:gFinderLaunch];

    /* Hand off to main application code */
    gCalledAppMainline = TRUE;
    
    status = SDL_main (gArgc, (char**) gArgv);
    
    /* We're done, thank you for playing */
    exit(status);
}


@end

