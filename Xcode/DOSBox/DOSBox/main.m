//
//  main.m
//  DOSBox
//
//  Created by DE4ME on 21.04.2022.
//


#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"


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
    /* Copy the arguments into a global variable */
    if (IsFinderLaunch(argc, argv)) {
        gArgv = (const char **) malloc(sizeof (char *) * 2);
        gArgv[0] = argv[0];
        gArgv[1] = NULL;
        gArgc = 1;
        gFinderLaunch = YES;
    } else {
        int i;
        gArgc = argc;
        gArgv = (const char **) malloc(sizeof (char *) * (argc+1));
        for (i = 0; i <= argc; i++)
            gArgv[i] = argv[i];
        gArgv[i] = NULL;
        gFinderLaunch = NO;
    }
    return NSApplicationMain(argc, argv);
}
