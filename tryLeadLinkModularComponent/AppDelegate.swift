//
//  AppDelegate.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 17/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Realm
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let bag = DisposeBag()
    private let dataPersister = RealmDataPersister()
    private let realm = try! Realm.init()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //loadResources()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        return true
    }
    
    private func loadResources() {
        guard let questionsURL = URL.getResourceUrl(forType: Question.self) else {return}
        let resource = Resource<Questions>(url: questionsURL)
        URLRequest.load(resource: resource)
            .subscribe(onNext: { [weak self] questions in
                guard let strongSelf = self else {return}
                let realmQuestions = questions.data.map { question -> RealmQuestion in
                    let realmQuestion = RealmQuestion.init()
                    realmQuestion.updateWith(question: question)
                    return realmQuestion
                }
                strongSelf.dataPersister
                    .saveToRealm(objects: realmQuestions)
                    .subscribe(onNext: { success in
                        print("questions saved to realm ?, \(success)")
                    })
                    .disposed(by: strongSelf.bag)
            }).disposed(by: bag)
    }

}

