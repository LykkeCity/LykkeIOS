//
// UIColor+Generic.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *const BORDER_COLOR = @"D3D6DB";
static NSString *const MAIN_COLOR = @"AB00FF";

@interface HSBColor : NSObject {
    
}

@property (nonatomic) CGFloat hue;
@property (nonatomic) CGFloat sat;
@property (nonatomic) CGFloat bri;

@end


@interface UIColor (Generic)

@property (nonatomic, readonly) CGFloat red;
@property (nonatomic, readonly) CGFloat green;
@property (nonatomic, readonly) CGFloat blue;
@property (nonatomic, readonly) CGFloat alpha;

// brightness > 1 = more bright
// brightness < 1 = less bright
- (UIColor *) colorWithAdjustedBrightness:(CGFloat)brightness;

+ (UIColor *) colorWithR:(int)r g:(int)g b:(int)b;
+ (UIColor *) colorWithR:(int)r g:(int)g b:(int)b a:(int)a;

//
// Hex support
//

// takes 0x123456
+ (UIColor *) colorWithHex:(UInt32)col;

// takes @"123456"
+ (UIColor *) colorWithHexString:(NSString *)str;

// returns @"123456"
- (NSString *) hexString;

// returns 0x123456
- (UInt32) hex;

- (UIImage *)imageWithSize:(CGSize)size;

@end

UIColor * UIColorWithRGB(int r, int g, int b);
UIColor * UIColorWithRGBA(int r, int g, int b, int a);
