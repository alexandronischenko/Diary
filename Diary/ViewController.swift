//
//  ViewController.swift
//  Diary
//
//  Created by Alexandr Onischenko on 06.07.2023.
//

import UIKit
import SnapKit
import FSCalendar

class ViewController: UIViewController {

    // MODELS
    var notes: [Note] = [
//        Note(id: 0, dateStart: "01:00", dateFinish: "01:00", name: "Дело номер один", description: ""),
//        Note(id: 1, dateStart: "01:00", dateFinish: "01:00", name: "Второе дело", description: ""),
//        Note(id: 2, dateStart: "01:00", dateFinish: "01:00", name: "Отдых", description: ""),
//        Note(id: 3, dateStart: "", dateFinish: "", name: "first", description: ""),
//        Note(id: 4, dateStart: "", dateFinish: "", name: "second", description: ""),
//        Note(id: 5, dateStart: "", dateFinish: "", name: "third", description: ""),
    ]

    fileprivate weak var calendar: FSCalendar!
    private var calendarHeight: NSLayoutConstraint!

    // VIEWS
    lazy var tableView: UITableView = {
        var view = UITableView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Diary"

        self.tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: "NoteTableViewCell")

        view.addSubview(tableView)

        // Setup tableview

        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        // Setup Calendar
        let width = UIScreen.main.bounds.width
        let height = width * 0.8
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: width, height: height))
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.dataSource = self
        calendar.delegate = self
        self.calendar = calendar
        tableView.tableHeaderView = calendar
    }
}

extension ViewController: FSCalendarDataSource {
}

extension ViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeight.constant = bounds.height
        self.view.layoutIfNeeded()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tableView:
            if notes.count == 0 {
                return 1
            }
            return notes.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as? NoteTableViewCell
        if notes.count == 0 {
            cell?.selectionStyle = .none
            cell?.label.font = .systemFont(ofSize: 12, weight: .bold)
            cell?.label.textAlignment = .center
            cell?.label.text = "Cоздайте заметку, чтобы она тут отобразилась"
        } else {
            cell?.label.text = notes[indexPath.row].name
            cell?.timeLabel.text = notes[indexPath.row].dateStart + " - " + notes[indexPath.row].dateFinish
        }
        return cell ?? UITableViewCell()
    }
}

extension ViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Notes"
    }
}
