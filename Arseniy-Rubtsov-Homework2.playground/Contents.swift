import UIKit
/*:
 Придумать и реализовать класс/структуру с дженириком + экстеншен тоже с дженериком. Привести пример использования вашей структуры/класса.
 */
class Stack<T> {
    private var elements: [T] = []
    
    func push(_ element: T) {
        elements.append(element)
    }
    
    func pop() -> T? {
        return elements.popLast()
    }
    
    func peek() -> T? {
        return elements.last
    }
    
    func isEmpty() -> Bool {
        return elements.isEmpty
    }
    
    func count() -> Int {
        return elements.count
    }
}

extension Stack {
    func removeAll() {
        elements.removeAll()
    }
}

var intStack = Stack<Int>()

intStack.push(1)
intStack.push(2)
intStack.push(3)

print("Number of stack elements: \(intStack.count())")

if let poppedElement = intStack.pop() {
    print("Popped element: \(poppedElement)")
}

if let poppedElement = intStack.pop() {
    print("Popped element: \(poppedElement)")
}

if let poppedElement = intStack.pop() {
    print("Popped element: \(poppedElement)")
}

intStack.push(3)
intStack.push(3)
intStack.push(3)
intStack.push(3)

print("Number of stack elements: \(intStack.count())")

intStack.removeAll()
print("Stack is empty: \(intStack.isEmpty())")
/*:
 Также реализовать протокол с ассоциативными типами + пример использования.
 */
protocol Shape {
    associatedtype PointType
    associatedtype AreaType
    
    func area() -> AreaType
    func describeCoordinates() -> [PointType]
}

struct Rectangle: Shape {
    typealias PointType = (x: Double, y: Double)
    typealias AreaType = Double
    
    private let origin: PointType
    private let width: Double
    private let height: Double
    
    init(origin: PointType, width: Double, height: Double) {
        self.origin = origin
        self.width = width
        self.height = height
    }
    
    func area() -> AreaType {
        return width * height
    }
    
    func describeCoordinates() -> [PointType] {
        return [origin, (x: origin.x + width, y: origin.y), (x: origin.x, y: origin.y + height), (x: origin.x + width, y: origin.y + height)]
    }
}

let rectangle = Rectangle(origin: (x: 0.0, y: 0.0), width: 5.0, height: 3.0)
print("Rectangle Area: \(rectangle.area())")
print("Rectangle Coordinates: \(rectangle.describeCoordinates())")
/*:
 Изучить и реализовать стирание с помощью оберток с приватными классами. Хорошая статья на русском: (https://medium.com/@antonagarunov/стирание-типов-type-erasure-в-swift-9378bf1a772d)
 */
protocol Animal {
    func speak()
}

struct Dog: Animal {
    func speak() {
        print("ГАВ!")
    }
}

struct Cat: Animal {
    func speak() {
        print("МЯУ!")
    }
}

class AnyAnimal {
    private let _speak: () -> Void
    
    init<T: Animal>(_ animal: T) {
        _speak = animal.speak
    }
    
    func speak() {
        _speak()
    }
}

let dog = Dog()
let cat = Cat()

let animals: [AnyAnimal] = [AnyAnimal(dog), AnyAnimal(cat)]

for animal in animals {
    animal.speak()
}
