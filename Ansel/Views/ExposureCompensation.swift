////
////  ExposureCompensation.swift
////  Lumen
////
////  Created by Tyler Reckart on 7/16/22.
////
//
//import SwiftUI
//
//struct ExposureCompensationCard: View {
//    var label: String
//    var icon: String
//    var result: String
//    var background: Color
//    var foreground: Color = .white
//
//    var body: some View {
//        VStack {
//            Image(systemName: icon)
//                .imageScale(.large)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.bottom, 1)
//            Text(label)
//                .font(.system(.caption))
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.bottom, 1)
//            Spacer()
//            Text(result)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .font(.system(.title, design: .rounded))
//        }
//        .foregroundColor(foreground)
//        .frame(height:125, alignment: .topLeading)
//        .padding()
//        .background(background)
//        .cornerRadius(18)
//        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
//    }
//}
//
//struct ExposureCompensationHistorySheet: View {
//    @FetchRequest(
//      entity: ExposureCompensationData.entity(),
//      sortDescriptors: [
//        NSSortDescriptor(keyPath: \ExposureCompensationData.timestamp, ascending: true)
//      ]
//    ) var results: FetchedResults<ExposureCompensationData>
//    
//    func formatDate(date: Date) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/d/y hh:mm:ss"
//        return dateFormatter.string(from: date)
//    }
//
//    var body: some View {
//        List {
//            ForEach(results, id: \.self) { r in
//                Text(formatDate(date: r.timestamp!))
//            }
//        }
//        .listStyle(.insetGrouped)
//    }
//}
//
//struct ExposureCompensationForm: View {
//    @Binding var shutter_speed: String
//
//    var onSelect: ((_ key: ExposureCompensationDropdownOption) -> Void)?
//    var calculate: () -> Void
//    
//    var options = [
//        ExposureCompensationDropdownOption(key: "SFX (>1 Second)", value: 1.43),
//        ExposureCompensationDropdownOption(key: "Pan F+ (>1 Second)", value: 1.33),
//        ExposureCompensationDropdownOption(key: "Delta 100 (>1 Second)", value: 1.26),
//        ExposureCompensationDropdownOption(key: "Delta 400 (>1 Second)", value: 1.41),
//        ExposureCompensationDropdownOption(key: "Delta 3200 (>1 Second)", value: 1.33),
//        ExposureCompensationDropdownOption(key: "FP4+ (>1 Second)", value: 1.26),
//        ExposureCompensationDropdownOption(key: "HP5+ (>1 Second)", value: 1.31),
//        ExposureCompensationDropdownOption(key: "XP2 (>1 Second)", value: 1.31),
//        ExposureCompensationDropdownOption(key: "K100 (>1 Second)", value: 1.26),
//        ExposureCompensationDropdownOption(key: "K400 (>1 Second)", value: 1.30),
//        ExposureCompensationDropdownOption(key: "Portra 160 (>1 Second)", value: 1.33),
//        ExposureCompensationDropdownOption(key: "E100 (>10 Seconds)", value: 1.33),
//        ExposureCompensationDropdownOption(key: "Rollei IR 400 (>1 Seocnd", value: 1.31)
//    ]
//    
//    @Binding var selected: String
//    
//    var body: some View {
//        VStack {
//            Text("Parameters")
//                .font(.system(.caption))
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .foregroundColor(.gray)
//                .padding(.top)
//            
//            ExposureCompensationDropdownButton(
//                displayText: $selected,
//                options: options,
//                onSelect: onSelect,
//                selected: $selected
//            )
//                .zIndex(2)
//            
//            FormInput(
//                text: $shutter_speed,
//                placeholder: "Shutter Speed (seconds)"
//            )
//                .padding(.bottom, 4)
//                .zIndex(1)
//            CalculateButton(calculate: calculate)
//                .zIndex(1)
//        }
//    }
//}
//
//struct ExposureCompensation: View {
//    @Environment(\.managedObjectContext) var managedObjectContext
//
//    @State private var shutter_speed: String = ""
//    @State private var reciprocity_factor: Double = 1.43
//    @State private var adjusted_shutter_speed: String = ""
//    @State private var selected: String = "SFX"
//    
//    @State private var showingHistorySheet: Bool = false
//
//    var body: some View {
//        ScrollView {
//            VStack {
//                ExposureCompensationForm(
//                    shutter_speed: $shutter_speed,
//                    onSelect: self.onSelect,
//                    calculate: self.calculate,
//                    selected: $selected
//                )
//            }
//            .padding([.leading, .trailing, .bottom])
//            .background(.background)
//            .cornerRadius(18)
//            .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
//            .padding([.leading, .trailing, .bottom])
//
//            if !self.adjusted_shutter_speed.isEmpty {
//                ExposureCompensationCard(
//                    label: "Adjusted shutter speed",
//                    icon: "clock.circle.fill",
//                    result: "\(Int(round(Double(adjusted_shutter_speed) ?? 1))) seconds",
//                    background: Color(.systemPurple)
//                )
//                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
//                .padding([.leading, .trailing, .bottom])
//            }
//        }
//        .background(Color(.systemGray6))
//        .navigationTitle("ExposureCompensation")
//        .navigationBarTitleDisplayMode(.large)
//        .toolbar {
//            HStack {
//                Button(action: {
//                    self.showingHistorySheet.toggle()
//                }) {
//                    Label("History", systemImage: "clock.arrow.circlepath")
//                    Text("History")
//                }
//            }
//            .foregroundColor(Color(.systemBlue))
//        }
//        .sheet(isPresented: $showingHistorySheet) {
//            ExposureCompensationHistorySheet()
//        }
//    }
//
//    func saveContext() {
//      do {
//        try managedObjectContext.save()
//      } catch {
//        print("Error saving managed object context: \(error)")
//      }
//    }
//    
//    func save() {
//        let newExposureCompensationData = ExposureCompensationData(context: managedObjectContext)
//
//        newExposureCompensationData.adjustedShutterSpeed = self.adjusted_shutter_speed
//        newExposureCompensationData.timestamp = Date()
//        
//        let optionData = ExposureCompensationOption(context: managedObjectContext)
//        optionData.key = self.selected
//        optionData.value = self.reciprocity_factor
//        newExposureCompensationData.selectedOption = optionData
//
//      saveContext()
//    }
//
//    private func calculate() {
//        self.adjusted_shutter_speed = "\(pow(Double(self.shutter_speed) ?? 1.0, self.reciprocity_factor))"
//        save()
//    }
//    
//    private func onSelect(option: ExposureCompensationDropdownOption) {
//        self.reciprocity_factor = option.value
//        self.selected = option.key
//    }
//}
//
//struct ExposureCompensation_Previews: PreviewProvider {
//    static var previews: some View {
//        ExposureCompensation()
//    }
//}
