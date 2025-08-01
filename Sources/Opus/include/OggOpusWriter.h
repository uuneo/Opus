#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DataItem;

@interface OggOpusWriter : NSObject

- (bool)beginWithDataItem:(DataItem *)dataItem;
- (bool)beginAppendWithDataItem:(DataItem *)dataItem;

- (bool)writeFrame:(uint8_t * _Nullable)framePcmBytes frameByteCount:(NSUInteger)frameByteCount;
- (NSUInteger)encodedBytes;
- (NSTimeInterval)encodedDuration;

- (NSDictionary *)pause;
- (bool)resumeWithDataItem:(DataItem *)dataItem encoderState:(NSDictionary *)state;

@end

NS_ASSUME_NONNULL_END
