//
//  CommonUserDefaults.swift
//  BeckBucks
//
//  Created by 백상휘 on 2022/05/16.
//

import Foundation
import RxSwift

class CommonUserDefaults {
  
  static func getInitialEventDismissDate() -> Single<String> {
    Single<String>.create { single in
      let value = UserDefaults.standard.string(forKey: CommonUserDefaultsKeys.InitialEventDismissDate.rawValue) ?? ""
      single(.success(value))
      return Disposables.create()
    }
  }
  
  static func setInitialEventDismissDate(_ dateString: String) -> Completable {
    Completable.create { observer in
      UserDefaults.standard.setValue(dateString, forKey: CommonUserDefaultsKeys.InitialEventDismissDate.rawValue)
      observer(.completed)
      return Disposables.create()
    }
  }
  
  static func resetInitialEventDismissDate() -> Disposable {
    Completable.create { observer in
      observer(.completed)
      return Disposables.create()
    }
    .subscribe { _ in
      UserDefaults.standard.setValue("", forKey: CommonUserDefaultsKeys.InitialEventDismissDate.rawValue)
    }
  }
}

enum CommonUserDefaultsKeys: String {
  case InitialEventDismissDate
  
}

enum InitialEventStatus {
  case noLookToday
  case none
}
