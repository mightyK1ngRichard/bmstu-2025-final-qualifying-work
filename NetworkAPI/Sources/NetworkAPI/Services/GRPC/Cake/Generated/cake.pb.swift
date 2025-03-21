// DO NOT EDIT.
// swift-format-ignore-file
// swiftlint:disable all
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: cake.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct CakeRequest: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var cakeID: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct CakeResponse: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Информация о торте
  var cake: Cake {
    get {return _cake ?? Cake()}
    set {_cake = newValue}
  }
  /// Returns true if `cake` has been explicitly set.
  var hasCake: Bool {return self._cake != nil}
  /// Clears the value of `cake`. Subsequent reads from it will return its default value.
  mutating func clearCake() {self._cake = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _cake: Cake? = nil
}

struct CreateCakeRequest: @unchecked Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Название торта
  var name: String = String()

  /// Данные изображения торта
  var imageData: Data = Data()

  /// Цена за кг
  var kgPrice: Double = 0

  /// Рейтинг (0-5)
  var rating: Int32 = 0

  /// Описание торта
  var description_p: String = String()

  /// Масса торта
  var mass: Double = 0

  /// Доступен ли для продажи
  var isOpenForSale: Bool = false

  /// Список ID начинок
  var fillingIds: [String] = []

  /// Список ID категорий
  var categoryIds: [String] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct CreateCakeResponse: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// ID созданного торта
  var cakeID: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct CreateFillingRequest: @unchecked Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Название начинки
  var name: String = String()

  /// Данные изображения начинки
  var imageData: Data = Data()

  /// Состав начинки
  var content: String = String()

  /// Цена за кг
  var kgPrice: Double = 0

  /// Описание начинки
  var description_p: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct CreateFillingResponse: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Созданная начинка
  var filling: Filling {
    get {return _filling ?? Filling()}
    set {_filling = newValue}
  }
  /// Returns true if `filling` has been explicitly set.
  var hasFilling: Bool {return self._filling != nil}
  /// Clears the value of `filling`. Subsequent reads from it will return its default value.
  mutating func clearFilling() {self._filling = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _filling: Filling? = nil
}

struct CreateCategoryRequest: @unchecked Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var name: String = String()

  var imageData: Data = Data()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct CreateCategoryResponse: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var category: Category {
    get {return _category ?? Category()}
    set {_category = newValue}
  }
  /// Returns true if `category` has been explicitly set.
  var hasCategory: Bool {return self._category != nil}
  /// Clears the value of `category`. Subsequent reads from it will return its default value.
  mutating func clearCategory() {self._category = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _category: Category? = nil
}

struct CategoriesResponse: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var categories: [Category] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct FillingsResponse: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var fillings: [Filling] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct CakesResponse: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var cakes: [Cake] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// Информация о торте
struct Cake: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// ID торта
  var id: String = String()

  /// Название торта
  var name: String = String()

  /// URL изображения торта
  var imageURL: String = String()

  /// Цена за кг
  var kgPrice: Double = 0

  /// Рейтинг (0-5)
  var rating: Int32 = 0

  /// Описание торта
  var description_p: String = String()

  /// Масса торта
  var mass: Double = 0

  /// Доступен ли для продажи
  var isOpenForSale: Bool = false

  /// Информация о владельце
  var owner: User {
    get {return _owner ?? User()}
    set {_owner = newValue}
  }
  /// Returns true if `owner` has been explicitly set.
  var hasOwner: Bool {return self._owner != nil}
  /// Clears the value of `owner`. Subsequent reads from it will return its default value.
  mutating func clearOwner() {self._owner = nil}

  /// Список начинок
  var fillings: [Filling] = []

  /// Список категорий
  var categories: [Category] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _owner: User? = nil
}

/// Информация о владельце
struct User: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// ID пользователя
  var id: String = String()

  /// Полное имя
  var fio: SwiftProtobuf.Google_Protobuf_StringValue {
    get {return _fio ?? SwiftProtobuf.Google_Protobuf_StringValue()}
    set {_fio = newValue}
  }
  /// Returns true if `fio` has been explicitly set.
  var hasFio: Bool {return self._fio != nil}
  /// Clears the value of `fio`. Subsequent reads from it will return its default value.
  mutating func clearFio() {self._fio = nil}

  /// Никнейм
  var nickname: String = String()

  /// Электронная почта
  var mail: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _fio: SwiftProtobuf.Google_Protobuf_StringValue? = nil
}

/// Информация о начинке
struct Filling: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// ID начинки
  var id: String = String()

  /// Название начинки
  var name: String = String()

  /// URL изображения начинки
  var imageURL: String = String()

  /// Состав начинки
  var content: String = String()

  /// Цена за кг
  var kgPrice: Double = 0

  /// Описание начинки
  var description_p: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// Информация о категории
struct Category: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// ID категории
  var id: String = String()

  /// Название категории
  var name: String = String()

  /// URL изображения категории
  var imageURL: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension CakeRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "CakeRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "cake_id"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.cakeID) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.cakeID.isEmpty {
      try visitor.visitSingularStringField(value: self.cakeID, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: CakeRequest, rhs: CakeRequest) -> Bool {
    if lhs.cakeID != rhs.cakeID {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension CakeResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "CakeResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "cake"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._cake) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if let v = self._cake {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: CakeResponse, rhs: CakeResponse) -> Bool {
    if lhs._cake != rhs._cake {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension CreateCakeRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "CreateCakeRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "name"),
    2: .standard(proto: "image_data"),
    3: .standard(proto: "kg_price"),
    4: .same(proto: "rating"),
    5: .same(proto: "description"),
    6: .same(proto: "mass"),
    7: .standard(proto: "is_open_for_sale"),
    8: .standard(proto: "filling_ids"),
    9: .standard(proto: "category_ids"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.name) }()
      case 2: try { try decoder.decodeSingularBytesField(value: &self.imageData) }()
      case 3: try { try decoder.decodeSingularDoubleField(value: &self.kgPrice) }()
      case 4: try { try decoder.decodeSingularInt32Field(value: &self.rating) }()
      case 5: try { try decoder.decodeSingularStringField(value: &self.description_p) }()
      case 6: try { try decoder.decodeSingularDoubleField(value: &self.mass) }()
      case 7: try { try decoder.decodeSingularBoolField(value: &self.isOpenForSale) }()
      case 8: try { try decoder.decodeRepeatedStringField(value: &self.fillingIds) }()
      case 9: try { try decoder.decodeRepeatedStringField(value: &self.categoryIds) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.name.isEmpty {
      try visitor.visitSingularStringField(value: self.name, fieldNumber: 1)
    }
    if !self.imageData.isEmpty {
      try visitor.visitSingularBytesField(value: self.imageData, fieldNumber: 2)
    }
    if self.kgPrice.bitPattern != 0 {
      try visitor.visitSingularDoubleField(value: self.kgPrice, fieldNumber: 3)
    }
    if self.rating != 0 {
      try visitor.visitSingularInt32Field(value: self.rating, fieldNumber: 4)
    }
    if !self.description_p.isEmpty {
      try visitor.visitSingularStringField(value: self.description_p, fieldNumber: 5)
    }
    if self.mass.bitPattern != 0 {
      try visitor.visitSingularDoubleField(value: self.mass, fieldNumber: 6)
    }
    if self.isOpenForSale != false {
      try visitor.visitSingularBoolField(value: self.isOpenForSale, fieldNumber: 7)
    }
    if !self.fillingIds.isEmpty {
      try visitor.visitRepeatedStringField(value: self.fillingIds, fieldNumber: 8)
    }
    if !self.categoryIds.isEmpty {
      try visitor.visitRepeatedStringField(value: self.categoryIds, fieldNumber: 9)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: CreateCakeRequest, rhs: CreateCakeRequest) -> Bool {
    if lhs.name != rhs.name {return false}
    if lhs.imageData != rhs.imageData {return false}
    if lhs.kgPrice != rhs.kgPrice {return false}
    if lhs.rating != rhs.rating {return false}
    if lhs.description_p != rhs.description_p {return false}
    if lhs.mass != rhs.mass {return false}
    if lhs.isOpenForSale != rhs.isOpenForSale {return false}
    if lhs.fillingIds != rhs.fillingIds {return false}
    if lhs.categoryIds != rhs.categoryIds {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension CreateCakeResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "CreateCakeResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "cake_id"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.cakeID) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.cakeID.isEmpty {
      try visitor.visitSingularStringField(value: self.cakeID, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: CreateCakeResponse, rhs: CreateCakeResponse) -> Bool {
    if lhs.cakeID != rhs.cakeID {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension CreateFillingRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "CreateFillingRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "name"),
    2: .standard(proto: "image_data"),
    3: .same(proto: "content"),
    4: .standard(proto: "kg_price"),
    5: .same(proto: "description"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.name) }()
      case 2: try { try decoder.decodeSingularBytesField(value: &self.imageData) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.content) }()
      case 4: try { try decoder.decodeSingularDoubleField(value: &self.kgPrice) }()
      case 5: try { try decoder.decodeSingularStringField(value: &self.description_p) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.name.isEmpty {
      try visitor.visitSingularStringField(value: self.name, fieldNumber: 1)
    }
    if !self.imageData.isEmpty {
      try visitor.visitSingularBytesField(value: self.imageData, fieldNumber: 2)
    }
    if !self.content.isEmpty {
      try visitor.visitSingularStringField(value: self.content, fieldNumber: 3)
    }
    if self.kgPrice.bitPattern != 0 {
      try visitor.visitSingularDoubleField(value: self.kgPrice, fieldNumber: 4)
    }
    if !self.description_p.isEmpty {
      try visitor.visitSingularStringField(value: self.description_p, fieldNumber: 5)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: CreateFillingRequest, rhs: CreateFillingRequest) -> Bool {
    if lhs.name != rhs.name {return false}
    if lhs.imageData != rhs.imageData {return false}
    if lhs.content != rhs.content {return false}
    if lhs.kgPrice != rhs.kgPrice {return false}
    if lhs.description_p != rhs.description_p {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension CreateFillingResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "CreateFillingResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "filling"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._filling) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if let v = self._filling {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: CreateFillingResponse, rhs: CreateFillingResponse) -> Bool {
    if lhs._filling != rhs._filling {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension CreateCategoryRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "CreateCategoryRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "name"),
    2: .standard(proto: "image_data"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.name) }()
      case 2: try { try decoder.decodeSingularBytesField(value: &self.imageData) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.name.isEmpty {
      try visitor.visitSingularStringField(value: self.name, fieldNumber: 1)
    }
    if !self.imageData.isEmpty {
      try visitor.visitSingularBytesField(value: self.imageData, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: CreateCategoryRequest, rhs: CreateCategoryRequest) -> Bool {
    if lhs.name != rhs.name {return false}
    if lhs.imageData != rhs.imageData {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension CreateCategoryResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "CreateCategoryResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "category"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._category) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if let v = self._category {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: CreateCategoryResponse, rhs: CreateCategoryResponse) -> Bool {
    if lhs._category != rhs._category {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension CategoriesResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "CategoriesResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "categories"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.categories) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.categories.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.categories, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: CategoriesResponse, rhs: CategoriesResponse) -> Bool {
    if lhs.categories != rhs.categories {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension FillingsResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "FillingsResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "fillings"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.fillings) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.fillings.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.fillings, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: FillingsResponse, rhs: FillingsResponse) -> Bool {
    if lhs.fillings != rhs.fillings {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension CakesResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "CakesResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "cakes"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.cakes) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.cakes.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.cakes, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: CakesResponse, rhs: CakesResponse) -> Bool {
    if lhs.cakes != rhs.cakes {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Cake: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "Cake"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "id"),
    2: .same(proto: "name"),
    3: .standard(proto: "image_url"),
    4: .standard(proto: "kg_price"),
    5: .same(proto: "rating"),
    6: .same(proto: "description"),
    7: .same(proto: "mass"),
    8: .standard(proto: "is_open_for_sale"),
    9: .same(proto: "owner"),
    10: .same(proto: "fillings"),
    11: .same(proto: "categories"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.id) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.name) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.imageURL) }()
      case 4: try { try decoder.decodeSingularDoubleField(value: &self.kgPrice) }()
      case 5: try { try decoder.decodeSingularInt32Field(value: &self.rating) }()
      case 6: try { try decoder.decodeSingularStringField(value: &self.description_p) }()
      case 7: try { try decoder.decodeSingularDoubleField(value: &self.mass) }()
      case 8: try { try decoder.decodeSingularBoolField(value: &self.isOpenForSale) }()
      case 9: try { try decoder.decodeSingularMessageField(value: &self._owner) }()
      case 10: try { try decoder.decodeRepeatedMessageField(value: &self.fillings) }()
      case 11: try { try decoder.decodeRepeatedMessageField(value: &self.categories) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    if !self.id.isEmpty {
      try visitor.visitSingularStringField(value: self.id, fieldNumber: 1)
    }
    if !self.name.isEmpty {
      try visitor.visitSingularStringField(value: self.name, fieldNumber: 2)
    }
    if !self.imageURL.isEmpty {
      try visitor.visitSingularStringField(value: self.imageURL, fieldNumber: 3)
    }
    if self.kgPrice.bitPattern != 0 {
      try visitor.visitSingularDoubleField(value: self.kgPrice, fieldNumber: 4)
    }
    if self.rating != 0 {
      try visitor.visitSingularInt32Field(value: self.rating, fieldNumber: 5)
    }
    if !self.description_p.isEmpty {
      try visitor.visitSingularStringField(value: self.description_p, fieldNumber: 6)
    }
    if self.mass.bitPattern != 0 {
      try visitor.visitSingularDoubleField(value: self.mass, fieldNumber: 7)
    }
    if self.isOpenForSale != false {
      try visitor.visitSingularBoolField(value: self.isOpenForSale, fieldNumber: 8)
    }
    try { if let v = self._owner {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 9)
    } }()
    if !self.fillings.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.fillings, fieldNumber: 10)
    }
    if !self.categories.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.categories, fieldNumber: 11)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Cake, rhs: Cake) -> Bool {
    if lhs.id != rhs.id {return false}
    if lhs.name != rhs.name {return false}
    if lhs.imageURL != rhs.imageURL {return false}
    if lhs.kgPrice != rhs.kgPrice {return false}
    if lhs.rating != rhs.rating {return false}
    if lhs.description_p != rhs.description_p {return false}
    if lhs.mass != rhs.mass {return false}
    if lhs.isOpenForSale != rhs.isOpenForSale {return false}
    if lhs._owner != rhs._owner {return false}
    if lhs.fillings != rhs.fillings {return false}
    if lhs.categories != rhs.categories {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension User: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "User"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "id"),
    2: .same(proto: "fio"),
    3: .same(proto: "nickname"),
    4: .same(proto: "mail"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.id) }()
      case 2: try { try decoder.decodeSingularMessageField(value: &self._fio) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.nickname) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.mail) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    if !self.id.isEmpty {
      try visitor.visitSingularStringField(value: self.id, fieldNumber: 1)
    }
    try { if let v = self._fio {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    } }()
    if !self.nickname.isEmpty {
      try visitor.visitSingularStringField(value: self.nickname, fieldNumber: 3)
    }
    if !self.mail.isEmpty {
      try visitor.visitSingularStringField(value: self.mail, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: User, rhs: User) -> Bool {
    if lhs.id != rhs.id {return false}
    if lhs._fio != rhs._fio {return false}
    if lhs.nickname != rhs.nickname {return false}
    if lhs.mail != rhs.mail {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Filling: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "Filling"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "id"),
    2: .same(proto: "name"),
    3: .standard(proto: "image_url"),
    4: .same(proto: "content"),
    5: .standard(proto: "kg_price"),
    6: .same(proto: "description"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.id) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.name) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.imageURL) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.content) }()
      case 5: try { try decoder.decodeSingularDoubleField(value: &self.kgPrice) }()
      case 6: try { try decoder.decodeSingularStringField(value: &self.description_p) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.id.isEmpty {
      try visitor.visitSingularStringField(value: self.id, fieldNumber: 1)
    }
    if !self.name.isEmpty {
      try visitor.visitSingularStringField(value: self.name, fieldNumber: 2)
    }
    if !self.imageURL.isEmpty {
      try visitor.visitSingularStringField(value: self.imageURL, fieldNumber: 3)
    }
    if !self.content.isEmpty {
      try visitor.visitSingularStringField(value: self.content, fieldNumber: 4)
    }
    if self.kgPrice.bitPattern != 0 {
      try visitor.visitSingularDoubleField(value: self.kgPrice, fieldNumber: 5)
    }
    if !self.description_p.isEmpty {
      try visitor.visitSingularStringField(value: self.description_p, fieldNumber: 6)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Filling, rhs: Filling) -> Bool {
    if lhs.id != rhs.id {return false}
    if lhs.name != rhs.name {return false}
    if lhs.imageURL != rhs.imageURL {return false}
    if lhs.content != rhs.content {return false}
    if lhs.kgPrice != rhs.kgPrice {return false}
    if lhs.description_p != rhs.description_p {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Category: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "Category"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "id"),
    2: .same(proto: "name"),
    3: .standard(proto: "image_url"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.id) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.name) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.imageURL) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.id.isEmpty {
      try visitor.visitSingularStringField(value: self.id, fieldNumber: 1)
    }
    if !self.name.isEmpty {
      try visitor.visitSingularStringField(value: self.name, fieldNumber: 2)
    }
    if !self.imageURL.isEmpty {
      try visitor.visitSingularStringField(value: self.imageURL, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Category, rhs: Category) -> Bool {
    if lhs.id != rhs.id {return false}
    if lhs.name != rhs.name {return false}
    if lhs.imageURL != rhs.imageURL {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
