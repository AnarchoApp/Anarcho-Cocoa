# JSON to Swift mapper

A helper class for parsing JSON text and mapping it to Swift types.

## Setup

Copy [JsonSwiftson.swift](https://github.com/evgenyneu/JsonSwiftson/blob/master/JsonSwiftson/Lib/JsonSwiftson.swift) file to your Xcode project.


## Usage

1. First, create an instance of `JsonSwiftson` class.
1. Call `map` or `mapArrayOfObjects` methods.
1. Finally, check `ok` property to see if mapping was successful.

### Map simple values

Simple values are strings, numbers and booleans.

```Swift
// String
let stringMapper = JsonSwiftson(json: "\"Hello World\"")
let string: String? = stringMapper.map()

// Integer
let intMapper = JsonSwiftson(json: "123")
let int: Int? = intMapper.map()

// Double
let doubleMapper = JsonSwiftson(json: "123.456")
let double: Double? = doubleMapper.map()

// Boolean
let boolMapper = JsonSwiftson(json: "true")
let bool: Bool? = boolMapper.map()
```

### Map property by name

Use square brackets to reach JSON properties by name: mapper["name"]`.

```Swift
let mapper = JsonSwiftson(json: "{ \"name\": \"Michael\" }")
let name: String? = mapper["name"].map()
```

### Map arrays of simple values

Here is how you can map arrays of strings, numbers and booleans.

```Swift
// String
let stringMapper = JsonSwiftson(json: "[\"One\", \"Two\"]")
let string: [String]? = stringMapper.map()

// Integer
let intMapper = JsonSwiftson(json: "[1, 2]")
let int: [Int]? = intMapper.map()

// Double
let doubleMapper = JsonSwiftson(json: "[1.1, 2.2]")
let double: [Double]? = doubleMapper.map()

// Boolean
let boolMapper = JsonSwiftson(json: "[true, false]")
let bool: [Bool]? = boolMapper.map()
```

### Map an array of objects

Use `mapArrayOfObjects` with a closure to map array of object.

**Tip**: Use `map` method for mapping arrays of simple values like strings, numbers and booleans.

```Swift
struct Person {
  let name: String
  let age: Int
}

let mapper = JsonSwiftson(json:
  "[ " +
    "{ \"name\": \"Peter\", \"age\": 41 }," +
    "{ \"name\": \"Ted\", \"age\": 51 }" +
  "]")

let value: [Person]? = mapper.mapArrayOfObjects { j in
  Person(
    name: j["name"].map() ?? "",
    age: j["age"].map() ?? 0
  )
}
```

### Mapping to Swift structures

```Swift
struct Person {
  let name: String
  let age: Int
}

let mapper = JsonSwiftson(json: "{ \"name\": \"Peter\", \"age\": 41 }")

let value: Person? = Person(
  name: mapper["name"].map() ?? "",
  age: mapper["age"].map() ?? 0
)
```

### Check if mapping was successful

Verify the `ok` property to see if mapping was successful.
Mapping fails for incorrect JSON and type casting problems.

```Swift
let successMapper = JsonSwiftson(json: "\"Correct type\"")
let string: String? = successMapper.map()
successMapper.ok // true

let failMapper = JsonSwiftson(json: "\"Wrong type\"")
let number: Int? = failMapper.map()
failMapper.ok // false
```

### Allow missing values

Mapping fails by default if JSON value is null or attribute is missing.

**Tip:** Use `optional: true` parameter in `map` or `mapArrayOfObjects` functions to allow missing values.

```Swift
let mapper = JsonSwiftson(json: "{ }")
let string: String? = mapper["name"].map(optional: true)
mapper.ok // true
```

### Allow missing objects

Use `map` method with `optional: true` parameter and a closure to allow empty objects.

```
struct Person {
  let name: String
  let age: Int
}

let mapper = JsonSwiftson(json: "null") // empty

let value: Person? = mapper.map(optional: true) { j in
  Person(
    name: j["name"].map() ?? "",
    age: j["age"].map() ?? 0
  )
}

mapper.ok // true
```

### Tip: map to a non-optional type

Use `??` operator after the mapper if you need to map to a non-optional type like `let number: Int`.

```Swift
let mapper = JsonSwiftson(json: "123")
let number: Int = mapper.map() ?? 0
```

### Performance benchmark

This demo app is a performance benchmark. It maps a large JSON file containing 100 records. The process is repeated 100 times to see how fast it runs on different devices and catch performance regressions.

<img src='https://raw.githubusercontent.com/evgenyneu/JsonSwiftson/master/Graphics/json_swiftson_screenshot.png' alt='Json Swiftson performance benchmark' width='320'>

