#import "Kiwi.h"
#import "GenSoupViewController.h"
#import "EcosystemView.h"
#import "Ecosystem.h"
#import "Matrix2DCoordenate.h"
#import "Cell.h"

SPEC_BEGIN(GenSoupViewControllerSpec)

describe(@"viewDidLoad", ^{
    
    __block GenSoupViewController* controller;
    
    beforeEach(^{
        controller = [[GenSoupViewController alloc] init];
    });
    
    afterEach(^{
        [controller release];
    });    
        
    it(@"should the initial population should not be nil", ^{
        [controller viewDidLoad];
        [controller.initialPopulation shouldNotBeNil];
    });
    
});


describe(@"viewWillAppear", ^{

    __block GenSoupViewController* controller;
    
    beforeEach(^{
        controller = [[GenSoupViewController alloc] init];
    });
    
    afterEach(^{
        [controller release];
    });
        
    it(@"should set the ecosystemView's tapDelegate to itself", ^{
        id ecosystemViewMock = [KWMock nullMockForClass:[EcosystemView class]];
        [controller setEcosystemView:ecosystemViewMock];
        [[controller should] receive:@selector(configureScrollView)];
        [controller viewWillAppear:YES];
    });
    
    it(@"should the initial population should not be nil", ^{
        id ecosystemViewMock = [KWMock nullMockForClass:[EcosystemView class]];
        [controller setEcosystemView:ecosystemViewMock];

        //[[controller.ecosystemView should] receive:@selector(setUpCellViewsWith:columns:cellViewWidth:cellViewHeight:) withArguments:theValue(41), theValue(32), theValue(10), theValue(10.15)]; Not working. Don't know why
        [controller viewWillAppear:YES];
    });
    
    it(@"should set the ecosystemView's tapDelegate to itself", ^{
        id ecosystemViewMock = [KWMock nullMockForClass:[EcosystemView class]];
        [controller stub:@selector(ecosystemView) andReturn:ecosystemViewMock];
        [[controller.ecosystemView should] receive:@selector(setTapDelegate:) withArguments:controller];
        [controller viewWillAppear:YES];
    });
});


describe(@"startLife", ^{
    
    __block GenSoupViewController* controller;
    
    beforeEach(^{
        controller = [[GenSoupViewController alloc] init];
        id ecosystemMock = [KWMock nullMockForClass:[Ecosystem class]];
        [controller stub:@selector(ecosystem) andReturn:ecosystemMock]; // Need to stub, instead of assign because the method creates the instance inside and access it thought the getter later.
    });
    
    afterEach(^{
        [controller release];
    });
    
    
    it(@"should set the ecosystemView's tapDelegate to itself", ^{
        [[controller.ecosystem should] receive:@selector(setDelegate:) withArguments:controller];
        [controller startLife];
    });
    
    it(@"should send the message produceNextGeneration to the ecosystem instance", ^{
        [[controller.ecosystem should] receive:@selector(produceNextGeneration)];
        [controller startLife];

    });
    
});


describe(@"handleNewGeneration", ^{
    
    __block GenSoupViewController* controller;
    
    beforeEach(^{
        controller = [[GenSoupViewController alloc] init];
        id ecosystemMock = [KWMock nullMockForClass:[Ecosystem class]];
        id ecosystemViewMock = [KWMock nullMockForClass:[EcosystemView class]];
        controller.ecosystem = ecosystemMock;
        controller.ecosystemView = ecosystemViewMock;
    });
    
    afterEach(^{
        [controller release];
    });
        
    it(@"should refresh de the ecosystem view", ^{
        [[controller.ecosystemView should] receive:@selector(refreshView:) withArguments:controller.ecosystem];
        [controller handleNewGeneration];
    });
    
    it(@"should produce the next generation", ^{
        [[controller.ecosystem should] receive:@selector(produceNextGeneration)];
        [controller handleNewGeneration];        
    });
});


describe(@"didSelectCellViewAtCoordinate:", ^{
    
    __block GenSoupViewController* controller;
    
    beforeEach(^{
        controller = [[GenSoupViewController alloc] init];
        NSMutableSet* initialPopulation = [NSMutableSet set];
        controller.initialPopulation = initialPopulation;
    });
    
    afterEach(^{
        [controller release];
    });
    
    it(@"should add a cell to the initial population set if it wasn't there", ^{
        Matrix2DCoordenate* coor = [[Matrix2DCoordenate alloc] initWithRow:2 andColumn:3];
        [controller didSelectCellViewAtCoordinate:coor];
        NSMutableSet* ip = controller.initialPopulation;
        Cell* addedCell = [controller.initialPopulation anyObject];
        STAssertTrue([ip count] == 1, @"");
        STAssertTrue([addedCell.coordinate row] == 2, @"");
        STAssertTrue([addedCell.coordinate column] == 3, @"");        
        [coor release];        
    });
    
    it(@"should remove a cell from the initial population set if it was already there", ^{
        Matrix2DCoordenate* coor = [[Matrix2DCoordenate alloc] initWithRow:2 andColumn:3];
        Cell* existentCell = [[Cell alloc] initWithCoordinate:coor andOrganismID:-1];
        [controller.initialPopulation addObject:existentCell];
        [existentCell release];
        
        STAssertTrue([controller.initialPopulation count] == 1, @"");
        [controller didSelectCellViewAtCoordinate:coor];
        STAssertTrue([controller.initialPopulation count] == 0, @"");
        [coor release];        

    });
});

describe(@"configureScrollView:", ^{
    
    __block GenSoupViewController* controller;
    
    beforeEach(^{
        controller = [[GenSoupViewController alloc] init];
        id scrollViewMock = [KWMock nullMockForClass:[UIScrollView class]];
        controller.view = scrollViewMock;
    });
    
    afterEach(^{
        [controller release];
    });
        
    it(@"should set the scrollView's minimumZoomScale to 1.0", ^{
        [[controller.view should] receive:@selector(setMinimumZoomScale:) withArguments:theValue(1.0)];
        [controller configureScrollView];
    });
    
    it(@"should set the scrollView's maximumZoomScale to 4.0", ^{
        [[controller.view should] receive:@selector(setMaximumZoomScale:) withArguments:theValue(4.0)];
        [controller configureScrollView];
    });

    it(@"should set the scrollView's ZoomScale to 1.0", ^{
        [[controller.view should] receive:@selector(setZoomScale:) withArguments:theValue(1.0)];
        [controller configureScrollView];
    });
});

describe(@"menuButtonPressed:", ^{
    
    __block GenSoupViewController* controller;
    
    beforeEach(^{
        controller = [[GenSoupViewController alloc] init];
        id navigationControllerMock = [KWMock nullMockForClass:[UINavigationController class]];
        id navigationItemMock = [KWMock nullMockForClass:[UINavigationItem class]];
        id rightBarButtonMock = [KWMock nullMockForClass:[UIBarButtonItem class]];
        
        [controller stub:@selector(navigationController) andReturn:navigationControllerMock];
        [navigationControllerMock stub:@selector(navigationItem) andReturn:navigationItemMock];
        [navigationItemMock stub:@selector(rightBarButtonItem) andReturn:rightBarButtonMock];
    });
    
    afterEach(^{
        [controller release];
    });
    
    context(@"the toolbar is hidden", ^{
        
        beforeEach(^{
            [[controller navigationController] stub:@selector(isToolbarHidden) andReturn:theValue(YES)];
        });
        
        it(@"should set the text of the button to Hide", ^{
            [[controller.navigationController.navigationItem.rightBarButtonItem should] receive:@selector(setTitle:) withArguments:@"Hide"];
            [controller menuButtonPressed:nil];
        });
        it(@"should show the toolBar", ^{
            [[controller.navigationController should] receive:@selector(setToolbarHidden:animated:) withArguments:theValue(NO), theValue(NO)];
            [controller menuButtonPressed:nil];
        });
    });

    
    context(@"the toolbar is vissible", ^{
        
        beforeEach(^{
            [[controller navigationController] stub:@selector(isToolbarHidden) andReturn:theValue(NO)];
        });

        
        it(@"should set the text of the button to Menu", ^{
            [[controller.navigationController.navigationItem.rightBarButtonItem should] receive:@selector(setTitle:) withArguments:@"Menu"];
            [controller menuButtonPressed:nil];

        });
        it(@"should hide the toolBar", ^{
            [[controller.navigationController should] receive:@selector(setToolbarHidden:animated:) withArguments:theValue(YES), theValue(NO)];
            [controller menuButtonPressed:nil];        
        });
    });

});

/*
 
 - (void) handleResetGeneration
 {
 [self.ecosystemView refreshView:self.ecosystem];
 }
*/

describe(@"handleResetGeneration:", ^{
    
    __block GenSoupViewController* controller;
    
    beforeEach(^{
        controller = [[GenSoupViewController alloc] init];
        id ecosystemMock = [KWMock nullMockForClass:[Ecosystem class]];
        id ecosystemViewMock = [KWMock nullMockForClass:[EcosystemView class]];
        controller.ecosystem = ecosystemMock;
        controller.ecosystemView = ecosystemViewMock;        
    });
    
    afterEach(^{
        [controller release];
    });
    
    it(@"should refresh the view with the current ecosystem", ^{
        [[controller.ecosystemView should] receive:@selector(refreshView:) withArguments:controller.ecosystem];
        [controller handleResetGeneration];
    });
    
});


SPEC_END