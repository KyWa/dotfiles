# Golang

`defer` is a statement that can be placed into a function to do something AFTER the `func` has exited. Examples would be to close an HTTP connection, print something other than the `return` value or anything required.

```go
func main() {
     defer fmt.Println("were done")
     
     fmt.Println("We are going to do a thing")
}

```

When doing a reflect on a type, you must use Println to view the result as Printf will not work
