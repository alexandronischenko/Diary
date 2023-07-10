import UIKit

class NoteTableViewCell: UITableViewCell {
    static let identifier: String = "NoteTableViewCell"

    lazy var label: UILabel = {
        var label = UILabel()
        return label
    }()

    lazy var timeLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .thin)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        self.contentView.addSubview(label)
        self.contentView.addSubview(timeLabel)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
        }
        timeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(label.snp.bottom).offset(6)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}
