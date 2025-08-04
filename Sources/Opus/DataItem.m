#import "DataItem.h"

@interface DataItem () {
    NSMutableData *_data;
}

@end

@implementation DataItem

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _data = [[NSMutableData alloc] init];
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self != nil) {
        _data = [[NSMutableData alloc] init];
        [self appendData:data];
    }
    return self;
}

- (void)appendData:(NSData *)data {
    [_data appendData:data];
}

- (NSData *)data {
    return _data;
}

@end
