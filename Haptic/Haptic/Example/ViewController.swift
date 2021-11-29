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

    private let blueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.setTitle("Проиграть анимацию", for: .normal)
        return button
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

    private var haptic = Haptic.medium

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setLayout()
        setupPicker()

        view.backgroundColor = .white
        blueButton.addTarget(self, action: #selector(blueButtonAction), for: .touchUpInside)
    }


    // MARK: - Private Methods

    private func setupPicker() {
        pickerView.dataSource = self
        pickerView.delegate = self
    }

    private func addSubviews() {
        view.addSubview(blueButton)
        view.addSubview(pickerView)
    }

    private func setLayout() {
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        blueButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            blueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            blueButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            pickerView.centerXAnchor.constraint(equalTo: blueButton.centerXAnchor),
            pickerView.bottomAnchor.constraint(equalTo: blueButton.topAnchor, constant: -10),
            pickerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            pickerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
    }

    @objc private func blueButtonAction() {
        blueButton.playHapticFeedback(.error)
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
        self.haptic = data.haptic
    }
}
