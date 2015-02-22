#import <Foundation/Foundation.h>

@interface NSData (Helper)

void *NewBase64Decode( const char *inputBuffer, size_t length, size_t *outputLength);
char *NewBase64Encode( const void *buffer, size_t length, bool separateLines, size_t *outputLength);

+ (NSData *)dataFromBase64String:(NSString *)aString;
- (NSString *)base64EncodedString;

@end
