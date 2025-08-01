#import <Foundation/Foundation.h>

@interface DataItem : NSObject

- (instancetype)initWithData:(NSData *)data;
- (void)appendData:(NSData *)data;
- (NSData *)data;

@end

