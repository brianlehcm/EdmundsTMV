//
//  ViewController.m
//  EdmundsTMV
//
//  Created by le brian on 4/7/16.
//  Copyright © 2016 brianle. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Reponder.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"

@interface ViewController (){
    
}

@property (weak, nonatomic) IBOutlet UIView *vWork;
@property (weak, nonatomic) IBOutlet UITextField *txtYear;
@property (weak, nonatomic) IBOutlet UITextField *txtMake;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerYConstraint;

@end

@implementation ViewController

#pragma mark -
#pragma mark - callAPI
- (void)callAPI{
    
    if (_txtYear.text.length == 0) {
        [_txtYear becomeFirstResponder];
        return;
    }
    else if(_txtMake.text.length == 0){
        [_txtMake becomeFirstResponder];
        return;
    }
    
    [self.view findAndResignFirstResponder];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.edmunds.com/api/v1/vehicle/%@/%@/price?msrp=32000&zip=90404&api_key=gga5gqer7xgpjpf7hc99xdz8", [_txtMake.text lowercaseString], _txtYear.text];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFJSONRequestSerializer *request = [AFJSONRequestSerializer serializer];
    [request setTimeoutInterval:60.0];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = request;
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        //Check response is dictionary
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            //Check response contain key "tmvUsd"
            if ([[(NSDictionary *)responseObject allKeys] containsObject:@"tmvUsd"]) {
                
                NSString *tmvUsd = [NSString stringWithFormat:@"%@", responseObject[@"tmvUsd"]];
                
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                BOOL isDecimal = [numberFormatter numberFromString:tmvUsd] != nil;
                //Check "tmvUsd" is number
                if (isDecimal)
                {
                    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                    [numberFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
                    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
                    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[tmvUsd floatValue]]];
                    _lblPrice.text = numberAsString;
                }
                
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }];
    
}

#pragma mark -
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _lblPrice.text = @"---";
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _txtYear) {
        [_txtMake becomeFirstResponder];
    }
    else{
        if (textField == _txtMake) {
            [textField resignFirstResponder];
            
            //CALL API
            [self callAPI];
        }
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == _txtYear) {
        
        //Validate Only input number 0-9
        if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)
        {
            return NO;
        }
        
        //Validate Only input year <= current year (ex: <= 2016)
        NSDateComponents *components = [[NSCalendar currentCalendar] components: NSCalendarUnitYear fromDate:[NSDate date]];
        NSString *strYear = [NSString stringWithFormat:@"%d", (int)components.year];
        NSInteger firstC = [[strYear substringToIndex:1] integerValue];
        NSInteger secondC = [[strYear substringWithRange:NSMakeRange(1, 1)] integerValue];
        NSInteger thirdC = [[strYear substringWithRange:NSMakeRange(2, 1)] integerValue];
        NSInteger fourC = [[strYear substringWithRange:NSMakeRange(3, 1)] integerValue];
        
        if (string.integerValue > firstC && range.location == 0) {
            return NO;
        }
        
        if (range.location == 1 && [[textField.text substringToIndex:1] integerValue] == firstC && string.integerValue > secondC) {
            return NO;
        }
        
        if (range.location == 2 && [[textField.text substringToIndex:1] integerValue] == firstC && [[textField.text substringWithRange:NSMakeRange(1, 1)] integerValue] == secondC && string.integerValue > thirdC) {
            return NO;
        }
        
        if (range.location == 3 && [[textField.text substringToIndex:1] integerValue] == firstC  && [[textField.text substringWithRange:NSMakeRange(1, 1)] integerValue] == secondC  && [[textField.text substringWithRange:NSMakeRange(2, 1)] integerValue] == thirdC && string.integerValue > fourC) {
            return NO;
        }
        
        NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[textField.text length]];
        for (int i=0; i < [textField.text length]; i++) {
            NSString *ichar  = [NSString stringWithFormat:@"%c", [textField.text characterAtIndex:i]];
            [characters addObject:ichar];
        }
        
        if (range.location > characters.count-1) {
            [characters addObject:string];
        }
        else{
            [characters insertObject:string atIndex:range.location];
        }
        
        NSString *full = @"";
        for (NSInteger i=0; i<characters.count; i++) {
            full = [full stringByAppendingString:characters[i]];
        }
        
        if (full.integerValue > components.year) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark -
#pragma mark - View Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _vWork.center = self.view.center;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tapHideKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapHideKeyboard.numberOfTapsRequired = 1;
    tapHideKeyboard.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapHideKeyboard];
}

#pragma mark -
#pragma mark - Search Button Clicked
- (IBAction)keyPress:(UIButton *)sender {
    //CALL API
    [self callAPI];
}

#pragma mark -
#pragma mark - UIKeyboard Notification

- (void)hideKeyboard{
    [self.view findAndResignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        NSDictionary *info = [notification userInfo];
        NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        CGRect keyboardFrame = [kbFrame CGRectValue];
        CGFloat height = keyboardFrame.size.height;
        
        
        _centerYConstraint.constant = -height/3;
        [self.view setNeedsUpdateConstraints];
        
        [UIView animateWithDuration:animationDuration animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification{
    
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    _centerYConstraint.constant = 0;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
