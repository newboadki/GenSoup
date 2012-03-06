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
    
    it(@"should set the working ivar to NO", ^{
        [controller viewDidLoad];
        STAssertTrue([[controller valueForKey:@"working"] boolValue] == NO, @"should set the working ivar to NO");
    });
    
    it(@"should create an instance of the ecosystem using the initial population", ^{
        [controller viewDidLoad];
        [controller.ecosystem shouldNotBeNil];        
    });

    it(@"should set the ecosystemView's tapDelegate to itself", ^{        
        [controller viewDidLoad];
        [[controller.ecosystem.delegate should] equal:controller];        
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
        [controller setValue:[NSNumber numberWithBool:YES] forKey:@"firstTimeViewWillAppear"];
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
        [controller setValue:[NSNumber numberWithBool:YES] forKey:@"firstTimeViewWillAppear"];
        id ecosystemViewMock = [KWMock nullMockForClass:[EcosystemView class]];
        [controller stub:@selector(ecosystemView) andReturn:ecosystemViewMock];
        [[controller.ecosystemView should] receive:@selector(setTapDelegate:) withArguments:controller];
        [controller viewWillAppear:YES];
    });
    
    
    it(@"should not set the ecosystemView's tapDelegate to itself", ^{
        [controller setValue:[NSNumber numberWithBool:NO] forKey:@"firstTimeViewWillAppear"];
        id ecosystemViewMock = [KWMock nullMockForClass:[EcosystemView class]];
        [controller setEcosystemView:ecosystemViewMock];
        [[controller shouldNot] receive:@selector(configureScrollView)];
        [controller viewWillAppear:YES];
    });
    
    it(@"should not set the ecosystemView's tapDelegate to itself", ^{
        [controller setValue:[NSNumber numberWithBool:NO] forKey:@"firstTimeViewWillAppear"];
        id ecosystemViewMock = [KWMock nullMockForClass:[EcosystemView class]];
        [controller stub:@selector(ecosystemView) andReturn:ecosystemViewMock];
        [[controller.ecosystemView shouldNot] receive:@selector(setTapDelegate:) withArguments:controller];
        [controller viewWillAppear:YES];
    });

});


describe(@"startLife", ^{
    
    __block GenSoupViewController* controller;
    
    beforeEach(^{
        controller = [[GenSoupViewController alloc] init];
        id ecosystemMock = [KWMock nullMockForClass:[Ecosystem class]];
        [controller stub:@selector(ecosystem) andReturn:ecosystemMock]; // Need to stub, instead of assign because the method creates the instance inside and access it thought the getter later.
        id initialPopMock = [KWMock nullMockForClass:[NSMutableSet class]];
        [ecosystemMock stub:@selector(initialPopulation) andReturn:initialPopMock];        

    });
    
    afterEach(^{
        [controller release];
    });
    
    context(@"working ivar is NO and there's a initial population", ^{
        beforeEach(^{
            [controller setValue:[NSNumber numberWithBool:NO] forKey:@"working"];
            [controller.ecosystem.initialPopulation stub:@selector(count) andReturn:theValue(1)];
        });
                
        it(@"should send the message produceNextGeneration to the ecosystem instance", ^{
            NSLog(@"......%d", [controller.ecosystem.initialPopulation count]);
            [[controller.ecosystem should] receive:@selector(produceNextGeneration)];
            [controller startLife];            
        });
        
        it(@"should set up the ecosystem", ^{
            [[controller.ecosystem should] receive:@selector(setUp)];
            [controller startLife];            
        });

        it(@"should set working to YES", ^{            
            [controller startLife];       
            STAssertTrue([[controller valueForKey:@"working"] boolValue] == YES, @"should set working to YES");
        });
    });
    
    
    context(@"working ivar is YES and there's a initial population", ^{
        beforeEach(^{
            [controller setValue:[NSNumber numberWithBool:YES] forKey:@"working"];
            [controller.ecosystem.initialPopulation stub:@selector(count) andReturn:theValue(1)];
        });
                    
        it(@"should not send the message produceNextGeneration to the ecosystem instance", ^{
            [[controller.ecosystem shouldNot] receive:@selector(produceNextGeneration)];
            [controller startLife];            
        });
        
        it(@"should not set up the ecosystem", ^{
            [[controller.ecosystem shouldNot] receive:@selector(setUp)];
            [controller startLife];            
        });
        
        it(@"should not set working to YES", ^{            
            [controller startLife];       
            STAssertTrue([[controller valueForKey:@"working"] boolValue] == YES, @"should set working to NO");
        });

    });

    
    context(@"working ivar is NO and there isn't a initial population", ^{
        beforeEach(^{
            [controller setValue:[NSNumber numberWithBool:NO] forKey:@"working"];
            [controller.ecosystem.initialPopulation stub:@selector(count) andReturn:theValue(0)];
        });        
        
        it(@"should not send the message produceNextGeneration to the ecosystem instance", ^{
            [[controller.ecosystem shouldNot] receive:@selector(produceNextGeneration)];
            [controller startLife];            
        });
        
        it(@"should not set up the ecosystem", ^{
            [[controller.ecosystem shouldNot] receive:@selector(setUp)];
            [controller startLife];            
        });
        
        it(@"should not set working to YES", ^{            
            [controller startLife];       
            STAssertTrue([[controller valueForKey:@"working"] boolValue] == NO, @"should set working to NO");
        });

    });

    context(@"working ivar is YES and there isn't a initial population", ^{
        beforeEach(^{
            [controller setValue:[NSNumber numberWithBool:YES] forKey:@"working"];
            [controller.ecosystem.initialPopulation stub:@selector(count) andReturn:theValue(0)];
        });        
        
        it(@"should not send the message produceNextGeneration to the ecosystem instance", ^{
            [[controller.ecosystem shouldNot] receive:@selector(produceNextGeneration)];
            [controller startLife];            
        });
        
        it(@"should not set up the ecosystem", ^{
            [[controller.ecosystem shouldNot] receive:@selector(setUp)];
            [controller startLife];            
        });
        
        it(@"should not set working to YES", ^{            
            [controller startLife];       
            STAssertTrue([[controller valueForKey:@"working"] boolValue] == YES, @"should set working to NO");
        });

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
        
    it(@"should refresh the view with the ecosystem", ^{
        [[controller.ecosystemView should] receive:@selector(refreshView:) withArguments:controller.ecosystem];
        [controller handleNewGeneration];
    });
    
    context(@"working ivar is NO", ^{
        beforeEach(^{
            [controller setValue:[NSNumber numberWithBool:NO] forKey:@"working"];
        });
                
        context(@"resetScheduled ivar is NO", ^{
            beforeEach(^{
                [controller setValue:[NSNumber numberWithBool:NO] forKey:@"resetScheduled"];
            });            
            
            it(@"should not produce the next generation", ^{
                [[controller.ecosystem shouldNot] receive:@selector(produceNextGeneration)];
                [controller handleNewGeneration];            
            });
            
            it(@"should not send the message resetEcosystem to itself", ^{
                [[controller shouldNot] receive:@selector(resetEcosystem)];
                [controller handleNewGeneration];
            });
            
            it(@"should not reset the ecosystem view", ^{
                [[controller.ecosystemView shouldNot] receive:@selector(reset)];
                [controller handleNewGeneration];
            });
            
            it(@"should not set resetScheduled to NO", ^{
                [controller handleNewGeneration];
                STAssertTrue([[controller valueForKey:@"resetScheduled"] boolValue] == NO, @"should not set resetScheduled to NO");                
            });
            
            it(@"should not set working to NO", ^{
                [controller handleNewGeneration];
                STAssertTrue([[controller valueForKey:@"working"] boolValue] == NO, @"should not set working to NO");
            });
        });
        
        context(@"resetScheduled ivar is YES", ^{
            beforeEach(^{
                [controller setValue:[NSNumber numberWithBool:YES] forKey:@"resetScheduled"];
            }); 
            
            it(@"should not produce the next generation", ^{
                [[controller.ecosystem shouldNot] receive:@selector(produceNextGeneration)];
                [controller handleNewGeneration];            
            });
            
            it(@"should not send the message resetEcosystem to itself", ^{
                [[controller shouldNot] receive:@selector(resetEcosystem)];
                [controller handleNewGeneration];
            });
            
            it(@"should not reset the ecosystem view", ^{
                [[controller.ecosystemView shouldNot] receive:@selector(reset)];
                [controller handleNewGeneration];
            });
        });        
    });
    
    context(@"working ivar is YES", ^{
        beforeEach(^{
            [controller setValue:[NSNumber numberWithBool:YES] forKey:@"working"];
        });
        
        context(@"resetScheduled ivar is NO", ^{
            beforeEach(^{
                [controller setValue:[NSNumber numberWithBool:NO] forKey:@"resetScheduled"];
            });
            
            it(@"should produce the next generation", ^{
                [[controller.ecosystem should] receive:@selector(produceNextGeneration)];
                [controller handleNewGeneration];            
            });
            
            it(@"should not send the message resetEcosystem to itself", ^{
                [[controller shouldNot] receive:@selector(resetEcosystem)];
                [controller handleNewGeneration];
            });
            
            it(@"should not reset the ecosystem view", ^{
                [[controller.ecosystemView shouldNot] receive:@selector(reset)];
                [controller handleNewGeneration];
            });
            
            it(@"should not set resetScheduled to NO", ^{
                [controller handleNewGeneration];
                STAssertTrue([[controller valueForKey:@"resetScheduled"] boolValue] == NO, @"should not set resetScheduled to NO");                
            });
            
            it(@"should not set working to NO", ^{
                [controller handleNewGeneration];
                STAssertTrue([[controller valueForKey:@"working"] boolValue] == YES, @"should not set working to NO");
            });
        });
        
        context(@"resetScheduled ivar is YES", ^{
            beforeEach(^{
                [controller setValue:[NSNumber numberWithBool:YES] forKey:@"resetScheduled"];
            });
            
            it(@"should send the message resetEcosystem to itself", ^{
                [[controller should] receive:@selector(resetEcosystem)];
                [controller handleNewGeneration];
            });
            
            it(@"should reset the ecosystem view", ^{
                [[controller.ecosystemView should] receive:@selector(reset)];
                [controller handleNewGeneration];
            });
            
            it(@"should set resetScheduled to NO", ^{
                [controller handleNewGeneration];
                STAssertTrue([[controller valueForKey:@"resetScheduled"] boolValue] == NO, @"should set resetScheduled to NO");                
            });
            
            it(@"should set working to NO", ^{
                [controller handleNewGeneration];
                STAssertTrue([[controller valueForKey:@"working"] boolValue] == NO, @"should set working to NO");
            });
        });        
    });      
});


describe(@"didSelectCellViewAtCoordinate:", ^{
    
    __block GenSoupViewController* controller;
    
    beforeEach(^{
        controller = [[GenSoupViewController alloc] init];
        NSMutableSet* initialPopulation = [NSMutableSet set];
        controller.initialPopulation = initialPopulation;
        Ecosystem* ecosystem = [[Ecosystem alloc] initWithRows:5 andColumns:5 andInitialPopulation:initialPopulation];
        controller.ecosystem = ecosystem;
        [ecosystem release];
    });
    
    afterEach(^{
        [controller release];
    });
    
    it(@"should add a cell to the initial population set if it wasn't there", ^{
        Matrix2DCoordenate* coor = [[Matrix2DCoordenate alloc] initWithRow:2 andColumn:3];
        [controller didSelectCellViewAtCoordinate:coor];
        NSMutableSet* ip = controller.ecosystem.initialPopulation;
        Cell* addedCell = [controller.ecosystem.initialPopulation anyObject];
        STAssertTrue([ip count] == 1, @"");
        STAssertTrue([addedCell.coordinate row] == 2, @"");
        STAssertTrue([addedCell.coordinate column] == 3, @"");        
        [coor release];        
    });
    
    it(@"should remove a cell from the initial population set if it was already there", ^{
        Matrix2DCoordenate* coor = [[Matrix2DCoordenate alloc] initWithRow:2 andColumn:3];
        Cell* existentCell = [[Cell alloc] initWithCoordinate:coor andOrganismID:-1];
        [controller.ecosystem.initialPopulation addObject:existentCell];
        [existentCell release];
        
        STAssertTrue([controller.ecosystem.initialPopulation count] == 1, @"");
        [controller didSelectCellViewAtCoordinate:coor];
        STAssertTrue([controller.ecosystem.initialPopulation count] == 0, @"");
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

describe(@"resetEcosystem", ^{
    
    __block GenSoupViewController* controller;
    
    beforeEach(^{
        controller = [[GenSoupViewController alloc] init];
        id ecosystemMock = [KWMock nullMockForClass:[Ecosystem class]];
        id initialPopulationMock = [KWMock nullMockForClass:[NSMutableSet class]];
        controller.initialPopulation = initialPopulationMock;
        controller.ecosystem = ecosystemMock;
        id ecosystemViewMock = [KWMock nullMockForClass:[EcosystemView class]];
        [controller setEcosystemView:ecosystemViewMock];
    });
    
    afterEach(^{
        [controller release];
    });

    
    it(@"should empty the initial population", ^{
        [[controller.initialPopulation should] receive:@selector(removeAllObjects)];
        [controller resetEcosystem];
    });

    it(@"should reset the ecosystem", ^{
        [[controller.ecosystem should] receive:@selector(reset)];
        [controller resetEcosystem];
    });
    
    it(@"should reset the ecosystem's view", ^{
        [[controller.ecosystemView should] receive:@selector(reset)];
        [controller resetEcosystem];
    });

});


describe(@"pauseLife", ^{
    
    __block GenSoupViewController* controller;
    
    beforeEach(^{
        controller = [[GenSoupViewController alloc] init];
    });
    
    afterEach(^{
        [controller release];
    });
    
    
    it(@"should set working to NO", ^{
        [controller setValue:[NSNumber numberWithBool:YES] forKey:@"working"];
        [controller pauseLife];
        STAssertTrue([[controller valueForKey:@"working"] boolValue] == NO, @"should empty the initial population");
    });    
});

describe(@"resumeLife", ^{
    
    __block GenSoupViewController* controller;
    
    beforeEach(^{
        controller = [[GenSoupViewController alloc] init];
        id ecosystemMock = [KWMock nullMockForClass:[Ecosystem class]];
        id aliveCellsMock = [KWMock nullMockForClass:[NSMutableSet class]];
        controller.ecosystem = ecosystemMock;
        [ecosystemMock stub:@selector(aliveCells) andReturn:aliveCellsMock];
    });
    
    afterEach(^{
        [controller release];
    });
    
    
    it(@"should not produce the next generation if there are cells in aliveCells and working is YES", ^{
        [controller.ecosystem.aliveCells stub:@selector(count) andReturn:theValue(2)];
        [controller setValue:[NSNumber numberWithBool:YES] forKey:@"working"];
        [[controller shouldNot] receive:@selector(handleNewGeneration)];
        [controller resumeLife];        
        STAssertTrue([[controller valueForKey:@"working"] boolValue] == YES, @"should empty the initial population");
    });

    it(@"should produce the next generation if there are cells in aliveCells and working is NO", ^{
        [controller setValue:[NSNumber numberWithBool:NO] forKey:@"working"];
        [controller.ecosystem.aliveCells stub:@selector(count) andReturn:theValue(2)];
        [[controller should] receive:@selector(handleNewGeneration)];
        [controller resumeLife];
        STAssertTrue([[controller valueForKey:@"working"] boolValue] == YES, @"should empty the initial population");
    });    

    it(@"should not produce the next generation if there are not any cells in aliveCells and working is YES", ^{
        [controller setValue:[NSNumber numberWithBool:YES] forKey:@"working"];
        [controller.ecosystem.aliveCells stub:@selector(count) andReturn:theValue(0)];
        [[controller shouldNot] receive:@selector(handleNewGeneration)];
        [controller resumeLife];
        STAssertTrue([[controller valueForKey:@"working"] boolValue] == YES, @"should empty the initial population");
    });    

    it(@"should not produce the next generation if there are not any cells in aliveCells and working is NO", ^{
        [controller setValue:[NSNumber numberWithBool:NO] forKey:@"working"];
        [controller.ecosystem.aliveCells stub:@selector(count) andReturn:theValue(0)];
        [[controller shouldNot] receive:@selector(handleNewGeneration)];
        [controller resumeLife];
        STAssertTrue([[controller valueForKey:@"working"] boolValue] == NO, @"should empty the initial population");
    });    

});



SPEC_END