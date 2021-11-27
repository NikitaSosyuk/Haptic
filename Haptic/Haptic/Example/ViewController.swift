//
//  ViewController.swift
//  Haptic
//
//  Created by Nikita Sosyuk on 27.11.2021.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Private Properties

    private let pickerView = UIPickerView()

    @HapticControl(haptics: [.touchUpInside: .medium])
    private var blueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 8
        button.setTitle("Старая кнопка", for: .normal)
        return button
    }()

    private var redButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.setTitle("Проиграть анимацию", for: .normal)
        return button
    }()

    @HapticView(haptics: [.tap: .error])
    private var someView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.backgroundColor = .systemGray
        return view
    }()

    private let haptics: [(haptic: Haptic, name: String)] = [
        (.medium, "medium"),
        (.warning, "warning"),
        (.error, "error"),
        (.heavy, "heavy"),
        (.light, "light"),
        (.selection, "selection"),
        (.success, "success"),
    ]

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setLayout()
        setupPicker()

        view.backgroundColor = .white

        // Смена кнопки, чтобы проверить, что пропадают action-ы.
        let tempButton = blueButton
        blueButton = redButton
        redButton = tempButton

        // Смена вибрации для view.
        _someView.changeHaptic(.heavy, for: .tap)
    }


    // MARK: - Private Methods

    private func setupPicker() {
        pickerView.dataSource = self
        pickerView.delegate = self
    }

    private func addSubviews() {
        view.addSubview(someView)
        view.addSubview(redButton)
        view.addSubview(blueButton)
        view.addSubview(pickerView)
    }

    private func setLayout() {
        someView.translatesAutoresizingMaskIntoConstraints = false
        redButton.translatesAutoresizingMaskIntoConstraints = false
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        blueButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            blueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            blueButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            redButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            redButton.topAnchor.constraint(equalTo: blueButton.bottomAnchor, constant: 20),

            someView.heightAnchor.constraint(equalToConstant: 100),
            someView.widthAnchor.constraint(equalToConstant: 100),
            someView.topAnchor.constraint(equalTo: redButton.bottomAnchor, constant: 20),
            someView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            pickerView.centerXAnchor.constraint(equalTo: blueButton.centerXAnchor),
            pickerView.bottomAnchor.constraint(equalTo: blueButton.topAnchor, constant: -10),
            pickerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            pickerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
    }
}

// MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        haptics.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        haptics[row].name
    }
}

// MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let data = haptics[row]
        _blueButton.changeHaptic(data.haptic, for: .touchUpInside)
    }
}
