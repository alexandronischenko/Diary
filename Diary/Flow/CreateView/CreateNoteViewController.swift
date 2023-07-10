import Foundation
import UIKit
import SnapKit

class CreateNoteViewController: UIViewController {

    private var calendar = Calendar.current
    var date: Date?

    lazy var nameLabel: UITextField = {
        var view = UITextField()
        view.placeholder = "Name"
        view.font = .systemFont(ofSize: 18, weight: .medium)
        view.borderStyle = .roundedRect
        return view
    }()

    lazy var pickerView: UIPickerView = {
        var view = UIPickerView()
        view.delegate = self
        view.dataSource = self
        return view
    }()

    lazy var descriptionLabel: UITextView = {
        var view = UITextView()
        view.text = "Description..."
        view.textColor = UIColor.lightGray
        view.delegate = self
        view.font = .systemFont(ofSize: 16, weight: .regular)

        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.6
        view.layer.cornerRadius = 8
        return view
    }()

    lazy var addButton: UIButton = {
        var view = UIButton()
        view.setTitle("Add", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.layer.cornerRadius = 5
        return view
    }()

    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "New note"

        addButton.addTarget(self, action: #selector(self.addNote), for: .touchUpInside)
        configureView()
    }

    @objc func addNote() {
        if let name = nameLabel.text, let description = descriptionLabel.text {
            var dateFormatter = DateFormatter()

            dateFormatter.dateFormat = ""
            let note = Note(id: RealmManager.shared.newID(),
                            dateStart: time.description,
                            dateFinish: time.addingTimeInterval(3600).description,
                            name: name,
                            noteDescription: description)
            let noteEntity = NoteEntity(from: note)
            RealmManager.shared.add(noteEntity)
            navigationController?.popViewController(animated: true)
        } else {
            // MARK: Add error
        }
    }

    func configureView() {
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(addButton)

        view.addSubview(pickerView)

        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalToSuperview().multipliedBy(0.05)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.height.equalTo(100)
        }

        pickerView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(pickerView.snp.height)
        }

        addButton.snp.makeConstraints { make in
            make.top.equalTo(pickerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(64)
        }
    }

    // MARK: Getting & setting the time
    var time: Date {
        get {
            calendar.timeZone = .current
            let unitFlags: Set<Calendar.Component> = [.year, .day, .hour, .minute]
            var components = self.calendar.dateComponents(unitFlags, from: date ?? Date())
            components.hour = self.pickerView.selectedRow(inComponent: 0)
            if let date = self.calendar.date(from: components) {
                return date
            }
            return Date() // shouldn't get here
        }
        set {
            let timezone = TimeZone(secondsFromGMT: 0)!
            calendar.timeZone = timezone
            let components = self.calendar.dateComponents([.year, .day, .hour, .minute], from: newValue)
            if let hour = components.hour {
                self.pickerView.selectRow(hour, inComponent: 0, animated: true)
            }
        }
    }
}

// MARK: UITextViewDelegate
extension CreateNoteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
}

// MARK: UIPickerViewDelegate
extension CreateNoteViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(format: "%02d", row) + ":00"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("picker changed, selected \(self.time)")
    }
}

// MARK: UIPickerViewDataSource
extension CreateNoteViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 24
    }
}
