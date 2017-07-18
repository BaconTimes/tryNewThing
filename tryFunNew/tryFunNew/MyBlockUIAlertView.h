//
//  MyBlockUIAlertView.h
//  
//
//  Created by zengxiangrong on 15/11/10.
//
//

#import <UIKit/UIKit.h>
typedef void(^ButtonBlock)(NSInteger index);
@interface MyBlockUIAlertView : UIAlertView

@property(nonatomic,copy)ButtonBlock block;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles
                  buttonBlock:(ButtonBlock)block;
-(id)initWithTitle:(NSString *)title message:(NSString *)message firstButtonTitle:(NSString *)firstButtonTitle secondButtonTitle:(NSString *)secondButtonTitle thirdButtonTitle:(NSString *)thirdButtonTitle buttonBlock:(ButtonBlock)block;


@end
