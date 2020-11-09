//
//  DatePickerView.swift
//  KittyWidgetV2
//
//  Created by SORA on 2020/11/8.


import SwiftUI


struct DatePickerView: UIViewRepresentable {
    @Binding var date: Date

    private let datePicker = UIDatePicker()

    func makeUIView(context: Context) -> UIDatePicker {
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "zh_Hans_CN")
        datePicker.preferredDatePickerStyle = .automatic
        datePicker.addTarget(context.coordinator, action: #selector(Coordinator.changed(_:)), for: .valueChanged)
        return datePicker
    }

    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        datePicker.date = date
    }

    func makeCoordinator() -> DatePickerView.Coordinator {
        Coordinator(date: $date)
    }

    class Coordinator: NSObject {
        private let date: Binding<Date>

        init(date: Binding<Date>) {
            self.date = date
        }

        @objc func changed(_ sender: UIDatePicker) {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: Coefficients.locale)
            dateFormatter.dateStyle = .short
            let str = dateFormatter.string(from: sender.date)
            let newDay = dateFormatter.date(from: str)
            self.date.wrappedValue = newDay!
        }
    }
}

