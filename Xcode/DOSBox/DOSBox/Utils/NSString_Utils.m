//
//  NSString_Utils.m
//  DOSBox
//
//  Created by DE4ME on 21.04.2022.
//


#include "NSString_Utils.h"


@implementation NSString (Utils)

- (NSString*)mimeType
{
    CFStringRef extension = (__bridge CFStringRef)(self.pathExtension);
    if (extension && (CFStringGetLength(extension) > 0)) {
        CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
        if (uti)
            return CFBridgingRelease(UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType));
    } else {
        BOOL is_folder;
        if ([NSFileManager.defaultManager fileExistsAtPath:self isDirectory:&is_folder])
            return is_folder ? (NSString*)kUTTypeFolder : (NSString*)kUTTypeFileURL;
    }
    return NULL;
}

@end
