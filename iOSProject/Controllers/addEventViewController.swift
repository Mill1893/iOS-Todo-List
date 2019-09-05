//
//  addEventViewController.swift
//  iOSProject
//
//  Created by Andrew Miller on 5/7/18.
//  Copyright © 2018 Andrew Miller. All rights reserved.
//

import UIKit
import EventKit

class addEventViewController: UIViewController {

    @IBOutlet weak var eventNameLabel: UITextField!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if (granted) && (error == nil) {
                print("granted: \(granted)")
                print("error: \(String(describing: error))")
                
                let event = EKEvent(eventStore: eventStore)
                event.title = self.eventNameLabel.text
                event.startDate = self.startDate.date
                event.endDate = self.endDate.date
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                    self.dismiss(animated: true, completion: nil)
                } catch let error as NSError {
                    print("error: \(error)")
                    
                    let alert = UIAlertController(title: "Event could not save", message: "\(error)", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(OKAction)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                print("Saved Event")
            } else {
                print("error: \(String(describing: error))")
            }
            
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
