//
//  SearchViewController.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 06/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


 class ChooseOptionsVC: UIViewController {
 
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
 
    var dataSourceAndDelegate: QuestionOptionsTableViewDataSourceAndDelegate!
    
    private var _options = PublishSubject<UITableViewDataSource>.init()
    
    public var doneWithOptions: Observable<UITableViewDataSource> {
        return doneBtn.rx.tap
                .withLatestFrom(_options.asObservable())
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSourceAndDelegate
        tableView.delegate = dataSourceAndDelegate
        setUpBindings()
    }
    
    private func setUpBindings() {
        
        dataSourceAndDelegate.tableView = tableView
        dataSourceAndDelegate.observableSearch = searchBar.rx.text
        
        _options.onNext(dataSourceAndDelegate) // mora da emituje odmah da bi postojao withLatestFrom
        
    }
 
    private let bag = DisposeBag()
 
 }

class QuestionOptionsTableViewDataSourceAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    lazy var observableAnswer = BehaviorRelay.init(value: answer)
    var observableSearch: ControlProperty<String?>! {
        didSet {
            cleanSearch.subscribe(onNext: { (value) in
                if value == "" {
                    print("emitujem options = \(self.question.options)")
                    self.items.accept(self.question.options)
                } else {
                    let contained = self.question.options.filter({ option -> Bool in
                        return NSString.init(string: option).contains(value)
                    })
                    print("emitujem options = \(contained)")
                    self.items.accept(contained)
                }
                self.tableView.reloadData()
            }).disposed(by: bag)
        }
    }
    
    private var cleanSearch: Observable<String> {
        return observableSearch.map {$0 ?? ""}.asObservable()
    }
    
    private var items = BehaviorRelay<[String]>(value: [])
        
    var question: Question
    var tableView: UITableView!
    private var answer: OptionTextAnswer?
    
    
    init(question: Question, answer: OptionTextAnswer?) {
        self.question = question
        self.answer = answer
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return question.options.count
        return items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath)
        let text = items.value[indexPath.row]
        cell.textLabel?.text = text
        cell.accessoryType = .none
        if let answer = self.observableAnswer.value, answer.content.contains(text) {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        var newAnswer = observableAnswer.value ?? answer ?? OptionTextAnswer.init(multipleSelection: true, questionId: question.id, content: [])
        //let option = question.options[indexPath.row]
        let option = items.value[indexPath.row]
        
        if let index = newAnswer.content.firstIndex(of: option) {
            newAnswer.content.remove(at: index)
            cell.accessoryType = .none
        } else {
            newAnswer.content.append(option)
            cell.accessoryType = .checkmark
        }
        print("newAnswer.content = \(newAnswer.content)")
        observableAnswer.accept(newAnswer)
        
    }
    
    private let bag = DisposeBag()
    
}
