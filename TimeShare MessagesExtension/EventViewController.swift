//
//  EventViewController.swift
//  TimeShare MessagesExtension
//
//  Created by Iyin Raphael on 8/24/20.
//  Copyright © 2020 Iyin Raphael. All rights reserved.
//

import UIKit
import Messages

class EventViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    weak var delegate: MessagesViewController!
    
    var dates = [Date]()
    var allVotes = [Int]()
    var ourVotes = [Int]()
    
    // MARK: - View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Methods
    
    @IBAction func addDate(_ sender: UIButton) {
        // 1: add to the arrays
        dates.append(datePicker.date)
        allVotes.append(0)
        ourVotes.append(1)
        
        // 2: insert a row in the table using animation
        let newIndexPath = IndexPath(row: dates.count - 1, section: 0)
        
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        
        // 3: scroll the new row into view
        tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
    
        
        // 4: flash the scroll bars so the user knows something has changed
        tableView.flashScrollIndicators()
    }
    
    @IBAction func saveSelectedDates(_ sender: UIButton) {
        var finalVotes = [Int]()
        
        for (index, votes) in allVotes.enumerated() {
            finalVotes.append(votes + ourVotes[index])
        }
        
        delegate.createMessage(with: dates, votes: finalVotes)
    }
    
    func load(from message: MSMessage?) {
        guard let message = message,
            let messageURL = message.url,
            let urlComponents = URLComponents(url: messageURL, resolvingAgainstBaseURL: false),
            let queryItems = urlComponents.queryItems else { return }
        
        for item in queryItems {
            if item.name.hasPrefix("date-"){
                dates.append(date(from: item.value ?? ""))
            } else if item.name.hasPrefix("vote-") {
                let voteCount = Int(item.value ?? "") ?? 0
                allVotes.append(voteCount)
                ourVotes.append(0)
            }
        }
    }
    
    func date(from string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm"
        return dateFormatter.date(from: string) ?? Date()
    }

}

    // MARK: - Tableview Datasource and Delegate

extension EventViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 1: dequeue a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Date", for: indexPath)
        
        // pull out the corresponding date and format it neatly
        let date = dates[indexPath.row]
        cell.textLabel?.text = DateFormatter.localizedString(from: date, dateStyle: .long, timeStyle: .short)
        
        // add a checkmarck if we voted for this date
        if ourVotes[indexPath.row] == 1{
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        // add a vote count if other people voted for this date
        if allVotes[indexPath.row] > 0 {
            cell.detailTextLabel?.text = "Votes: \(allVotes[indexPath.row])"
        } else {
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) { if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
            ourVotes[indexPath.row] = 0
        } else {
            cell.accessoryType = .checkmark
            ourVotes[indexPath.row] = 1
            
            }
        }
    }
    

}
