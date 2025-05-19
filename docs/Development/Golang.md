# Golang

## Sections
* [Data Types](golang/datatypes)
* [Functions and Controls](golang/Functions)
* [Packages](golang/Packages)

## Structure of a `go` application
The file named `go.mod` declares the module path: the import path prefix for all packages within the module. The module contains the packages in the directory containing its `go.mod` file as well as subdirectories of that directory, up to the next subdirectory containing another `go.mod` file (if any).

To build or run the application, you would do something like the following:

```go
# Create a binary after the build
go build path/to/files.go

# Run the program without creating a binary
go run path/to/files.go
```

## Misc Notes
`defer` is a statement that can be placed into a function to do something AFTER the `func` has exited. Examples would be to close an HTTP connection, if a successful connection was made.

```go
func main() {
     defer fmt.Println("were done")
     fmt.Println("We are going to do a thing")
}
```

### Snippets/Tricks
`go fmt myfile.go` will run `fmt` against the code and "clean" it up.
