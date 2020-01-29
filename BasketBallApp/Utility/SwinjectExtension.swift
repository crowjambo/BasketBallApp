import Foundation
import SwinjectStoryboard
import Swinject

extension SwinjectStoryboard {
	@objc class func setup() {
		defaultContainer.register(ExternalDataRetrievable.self) { _ in HttpRequestsManager() }
		defaultContainer.register(DataPersistable.self) { _ in RealmDataManager() }
		defaultContainer.register(LastUpdateTrackable.self) { _ in DefaultsManager() }
		
		defaultContainer.register(TestProtocol.self) { res in
			LoadingManager(requestsManager: res.resolve(ExternalDataRetrievable.self)!, dataManager: res.resolve(DataPersistable.self)!, defaultsManager: res.resolve(LastUpdateTrackable.self)!)
		}
		defaultContainer.register(MainViewController.self) { res in
			let controller = MainViewController()
			controller.dataLoadingManager = res.resolve(TestProtocol.self)
			return controller
		}
			
	}
	
}
