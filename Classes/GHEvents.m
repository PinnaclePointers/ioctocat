#import "GHEvents.h"
#import "GHEvent.h"
#import "GHRepository.h"
#import "IOCDefaultsPersistence.h"


@implementation GHEvents

@synthesize resourcePath = _resourcePath;

- (id)initWithRepository:(GHRepository *)repo {
	NSString *path = [NSString stringWithFormat:kRepoEventsFormat, repo.owner, repo.name];
	return [self initWithPath:path];
}

- (void)setResourcePath:(NSString *)path {
	_resourcePath = path;
	self.lastUpdate = [IOCDefaultsPersistence lastUpdateForPath:self.resourcePath];
}

- (void)setValues:(id)values {
	self.items = [NSMutableArray array];
	for (NSDictionary *dict in values) {
		GHEvent *event = [[GHEvent alloc] initWithDict:dict];
		if (self.lastUpdate && [event.date compare:self.lastUpdate] != NSOrderedDescending) {
			[event markAsRead];
		}
		[self addObject:event];
	}
	self.lastUpdate = [NSDate date];
	[IOCDefaultsPersistence setLastUpate:self.lastUpdate forPath:self.resourcePath];
}

@end