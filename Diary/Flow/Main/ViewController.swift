import UIKit
import SnapKit
import FSCalendar
import RealmSwift

class ViewController: UIViewController {

    // MODELS
    var notes = [Note]()

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
        let button = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(self.addButton))
        navigationItem.rightBarButtonItem = button

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

        // SETUP notes

        if let result = RealmManager.shared.objects(NoteEntity.self)?.array {
            notes = result.map({ entity in
                Note.init(from: entity)

            })
        }
    }

    @objc func addButton() {
        let viewController = CreateNoteViewController()

        if let date = calendar.selectedDate {
            var calendar = Calendar.current
//            let timezone = TimeZone(secondsFromGMT: 0)!
            calendar.timeZone = .current

            let dateFormatter = DateFormatter()
            var dateComponents = dateFormatter.calendar.dateComponents([.year, .month, .day], from: date)
            dateComponents.hour = 0
            dateComponents.second = 0

            let newDate = calendar.date(from: dateComponents)
            viewController.date = newDate
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            let alert = UIAlertController(title: "Error", message: "Choose date", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
}

extension ViewController: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeight.constant = bounds.height
        self.view.layoutIfNeeded()
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

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
            cell?.label.font = .systemFont(ofSize: 12, weight: .medium)
            cell?.label.textAlignment = .center
            cell?.label.text = "Cоздайте заметку, чтобы она тут отобразилась"
        } else {
            cell?.label.text = notes[indexPath.row].name
            cell?.timeLabel.text = notes[indexPath.row].dateSt + " - " + notes[indexPath.row].dateFi
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
