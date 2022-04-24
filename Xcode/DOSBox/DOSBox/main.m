//
//  main.m
//  DOSBox
//
//  Created by DE4ME on 21.04.2022.
//


#import <Cocoa/Cocoa.h>
#include <sys/param.h> /* for MAXPATHLEN */
#include "AppDelegate.h"


static int IsRootCwd() {
    char buf[MAXPATHLEN];
    char *cwd = getcwd(buf, sizeof (buf));
    return (cwd && (strcmp(cwd, "/") == 0));
}

static int IsFinderLaunch(const int argc, const char **argv) {
    /* -psn_XXX is passed if we are launched from Finder, SOMETIMES */
    if ( (argc >= 2) && (strncmp(argv[1], "-psn", 4) == 0) ) {
        return 1;
    } else if ((argc == 1) && IsRootCwd()) {
        /* we might still be launched from the Finder; on 10.9+, you might not
        get the -psn command line anymore. If there's no
        command line, and if our current working directory is "/", it
        might as well be a Finder launch. */
        return 1;
    }
    return 0;  /* not a Finder launch. */
}

int main(int argc, const char * argv[]) {
    gFinderLaunch = IsFinderLaunch(argc, argv);
    return NSApplicationMain(argc, argv);
}
