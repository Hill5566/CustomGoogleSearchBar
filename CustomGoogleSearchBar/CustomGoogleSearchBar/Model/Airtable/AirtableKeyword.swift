
import Foundation
import SwiftAirtable

struct AirtableKeyword {
    var id: String = ""
    var keyword: String = ""
}

extension AirtableKeyword {
    enum AirtableField: String {
        case keyword = "keyword"
    }
}

extension AirtableKeyword: AirtableObject {
    
    static var fieldKeys: [(fieldName: String, fieldType: AirtableTableSchemaFieldKey.KeyType)] {
        var fields = [(fieldName: String, fieldType: AirtableTableSchemaFieldKey.KeyType)]()
        fields.append((fieldName: AirtableField.keyword.rawValue, fieldType: .singleLineText))
        return fields
    }
    
    func value(forKey key: AirtableTableSchemaFieldKey) -> AirtableValue? {
        switch key {
        case AirtableTableSchemaFieldKey(fieldName: AirtableField.keyword.rawValue, fieldType: .singleLineText):
            return self.keyword
        default: return nil
        }
    }
    
    init(withId id: String, populatedTableSchemaKeys tableSchemaKeys: [AirtableTableSchemaFieldKey : AirtableValue]) {
        self.id = id
        tableSchemaKeys.forEach { element in
            switch element.key {
            case AirtableTableSchemaFieldKey(fieldName: AirtableField.keyword.rawValue, fieldType: .singleLineText):
                self.keyword = element.value.stringValue
                
            default: break
            }
        }
    }
    
    
}
