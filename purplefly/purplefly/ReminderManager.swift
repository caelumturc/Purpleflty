

import Foundation

class ReminderManager {
    
    // MARK: - Properties
    private let dataSourceURL: URL
    private var allReminders: [purpleItem] {
        get {
            do {
                let decoder = PropertyListDecoder()
                let data = try Data(contentsOf: dataSourceURL)
                let decodedReminders = try! decoder.decode([purpleItem].self, from: data)
                
                return decodedReminders
            } catch {
                return []
            }
        }
        set {
            do {
                let encoder = PropertyListEncoder()
                let data = try encoder.encode(newValue)
                
                try data.write(to: dataSourceURL)
            } catch {
                
            }
        }
    }
    init() {

       
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let remindersPath = documentsPath.appendingPathComponent("reminders").appendingPathExtension("plist")
        
        dataSourceURL = remindersPath
    }
        func getAllReminders() -> [purpleItem] {
        return allReminders
    }
    
    func create(reminder: purpleItem) {
        
       
        allReminders.insert(reminder, at: 0)
        
        if let dueDate = reminder.dueDate {
            NotificationProvider.scheduleNotification(title: reminder.title, date: dueDate, id: reminder.id)
        }
    }
    
    func setComplete(reminder: purpleItem) {
        
       
        if let index = allReminders.firstIndex(where: { $0.id == reminder.id }) {
            allReminders[index].isCompleted.toggle()
        }
    }
    
    func delete(reminder: purpleItem) {
        if let index = allReminders.firstIndex(where: { $0.id == reminder.id }) {
            allReminders.remove(at: index)
            NotificationProvider.cancelNotification(reminder.id)
        }
    }
}
