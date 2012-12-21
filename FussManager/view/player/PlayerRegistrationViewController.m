//
//  PlayerRegistrationViewController.m
//  FussballManager
//
//  Created by Sven Aanesen on 01.11.12.
//  Copyright (c) 2012 Eniro. All rights reserved.
//

#import "PlayerRegistrationViewController.h"
#import "AppDelegate.h"
#import "AppModel.h"
#import "ConnectionManager.h"

#define kTextField1tag  11
#define kTextField2tag  22


@interface PlayerRegistrationViewController ()
- (void)registerButtonTouch:(id)sender;
@end

@implementation PlayerRegistrationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // build interface
        CGRect deviceframe = self.view.frame;
        deviceframe.size = [[AppModel getAppModel] deviceSize];
        self.view.frame = deviceframe;
        
        // add background
        UIImage *background = [UIImage imageNamed:@"background.png"];
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:background];
        [self setView:backgroundView];
        
        contentView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        [contentView setBackgroundColor:[UIColor clearColor]];
        [[self view] addSubview:contentView];
        
        // add header title
        UIImage *titleimage = [UIImage imageNamed:@"headertitle_newplayer.png"];
        UIImageView *titleimageView = [[UIImageView alloc] initWithImage:titleimage];
        CGRect titleframe = titleimageView.frame;
        titleframe.origin.x = (self.view.frame.size.width / 2) - (titleimage.size.width / 2);
        titleframe.origin.y = 90;
        titleimageView.frame = titleframe;
        [contentView addSubview:titleimageView];
        
        // add player icon
        UIImage *playerimage = [UIImage imageNamed:@"player"];
        UIImageView *playerimageView = [[UIImageView alloc] initWithImage:playerimage];
        CGRect playerframe = playerimageView.frame;
        playerframe.origin.x = 180;
        playerframe.origin.y = (self.view.frame.size.height / 2) - (playerimage.size.height / 2);
        playerimageView.frame = playerframe;
        [contentView addSubview:playerimageView];
        
        // add input fields with headers
        UIFont *inputFieldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        
        UIImage *inputheader1 = [UIImage imageNamed:@"inputfield_header_name.png"];
        UIImageView *inputheaderView1 = [[UIImageView alloc] initWithImage:inputheader1];
        
        UIImage *inputfield1 = [UIImage imageNamed:@"registrationfield.png"];
        UIImageView *inputfield1View = [[UIImageView alloc] initWithImage:inputfield1];
        
        float totalSize = inputheader1.size.height + inputfield1.size.height;
        
        CGRect headerview1frame = inputheaderView1.frame;
        headerview1frame.origin.x = (self.view.frame.size.width / 2) - 100;
        headerview1frame.origin.y = (self.view.frame.size.height / 2) - totalSize - 15;
        inputheaderView1.frame = headerview1frame;
        [contentView addSubview:inputheaderView1];
        
        CGRect inputfield1frame = inputfield1View.frame;
        inputfield1frame.origin.x = (self.view.frame.size.width / 2) - 100;
        inputfield1frame.origin.y = (self.view.frame.size.height / 2) - totalSize - 15 + headerview1frame.size.height;
        inputfield1View.frame = inputfield1frame;
        [contentView addSubview:inputfield1View];
        
        int textfieldpadding = 20;
        CGSize inputSize = [@"test" sizeWithFont:inputFieldFont];
        UITextField *textfield1 = [[UITextField alloc] initWithFrame:inputfield1frame];
        CGRect fieldframe = CGRectMake(inputfield1frame.origin.x + textfieldpadding,
                                       inputfield1frame.origin.y + (inputfield1frame.size.height / 2) - (inputSize.height / 2),
                                       inputfield1frame.size.width - (textfieldpadding*2),
                                       inputSize.height);
        textfield1.frame = fieldframe;
        textfield1.returnKeyType = UIReturnKeyNext;
        [textfield1 setTag:kTextField1tag];
        [textfield1 setFont:inputFieldFont];
        [textfield1 setDelegate:self];
        [textfield1 setBackgroundColor:[UIColor clearColor]];
        [textfield1 setPlaceholder:@"brukernavn"];
        [textfield1 setClearButtonMode:UITextFieldViewModeWhileEditing];
        [contentView addSubview:textfield1];
        
        
        UIImage *inputheader2 = [UIImage imageNamed:@"inputfield_header_department.png"];
        UIImageView *inputheaderView2 = [[UIImageView alloc] initWithImage:inputheader2];
        
        UIImage *inputfield2 = [UIImage imageNamed:@"registrationfield.png"];
        UIImageView *inputfield2View = [[UIImageView alloc] initWithImage:inputfield2];
        
        totalSize = inputheader2.size.height + inputfield2.size.height;
        
        CGRect headerview2frame = inputheaderView2.frame;
        headerview2frame.origin.x = (self.view.frame.size.width / 2) - 100;
        headerview2frame.origin.y = (self.view.frame.size.height / 2) + 15;
        inputheaderView2.frame = headerview2frame;
        [contentView addSubview:inputheaderView2];
        
        CGRect inputfield2frame = inputfield2View.frame;
        inputfield2frame.origin.x = (self.view.frame.size.width / 2) - 100;
        inputfield2frame.origin.y = (self.view.frame.size.height / 2) + 15 + headerview2frame.size.height;
        inputfield2View.frame = inputfield2frame;
        [contentView addSubview:inputfield2View];
        
        UITextField *textfield2 = [[UITextField alloc] initWithFrame:inputfield2frame];
        fieldframe = CGRectMake(inputfield2frame.origin.x + textfieldpadding,
                                inputfield2frame.origin.y + (inputfield2frame.size.height / 2) - (inputSize.height / 2),
                                inputfield2frame.size.width - (textfieldpadding*2),
                                inputSize.height);
        textfield2.frame = fieldframe;
        textfield2.returnKeyType = UIReturnKeySend;
        [textfield2 setTag:kTextField2tag];
        [textfield2 setFont:inputFieldFont];
        [textfield2 setDelegate:self];
        [textfield2 setBackgroundColor:[UIColor clearColor]];
        [textfield2 setPlaceholder:@"navn på avdeling / team"];
        [textfield2 setClearButtonMode:UITextFieldViewModeWhileEditing];
        [contentView addSubview:textfield2];
        
        // add register button
        UIImage *buttonimage = [UIImage imageNamed:@"button_register.png"];
        UIButton *buttonView = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonView setImage:buttonimage forState:UIControlStateNormal];
        [buttonView addTarget:self action:@selector(registerButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        CGRect buttonframe = buttonView.frame;
        buttonframe.origin.x = inputfield2frame.origin.x + inputfield2frame.size.width - buttonimage.size.width;
        buttonframe.origin.y = inputfield2frame.origin.y + inputfield2frame.size.height + 30;
        buttonframe.size = buttonimage.size;
        buttonView.frame = buttonframe;
        [contentView addSubview:buttonView];
        
        // add close button
        UIImage *closeimage = [UIImage imageNamed:@"close.png"];
        UIButton *closebtnView = [UIButton buttonWithType:UIButtonTypeCustom];
        [closebtnView setImage:closeimage forState:UIControlStateNormal];
        [closebtnView addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
        
        buttonframe = closebtnView.frame;
        buttonframe.origin.x = self.view.frame.size.width - closeimage.size.width - 10;
        buttonframe.origin.y = 10;
        buttonframe.size = closeimage.size;
        closebtnView.frame = buttonframe;
        [contentView addSubview:closebtnView];

        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerButtonTouch:(id)sender
{
    [self registerUserInput];
}


- (void)registerUserInput
{
    NSString *playerName = [(UITextField *)[contentView viewWithTag:kTextField1tag] text];
    NSString *departmentName = [(UITextField *)[contentView viewWithTag:kTextField2tag] text];
    
    if ([playerName length] == 0) {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Fyll ut brukernavn" message:@"Du må skrive inn et brukernavn før du kan registrere noe." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertview show];
        
    } else {
        // connect and register user
        [[ConnectionManager getInstance] addPlayerWithName:playerName andDepartmentName:departmentName];
        
        [self dismissView];
        
    }
}

- (void)dismissView
{
    // dismiss the view
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Dismissed...");
    }];
}

#pragma mark - Textfield delegate

- (void)keyboardWillShow:(NSNotification *)info
{
    CGRect contentframe = contentView.frame;
    contentframe.size.height += 450;
    
    [contentView setContentSize:contentframe.size];
    [contentView scrollRectToVisible:CGRectMake(0,
                                                contentframe.size.height - self.view.frame.size.height,
                                                contentView.frame.size.width,
                                                contentView.frame.size.height) animated:YES];
    
}

- (void)keyboardWillHide:(NSNotification *)info
{
    CGRect contentframe = self.view.frame;
    
    [contentView setContentSize:contentframe.size];
    [contentView scrollRectToVisible:CGRectMake(0,
                                                contentframe.size.height - self.view.frame.size.height,
                                                contentView.frame.size.width,
                                                contentView.frame.size.height) animated:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    int fieldtag = [textField tag];
    if (fieldtag == kTextField1tag) {
        // set focus to next textfield
        [[contentView viewWithTag:kTextField2tag] becomeFirstResponder];
        
    } else if (fieldtag == kTextField2tag) {
        // register the input values and dismiss this view
        [self registerUserInput];
    }
    return YES;
}

@end
