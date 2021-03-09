# motoko-regex

Simple regex matching for Motoko Text.

This project in it's very early stages and primarily serves as an example
of how to structure a Motoko library.

## Example
```motoko
import Regex "mo:regex/Regex";

assert(Regex.test(#rep(#seq(#char('A'), #char('B'))), "ABABABABAB"));
assert(not Regex.test(#rep(#seq(#char('A'), #char('B'))), "ABA"));
```

## Building

- Install [`vessel`](https://github.com/dfinity/vessel)
- Run `make check`, `make test`, or `make docs`
