import Foundation
import SwinjectStoryboard
import Swinject
import SwinjectAutoregistration

extension SwinjectStoryboard {
	@objc class func setup() {
		
		defaultContainer.storyboardInitCompleted(MainViewController.self) { (res, con) in
			con.dataLoadingManager = res.resolve(TeamsDataLoadable.self)
		}
		
		defaultContainer.register(ExternalDataRetrievable.self) { _ in HttpRequestsManager() }
		defaultContainer.register(DataPersistable.self) { _ in RealmDataManager() }
		defaultContainer.register(LastUpdateTrackable.self) { _ in DefaultsManager() }
		defaultContainer.autoregister(TeamsDataLoadable.self, initializer: LoadingManager.init)
	}
}
