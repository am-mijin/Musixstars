/*
     File: ImperialPickerController.m
 Abstract: Controller to managed a picker view displaying imperial weights.
 
  Version: 1.5
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 
 */

#import "ImperialPickerController.h"

@interface ImperialPickerController () <UIPickerViewDataSource, UIPickerViewDelegate>
//@property (nonatomic, strong) IBOutlet UILabel *label;

@end


#pragma mark -

@implementation ImperialPickerController

// Identifiers and widths for the various components
#define COUNTRY_COMPONENT 0
#define COUNTRY_COMPONENT_WIDTH 320
#define COUNTRY_LABEL_WIDTH 300



// Identifies for component views
#define VIEW_TAG 41
#define SUB_LABEL_TAG 42
#define LABEL_TAG 43

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	
	// Number of rows depends on the currently-selected unit and the component.
    
	return [_codeForCountryDictionary count];
}

- (UIView *)labelCellWithWidth:(CGFloat)width rightOffset:(CGFloat)offset {
	
	// Create a new view that contains a label offset from the right.
	CGRect frame = CGRectMake(10.0, 0.0, width, 32.0);
	UIView *view = [[UIView alloc] initWithFrame:frame];
	view.tag = VIEW_TAG;
	
	//frame.size.width = width - offset;
	UILabel *subLabel = [[UILabel alloc] initWithFrame:frame];
	subLabel.textAlignment = NSTextAlignmentCenter;
	subLabel.backgroundColor = [UIColor clearColor];
	subLabel.font = [UIFont fontWithName:@"Seravek-Bold" size:20];
	subLabel.userInteractionEnabled = NO;
	
	subLabel.tag = SUB_LABEL_TAG;
	
	[view addSubview:subLabel];
	return view;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	
	UIView *returnView = nil;
	
	// Reuse the label if possible, otherwise create and configure a new one.
	if ((view.tag == VIEW_TAG) || (view.tag == LABEL_TAG)) {
		returnView = view;
	}
	else {
      
            returnView = [self labelCellWithWidth:COUNTRY_COMPONENT_WIDTH rightOffset:COUNTRY_LABEL_WIDTH];
      
	}
	
    NSArray * keys=  [[[_codeForCountryDictionary  allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)] mutableCopy];
    
    NSString* country = [keys objectAtIndex:row];
    
    NSString* countrycode = [_codeForCountryDictionary objectForKey:country];
    NSString* diallingCode = [self lookupCodes:countrycode];
   
    
	// The text shown in the component is just the number of the component.
	NSString *text = [NSString stringWithFormat:@"%@        +%@", country ,diallingCode];
    
 
    
	//NSLog(@" picker %@",text);
    
	// Where to set the text in depends on what sort of view it is.
	UILabel *theLabel = nil;
	if (returnView.tag == VIEW_TAG) {
		theLabel = (UILabel *)[returnView viewWithTag:SUB_LABEL_TAG];
	}
	else {
		theLabel = (UILabel *)returnView;
	}
    
	theLabel.text = text;
	return returnView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	
	return COUNTRY_COMPONENT_WIDTH;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
	// If the user chooses a new row, update the label accordingly.
	//[self updateLabel];
    NSString* str = @"";
    
    NSArray * keys=  [[[_codeForCountryDictionary  allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)] mutableCopy];
    
    NSString* country = [keys objectAtIndex:row];
    NSString* countrycode = [_codeForCountryDictionary objectForKey:country];
    NSString* diallingCode = [self lookupCodes:countrycode];
    
    NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: countrycode forKey: NSLocaleCountryCode]];
    NSString *country_en = [[[NSLocale alloc] initWithLocaleIdentifier:@"en-GB"] displayNameForKey: NSLocaleIdentifier value: identifier];
    NSLog(@"%@",country);
    
    str = [NSString stringWithFormat:@"%@-%@",country_en,diallingCode];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_PICKERVIEW_UPDATE object:str userInfo:nil];
}

-(NSString*)lookupCodes:(NSString*)countrycode
{
    
    NSDictionary* dictCodes = [NSDictionary dictionaryWithObjectsAndKeys:@"972", @"IL",
                  @"93", @"AF", @"355", @"AL", @"213", @"DZ", @"1", @"AS",
                  @"376", @"AD", @"244", @"AO", @"1", @"AI", @"1", @"AG",
                  @"54", @"AR", @"374", @"AM", @"297", @"AW", @"61", @"AU",
                  @"43", @"AT", @"994", @"AZ", @"1", @"BS", @"973", @"BH",
                  @"880", @"BD", @"1", @"BB", @"375", @"BY", @"32", @"BE",
                  @"501", @"BZ", @"229", @"BJ", @"1", @"BM", @"975", @"BT",
                  @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
                  @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
                  @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
                  @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
                  @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
                  @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
                  @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
                  @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
                  @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
                  @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
                  @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
                  @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
                  @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
                  @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
                  @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
                  @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
                  @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
                  @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
                  @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
                  @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
                  @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
                  @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
                  @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
                  @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
                  @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
                  @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
                  @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
                  @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
                  @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
                  @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
                  @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
                  @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
                  @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
                  @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
                  @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
                  @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
                  @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
                  @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
                  @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
                  @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
                  @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
                  @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
                  @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
                  @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
                  @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
                  @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
                  @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
                  @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
                  @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
                  @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
                  @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
                  @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963", @"SY",
                  @"886", @"TW", @"255", @"TZ", @"670", @"TL", @"58", @"VE",
                  @"84", @"VN", @"1", @"VG", @"1", @"VI", nil];
   
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"DiallingCodes" ofType:@"plist"];
    
    //dictCodes = [NSDictionary dictionaryWithContentsOfFile:path];
    
    return [dictCodes objectForKey:countrycode ];
    
}

- (void)setData {

    NSArray *ISOCountryCodes = [NSLocale ISOCountryCodes];
    NSMutableArray *countries = [NSMutableArray new];
    NSMutableArray *countryCodes = [NSMutableArray new];
                                    
    NSString* Identifier = @"en_UK";
    for (NSString *countryCode in ISOCountryCodes)
    {
        NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: countryCode forKey: NSLocaleCountryCode]];
        if([[UserAccount sharedInstance ].language isEqualToString:@"ko"])
        {
            Identifier = @"ko-KR";
        }
      
        NSString *country = [[[NSLocale alloc] initWithLocaleIdentifier:Identifier] displayNameForKey: NSLocaleIdentifier value: identifier];
       
        if([[self lookupCodes:countryCode] length])
        {
            [countries addObject: country];
            [countryCodes addObject:countryCode];
        }
    }
    
    _codeForCountryDictionary = [[NSDictionary alloc] initWithObjects:countryCodes forKeys:countries];
   
    [self.pickerView reloadAllComponents];
    
    
}

	
@end
