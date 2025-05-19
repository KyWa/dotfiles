# Golang Package Notes and Examples
Built-in Packages and their usage

## `fmt`

## `flags`

## `os`

## `log`

## `errors`
Error handling can be done by importing the "errors" package and defining error variables in your functions. You must define the error handling in a few places, but you can customize things where needed.

```go
var err error

if foo == "bar" {
    err = errors.New("Your custom error message")
}
```
