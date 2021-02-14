# Golang

## Sections

* Arrays
* Functions
* Maps
* Builds
* Misc
* Examples

Go programs are organized into packages. A package is a collection of source files in the same directory that are compiled together. A repository contains one or more modules. A module is a collection of related Go packages that are released together. A file named `go.mod` there declares the module path: the import path prefix for all packages within the module. The module contains the packages in the directory containing its `go.mod` file as well as subdirectories of that directory, up to the next subdirectory containing another `go.mod` file (if any).

`defer` is a statement that can be placed into a function to do something AFTER the `func` has exited. Examples would be to close an HTTP connection, if a successful connection was made.

```go
func main() {
     defer fmt.Println("were done")
     fmt.Println("We are going to do a thing")
}
```

When doing a reflect on a type, you must use Println to view the result as Printf will not work
