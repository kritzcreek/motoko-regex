# motoko-regex

Simple regex matching for Motoko Text.

Example:
```motoko
import Regex "mo:regex/Regex";

assert(Regex.test(#rep(#seq(#char('A'), #char('B'))), "ABABABABAB"));
assert(not Regex.test(#rep(#seq(#char('A'), #char('B'))), "ABA"));
```

This is in it's very early stages and primarily serves as an example
of how to structure a Motoko library.
