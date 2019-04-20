//
//  CodesVC.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 20/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class CodesVC: UIViewController {
    
    @IBAction func codeBtnTapped(_ sender: UIButton) {
        print("fetch question (zakucana kampanja) and answers for this tag: \(sender.tag)")
        loadQuestionsAndAnswers(campaignId: 9, barcode: sender.tag) // hard-coded campaign
        openQuestionsAndAnswers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    private func loadQuestionsAndAnswers(campaignId: Int, barcode: Int) {
        print("fetch data from realm.....")
    }
    
    private func openQuestionsAndAnswers() {
        guard let anketaVC = UIStoryboard.main.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {return}
        self.navigationController?.pushViewController(anketaVC, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
