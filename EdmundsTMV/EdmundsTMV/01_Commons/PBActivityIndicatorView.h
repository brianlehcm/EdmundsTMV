//
//  PBActivityIndicatorView.h

#import <UIKit/UIKit.h>

typedef enum {
	kPBActivityIndicatorViewStyleRed = 0x00,
	kPBActivityIndicatorViewStyleWhite = 0x01,
	kPBActivityIndicatorViewStyleGray = 0x02,
	kPBActivityIndicatorViewStyleRedLarge = 0x10,
	kPBActivityIndicatorViewStyleWhiteLarge = 0x11,
	kPBActivityIndicatorViewStyleGrayLarge = 0x12
} PBActivityIndicatorViewStyle;


@interface PBActivityIndicatorView : UIView {
	UIImageView __strong *_imageView;
	BOOL _isAnimating;
	BOOL _hidesWhenStopped;
	PBActivityIndicatorViewStyle _activityIndicatorViewStyle;
	UIColor __strong *_color;
}

@property (nonatomic, readonly) BOOL isAnimating;
@property (nonatomic) BOOL hidesWhenStopped;
@property (nonatomic) PBActivityIndicatorViewStyle activityIndicatorViewStyle;
@property (strong, nonatomic) UIColor *color;

- (id)initWithActivityIndicatorStyle:(PBActivityIndicatorViewStyle)style;

- (void)startAnimating;
- (void)stopAnimating;

@end
