# Golang Functions and Control Structures

## Basic Function Layout
`func` will define a function to run code and all code must be in a function. You can call functions from other functions like so: `anotherFunc()`. Variables can be accepted and passed to functions which are placed in the `()` of the function with a return type being set outside of the `()` in the function like so which can have multiple return types:

```go
# Calling another function
func main(){
    texting := "thing"
    printerFunc(texting)
}

func printerFunc(valToPrint string){
    fmt.Println(valToPrint)
}

# Return type specified
func returnSomething(var1 int, var2 int) int {}

# Multiple return types specified
func returnSomething(var1 int, var2 int) (int, int) {}
```

## Control Structures

### Comparisons
As with most languages your comparison operators of `!=` and `==` which will compare and return based on the validity of the comparison being made. `if` statements function similarly to other languages as well.

#### `if` statements
```go
if thing != "something" {
  fmt.Println("something isnt real")
}else if thing == "something" {
  fmt.Println("something is real")
}else{
  fmt.Println("Nobodys real")
}
```
#### `switch` statements
```go
# Case statements to check similar to an if statement
switch {
  case thing != "something":
    fmt.Println("something isnt real")
  case thing == "something":
    fmt.Println("something is real")
  default:
    fmt.Println("Nobodys real")
}

# Case statement to check against something specific
switch someVar {
  case "nothing":
    fmt.Println("something isnt real")
  case "something":
    fmt.Println("something is real")
  default:
    fmt.Println("Nobodys real")
}
```

### Operators
There are also operators as you would expect such as `||` for "or" and `&&` for checking multiple statements.

```go
# Check to see if both statements are true
if thing == "real" && another == "real"

# Checks to see if either statement is true
if thing == "real" || another == "real"
```

### Error Handling
Error handling can be done by importing the `"errors"` package and defining `error` variables in your functions. You must define the error handling in a few places, but you can customize things where needed

```go
var err error

if foo == "bar"{
    err = errors.New("Your custom error message")
}
```

### Loops
TODO: COPY FROM testing objects
