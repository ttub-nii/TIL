struct MediaUnkeyedDecodingContainer<Map : DecodingMedia> : UnkeyedDecodingContainer {
    
    let decoder: MediaDecoder<Map>
    let map: DecodingMedia
    var codingPath: [CodingKey]
    var currentIndex: Int
    
    init(referencing decoder: MediaDecoder<Map>, wrapping map: DecodingMedia) {
        self.decoder = decoder
        self.map = map
        self.codingPath = decoder.codingPath
        self.currentIndex = 0
    }
    
    var count: Int? {
        return map.keyCount()
    }
    
    var isAtEnd: Bool {
        guard let count = map.keyCount() else {
            return true
        }
        
        return currentIndex >= count
    }
    
    func throwIfAtEnd() throws {
        // TODO: throw a relevant error
    }
    
    mutating func decodeNil() throws -> Bool {
        try throwIfAtEnd()
        
        return decoder.with(pushedKey: currentIndex) {
            let decoded = map.decodeNil()
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decode(_ type: Bool.Type) throws -> Bool {
        try throwIfAtEnd()
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decode(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decode(_ type: Int.Type) throws -> Int {
        try throwIfAtEnd()
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decode(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decode(_ type: Int8.Type) throws -> Int8 {
        try throwIfAtEnd()
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decode(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decode(_ type: Int16.Type) throws -> Int16 {
        try throwIfAtEnd()
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decode(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decode(_ type: Int32.Type) throws -> Int32 {
        try throwIfAtEnd()
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decode(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decode(_ type: Int64.Type) throws -> Int64 {
        try throwIfAtEnd()
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decode(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decode(_ type: UInt.Type) throws -> UInt {
        try throwIfAtEnd()
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decode(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
        try throwIfAtEnd()
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decode(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
        try throwIfAtEnd()
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decode(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
        try throwIfAtEnd()
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decode(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
        try throwIfAtEnd()
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decode(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decode(_ type: Float.Type) throws -> Float {
        try throwIfAtEnd()
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decode(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decode(_ type: Double.Type) throws -> Double {
        try throwIfAtEnd()
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decode(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decode(_ type: String.Type) throws -> String {
        try throwIfAtEnd()
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decode(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        try throwIfAtEnd()
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decode(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent(_ type: Bool.Type) throws -> Bool? {
        guard !isAtEnd else { return nil }
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decodeIfPresent(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent(_ type: Int.Type) throws -> Int? {
        guard !isAtEnd else { return nil }
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decodeIfPresent(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent(_ type: Int8.Type) throws -> Int8? {
        guard !isAtEnd else { return nil }
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decodeIfPresent(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent(_ type: Int16.Type) throws -> Int16? {
        guard !isAtEnd else { return nil }
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decodeIfPresent(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent(_ type: Int32.Type) throws -> Int32? {
        guard !isAtEnd else { return nil }
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decodeIfPresent(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent(_ type: Int64.Type) throws -> Int64? {
        guard !isAtEnd else { return nil }
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decodeIfPresent(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent(_ type: UInt.Type) throws -> UInt? {
        guard !isAtEnd else { return nil }
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decodeIfPresent(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent(_ type: UInt8.Type) throws -> UInt8? {
        guard !isAtEnd else { return nil }
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decodeIfPresent(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent(_ type: UInt16.Type) throws -> UInt16? {
        guard !isAtEnd else { return nil }
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decodeIfPresent(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent(_ type: UInt32.Type) throws -> UInt32? {
        guard !isAtEnd else { return nil }
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decodeIfPresent(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent(_ type: UInt64.Type) throws -> UInt64? {
        guard !isAtEnd else { return nil }
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decodeIfPresent(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent(_ type: Float.Type) throws -> Float? {
        guard !isAtEnd else { return nil }
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decodeIfPresent(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent(_ type: Double.Type) throws -> Double? {
        guard !isAtEnd else { return nil }
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decodeIfPresent(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent(_ type: String.Type) throws -> String? {
        guard !isAtEnd else { return nil }
        
        return try decoder.with(pushedKey: currentIndex) {
            let decoded = try map.decodeIfPresent(type, forKey: currentIndex)
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent<T : Decodable>(_ type: T.Type) throws -> T? {
        guard !isAtEnd else { return nil }
        
        return try decoder.with(pushedKey: currentIndex) {
            guard let value = try map.decodeIfPresent(Map.self, forKey: currentIndex) else {
                return nil
            }
            
            decoder.stack.push(value)
            let decoded: T = try T(from: decoder)
            decoder.stack.pop()
            
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func nestedContainer<NestedKey>(
        keyedBy type: NestedKey.Type
        ) throws -> KeyedDecodingContainer<NestedKey> {
        return try decoder.with(pushedKey: currentIndex) {
            try self.assertNotAtEnd(
                forType: KeyedDecodingContainer<NestedKey>.self,
                message: "Cannot get nested keyed container -- unkeyed container is at end."
            )
            
            let container = MediaKeyedDecodingContainer<NestedKey, Map>(
                referencing: decoder,
                wrapping: try map.keyedContainer(forKey: currentIndex)
            )
            
            currentIndex += 1
            return KeyedDecodingContainer(container)
        }
    }
    
    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        return try decoder.with(pushedKey: currentIndex) {
            try self.assertNotAtEnd(
                forType: UnkeyedDecodingContainer.self,
                message: "Cannot get nested unkeyed container -- unkeyed container is at end."
            )
            
            let container = MediaUnkeyedDecodingContainer(
                referencing: decoder,
                wrapping: try map.unkeyedContainer(forKey: currentIndex)
            )
            
            currentIndex += 1
            return container
        }
    }
    
    mutating func superDecoder() throws -> Decoder {
        return try decoder.with(pushedKey: currentIndex) {
            try self.assertNotAtEnd(
                forType: Decoder.self,
                message: "Cannot get superDecoder() -- unkeyed container is at end."
            )
            
            guard let value = try map.decodeIfPresent(Map.self, forKey: currentIndex) else {
                let context = DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Cannot get superDecoder() -- value not found for key \(currentIndex)."
                )
                
                throw DecodingError.keyNotFound(currentIndex, context)
            }
            
            currentIndex += 1
            
            return MediaDecoder<Map>(
                referencing: value,
                at: decoder.codingPath,
                userInfo: decoder.userInfo
            )
        }
    }
    
    func assertNotAtEnd(forType type: Any.Type, message: String) throws {
        guard !isAtEnd else {
            let context = DecodingError.Context(
                codingPath: codingPath,
                debugDescription: message
            )
            
            throw DecodingError.valueNotFound(type, context)
        }
    }
}
