# Golang Variables and Data Types

## Variables
- `int` is an integer with values such as: `42`
    - `int` can also be broken down into more specific types such as `int8`/`int16`/`int32`/`int64`
    - `uint` is an unsigned integer which also has its specific types as above
- `float32` and `float64` are for floating numbers such as: `12345.67`
- `string` is a string as you expect: `"some string"`
- `bool` is a standard boolean type such as: `true`
- `error` is a data type specifically for errors and defaults to `nil`

The default values for `int`, `uint` and `float*` is `0` while `string` defaults to `''` and the `bool` defaults to `false`. Strings are handled via `UTF-8` encoding.

### Declaring Variables
```go
# Speciyfing the type right away
var myString string

# Inferring the type
var myString = "bar"

# Shorthand declaration which also infers
myString := "bar"

# Creating multiple vars at the same time
var var1, var2 string = "foo", "bar"
var1, var2 := "foo", "bar"
```

## Constants
Same as Variables, but once set, cannot be changed. They cannot just be declared, but must be defined.

```go
const myConst string = "constant value"
```

## Arrays and Slices
Arrays have a fixed length where Slices have a more manipulatable type.

```go
# Creates an array with 5 elements that all share the int type
integerArray := [5]int
integerArray := [5]int{5,17,99,24,59}
integerArray := [...]int{5,17,99,24,59}

# Print a specific item
fmt.Println(integerArray[2])

# Creates slice with 3 values
integerSlice := []int{99,15,31}

# Append to a slice
integerSlice = append(integerSlice, 7)

# Create a Slice with set initial values "0" and capacity "8"
integerSlice := make([]int, 0, 8)
```

## Map
Maps are basically dictionaries that you are used to, aka key:value stores.

```go
# Create a map
myMap := map[string]int{"a":1,"b":2,"c":3}

# Get a value from a map
fmt.Println(myMap["a"])

# Go can return additional items for maps to test against
var1, var2 := myMap["c"]

# Built-in delete function can be used to remove an item from a map
delete(myMap, "a")
```
