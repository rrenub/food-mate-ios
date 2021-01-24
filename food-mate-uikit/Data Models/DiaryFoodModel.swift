//
//  DiaryFood.swift
//  food-mate-uikit
//
//  Created by Ruben Delgado on 31/12/2020.
//

import Foundation

struct DiaryFoodModel {
    var id : UUID
    var date : Date
    var name, meal: String
    var quantity : Double
    var carbs, prots, fats, calories : Double
    
    var type : FoodType
    
    enum FoodType : Decodable {
        case todos
        case bebida
        case carne
        case legumbres
        case fruta
        case verdura
        case procesada
    }
}

extension DiaryFoodModel.FoodType: CaseIterable { }

extension DiaryFoodModel.FoodType: RawRepresentable {
  typealias RawValue = String
  
  init?(rawValue: RawValue) {
    switch rawValue {
    case "Todos": self = .todos
    case "Bebida": self = .bebida
    case "Carne": self = .carne
    case "Legumbres": self = .legumbres
    case "Fruta": self = .fruta
    case "Verdura": self = .verdura
    case "Procesada": self = .procesada
    default: return nil
    }
  }
  
  var rawValue: RawValue {
    switch self {
        case .todos: return "Todos"
        case .bebida: return "Bebida"
        case .carne: return "Carne"
        case .legumbres: return "Legumbres"
        case .fruta: return "Fruta"
        case .verdura: return "Verdura"
        case .procesada: return "Procesada"
    }
  }
}

