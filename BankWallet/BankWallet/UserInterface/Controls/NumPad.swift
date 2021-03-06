import UIKit
import SnapKit

class NumPad: UICollectionView {

    private enum Cell {
        case number(number: String, letters: String?, action: () -> ())
        case image(image: UIImage?, pressedImage: UIImage?, action: (() -> ())?)
    }

    weak var numPadDelegate: NumPadDelegate?
    private let layout = UICollectionViewFlowLayout()

    private var cells = [Cell]()

    init() {
        super.init(frame: .zero, collectionViewLayout: layout)

        dataSource = self
        delegate = self

        layout.itemSize = NumPadTheme.itemSize
        layout.minimumLineSpacing = NumPadTheme.spacing
        layout.minimumInteritemSpacing = NumPadTheme.spacing

        register(NumPadNumberCell.self, forCellWithReuseIdentifier: String(describing: NumPadNumberCell.self))
        register(NumPadImageCell.self, forCellWithReuseIdentifier: String(describing: NumPadImageCell.self))

        backgroundColor = .clear

        isScrollEnabled = false

        snp.makeConstraints { maker in
            maker.size.equalTo(NumPadTheme.size)
        }

        cells = [
            .number(number: "1", letters: "", action: { [weak self] in self?.numPadDelegate?.numPadDidClick(digit: "1") }),
            .number(number: "2", letters: "numpad_2".localized, action: { [weak self] in self?.numPadDelegate?.numPadDidClick(digit: "2") }),
            .number(number: "3", letters: "numpad_3".localized, action: { [weak self] in self?.numPadDelegate?.numPadDidClick(digit: "3") }),
            .number(number: "4", letters: "numpad_4".localized, action: { [weak self] in self?.numPadDelegate?.numPadDidClick(digit: "4") }),
            .number(number: "5", letters: "numpad_5".localized, action: { [weak self] in self?.numPadDelegate?.numPadDidClick(digit: "5") }),
            .number(number: "6", letters: "numpad_6".localized, action: { [weak self] in self?.numPadDelegate?.numPadDidClick(digit: "6") }),
            .number(number: "7", letters: "numpad_7".localized, action: { [weak self] in self?.numPadDelegate?.numPadDidClick(digit: "7") }),
            .number(number: "8", letters: "numpad_8".localized, action: { [weak self] in self?.numPadDelegate?.numPadDidClick(digit: "8") }),
            .number(number: "9", letters: "numpad_9".localized, action: { [weak self] in self?.numPadDelegate?.numPadDidClick(digit: "9") }),
            .image(image: nil, pressedImage: nil, action: nil),
            .number(number: "0", letters: nil, action: { [weak self] in self?.numPadDelegate?.numPadDidClick(digit: "0") }),
            .image(image: UIImage(named: "Backspace Icon"), pressedImage: UIImage(named: "Backspace Icon Pressed"), action: { [weak self] in self?.numPadDelegate?.numPadDidClickBackspace() })
        ]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension NumPad: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier: String

        switch cells[indexPath.item] {
        case .number: identifier = String(describing: NumPadNumberCell.self)
        case .image: identifier = String(describing: NumPadImageCell.self)
        }
        
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }

}

extension NumPad: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch cells[indexPath.item] {
        case .number(let number, let letters, let action):
            if let cell = cell as? NumPadNumberCell {
                cell.bind(number: number, letters: letters, onTap: action)
            }
        case .image(let image, let pressedImage, let action):
            if let cell = cell as? NumPadImageCell {
                cell.bind(image: image, pressedImage: pressedImage, onTap: action)
            }
        }
    }

}

class NumPadNumberCell: UICollectionViewCell {

    private let button = UIButton()
    private let numberLabel = UILabel()
    private let lettersLabel = UILabel()
    private var onTap: (() -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)

        button.borderWidth = NumPadTheme.itemBorderWidth
        button.borderColor = NumPadTheme.itemBorderColor
        button.cornerRadius = NumPadTheme.itemCornerRadius
        button.setBackgroundColor(color: NumPadTheme.buttonBackgroundColor, forState: .normal)
        button.setBackgroundColor(color: NumPadTheme.buttonBackgroundColorHighlighted, forState: .highlighted)
        addSubview(button)
        button.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        numberLabel.font = NumPadTheme.numberFont
        numberLabel.textColor = NumPadTheme.numberColor
        button.addSubview(numberLabel)

        lettersLabel.font = NumPadTheme.lettersFont
        lettersLabel.textColor = NumPadTheme.lettersColor
        button.addSubview(lettersLabel)
        lettersLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-NumPadTheme.lettersBottomMargin)
        }

        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(number: String, letters: String?, onTap: @escaping () -> ()) {
        numberLabel.text = number
        lettersLabel.text = letters
        self.onTap = onTap

        lettersLabel.isHidden = letters == nil

        numberLabel.snp.remakeConstraints { maker in
            maker.centerX.equalToSuperview()

            if letters == nil {
                maker.centerY.equalToSuperview()
            } else {
                maker.top.equalToSuperview().offset(NumPadTheme.numberTopMargin)
            }
        }
    }

    @objc func didTapButton() {
        onTap?()
    }

}

class NumPadImageCell: UICollectionViewCell {

    private let button = UIButton()
    private var onTap: (() -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(button)
        button.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(image: UIImage?, pressedImage: UIImage?, onTap: (() -> ())?) {
        self.onTap = onTap
        button.setImage(image?.tinted(with: .crypto_White_Black), for: .normal)
        button.setImage(pressedImage?.tinted(with: .crypto_White_Black), for: .highlighted)
    }

    @objc func didTapButton() {
        onTap?()
    }

}

protocol NumPadDelegate: class {
    func numPadDidClick(digit: String)
    func numPadDidClickBackspace()
}
