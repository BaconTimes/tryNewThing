//
//  MyBlockUIAlertView.m
//  
//
//  Created by zengxiangrong on 15/11/10.
//
//

#import "MyBlockUIAlertView.h"

@implementation MyBlockUIAlertView

-(id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles buttonBlock:(ButtonBlock)block
{
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    if (self !=nil) {
        self.block = block;
    }
    return self;
}

-(id)initWithTitle:(NSString *)title message:(NSString *)message firstButtonTitle:(NSString *)firstButtonTitle secondButtonTitle:(NSString *)secondButtonTitle thirdButtonTitle:(NSString *)thirdButtonTitle buttonBlock:(ButtonBlock)block
{
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:thirdButtonTitle otherButtonTitles:firstButtonTitle,secondButtonTitle, nil];
    if (self !=nil) {
        self.block = block;
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(_block){
        _block(buttonIndex);
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    NSLog(@"%s",__FUNCTION__);
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@", self);
    return self;
}
@end
