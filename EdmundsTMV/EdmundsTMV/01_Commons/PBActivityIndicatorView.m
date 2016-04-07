//
//  PBActivityIndicatorView.m


#import "PBActivityIndicatorView.h"

@implementation PBActivityIndicatorView
@synthesize isAnimating=_isAnimating, hidesWhenStopped=_hidesWhenStopped, activityIndicatorViewStyle=_activityIndicatorViewStyle, color=_color;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
		_imageView = [aDecoder decodeObjectForKey:@"_imageView"];
		_isAnimating = [aDecoder decodeBoolForKey:@"_isAnimating"];
		_hidesWhenStopped = [aDecoder decodeBoolForKey:@"_hidesWhenStopped"];
		_activityIndicatorViewStyle = (int)[aDecoder decodeIntegerForKey:@"_activityIndicatorViewStyle"];
		_color = [aDecoder decodeObjectForKey:@"_color"];
    }
    return self;
	
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithActivityIndicatorStyle:(PBActivityIndicatorViewStyle)style {
	CGRect r;
	if (style==kPBActivityIndicatorViewStyleRedLarge ||
		style==kPBActivityIndicatorViewStyleWhiteLarge ||
		style==kPBActivityIndicatorViewStyleGrayLarge)
		r = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
	else r = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    self = [super initWithFrame:r];
    if (self) {
		[self setBackgroundColor:[UIColor clearColor]];
		[self setUserInteractionEnabled:NO];
		NSString __autoreleasing *file = nil;
		_activityIndicatorViewStyle = style;
		switch (_activityIndicatorViewStyle) {
			case kPBActivityIndicatorViewStyleWhite:
			case kPBActivityIndicatorViewStyleWhiteLarge:
				_color = [UIColor whiteColor];
				file = @"activity-indicator-white_";
				break;
			case kPBActivityIndicatorViewStyleGray:
			case kPBActivityIndicatorViewStyleGrayLarge:
				_color = [UIColor grayColor];
				file = @"activity-indicator_";
				break;
			default:
				_color = [UIColor redColor];
				file = @"activity-indicator_";
				break;
		}
//		NSString __autoreleasing *dir = @"PBGLibResources.bundle/";
        
        file = @"bx_loader-";
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (int i=2; i<=12; i++) {
            [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d.png", file, i]]];
        }
		_imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@1.png",file]]];
		[_imageView setFrame:CGRectMake(-self.bounds.size.width/2, -self.bounds.size.height/2, self.bounds.size.width*2, self.bounds.size.height*2)];
		[_imageView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin |
								   UIViewAutoresizingFlexibleWidth |
								   UIViewAutoresizingFlexibleRightMargin |
								   UIViewAutoresizingFlexibleTopMargin |
								   UIViewAutoresizingFlexibleHeight |
								   UIViewAutoresizingFlexibleBottomMargin)];
		_imageView.animationImages = arr;
		_imageView.animationDuration = 12.0/24.0;
		[self addSubview:_imageView];
		_isAnimating = NO;
		_hidesWhenStopped = NO;
    }
    return self;
}

- (void)setActivityIndicatorViewStyle:(PBActivityIndicatorViewStyle)activityIndicatorViewStyle {
	[self setBackgroundColor:[UIColor clearColor]];
	[self setUserInteractionEnabled:NO];
	NSString __autoreleasing *file = nil;
	_activityIndicatorViewStyle = activityIndicatorViewStyle;
	switch (_activityIndicatorViewStyle) {
		case kPBActivityIndicatorViewStyleWhite:
		case kPBActivityIndicatorViewStyleWhiteLarge:
			_color = [UIColor whiteColor];
			file = @"activity-indicator_";
			break;
		case kPBActivityIndicatorViewStyleGray:
		case kPBActivityIndicatorViewStyleGrayLarge:
			_color = [UIColor grayColor];
			file = @"activity-indicator_";
			break;
		default:
			_color = [UIColor redColor];
			file = @"activity-indicator_";
			break;
	}
	//		NSString __autoreleasing *dir = @"PBGLibResources.bundle/";
    
    file = @"bx_loader-";
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i=2; i<=12; i++) {
        [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d.png", file, i]]];
    }
    
	_imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@1.png",file]]];
	[_imageView setFrame:CGRectMake(-self.bounds.size.width/2, -self.bounds.size.height/2, self.bounds.size.width*2, self.bounds.size.height*2)];
	[_imageView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin |
									 UIViewAutoresizingFlexibleWidth |
									 UIViewAutoresizingFlexibleRightMargin |
									 UIViewAutoresizingFlexibleTopMargin |
									 UIViewAutoresizingFlexibleHeight |
									 UIViewAutoresizingFlexibleBottomMargin)];
	
    _imageView.animationImages = arr;
	_imageView.animationDuration = 12.0/24.0;
	[self addSubview:_imageView];
	_isAnimating = NO;
	_hidesWhenStopped = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setHidesWhenStopped:(BOOL)hidesWhenStopped {
	_hidesWhenStopped = hidesWhenStopped;
	if (!_isAnimating && _hidesWhenStopped) [_imageView setHidden:YES];
	else [_imageView setHidden:NO];
}

- (void)startAnimating {
	[_imageView setHidden:NO];
	[_imageView startAnimating];
	_isAnimating = YES;
}

- (void)stopAnimating {
	[_imageView stopAnimating];
	_isAnimating = NO;
	if (_hidesWhenStopped) [_imageView setHidden:YES];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:_imageView forKey:@"_imageView"];
	[aCoder encodeBool:_isAnimating forKey:@"_isAnimating"];
	[aCoder encodeBool:_hidesWhenStopped forKey:@"_hidesWhenStopped"];
	[aCoder encodeInteger:_activityIndicatorViewStyle forKey:@"_activityIndicatorViewStyle"];
	[aCoder encodeObject:_color forKey:@"_color"];
}

@end
