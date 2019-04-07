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
 
    var dataSourceAndDelegate: QuestionOptionsTableViewDataSourceAndDelegate?
    
    private var _options = PublishSubject<UITableViewDataSource>.init()
    public var options: Observable<UITableViewDataSource> {
        return _options.asObservable()
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSourceAndDelegate
        tableView.delegate = dataSourceAndDelegate
        setUpBindings()
    }
    
    private func setUpBindings() {
        doneBtn.rx.tap
            .subscribe {
                print("report to parent vc .... ")
            }.disposed(by: bag)
    }
 
    private let bag = DisposeBag()
 
 }

extension ChooseOptionsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSourceAndDelegate?.numberOfSections(in: tableView) ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceAndDelegate?.tableView(tableView, numberOfRowsInSection: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataSourceAndDelegate?.tableView(tableView, cellForRowAt: indexPath) ?? UITableViewCell.init()
    }
}

extension ChooseOptionsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSourceAndDelegate?.tableView(tableView, didSelectRowAt: indexPath)
    }
}


class QuestionOptionsTableViewDataSourceAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    lazy var observableAnswer = BehaviorRelay.init(value: answer)
    
    var question: Question
    var answer: OptionTextAnswer?
    
    init(question: Question, answer: OptionTextAnswer?) {
        self.question = question
        self.answer = answer
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath)
        let text = question.options[indexPath.row]
        cell.textLabel?.text = text
        cell.accessoryType = .none
        if let answer = self.answer, answer.content.contains(text) {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    private func updateModel(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        var newAnswer = observableAnswer.value ?? answer ?? OptionTextAnswer.init(multipleSelection: true, questionId: question.id, content: [])
        let option = question.options[indexPath.row]
        
        if let index = newAnswer.content.firstIndex(of: option) {
            newAnswer.content.remove(at: index)
            cell.accessoryType = .none
        } else {
            newAnswer.content.append(option)
            cell.accessoryType = .checkmark
        }
        observableAnswer.accept(newAnswer)
        
    }
    
}
