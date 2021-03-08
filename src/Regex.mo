module {

    public type Regex = { 
        #zero;
        #empty;
        #char : Char; 
        #alt : (Regex, Regex); 
        #seq : (Regex, Regex); 
        #rep : Regex; 
    };

    public func toText(regex : Regex) : Text {
        debug_show(regex)
    };

    // Smart constructors
    func seq(r1 : Regex, r2 : Regex) : Regex {
        switch (r1, r2) {
            case (#zero, _) #zero;
            case (_, #zero) #zero;
            case (#empty, _) r2;
            case (_, #empty) r1;
            case _ (#seq(r1, r2))
        }
    };

    func alt(r1 : Regex, r2 : Regex) : Regex {
        switch (r1, r2) {
            case (#zero, _) r2;
            case (_, #zero) r1;
            case _ (#alt(r1, r2))
        }
    };

    func rep(r : Regex) : Regex {
        switch(r) {
            case (#zero or #empty) #empty;
            case _ #rep(r);
        }
    };

    // δ(∅) = ∅
    // δ(ε) = ε
    // δ(c) = ∅
    // δ(re1 re2) = δ(re1) δ(re2)
    // δ(re1 | re2) = δ(re1) | δ(re2)
    // δ(re*) = ε
    func regexEmpty(regex : Regex) : Regex {
        switch (regex) {
          case (#zero) #zero;
          case (#empty) #empty;
          case (#char(_)) #zero; 
          case (#alt(r1, r2)) alt(regexEmpty(r1), regexEmpty(r2)); 
          case (#seq(r1, r2)) seq(regexEmpty(r1), regexEmpty(r2)); 
          case (#rep(_)) #empty;
        }
    };


    // Dc(∅) = ∅
    // Dc(ε) = ∅
    // Dc(c) = ε
    // Dc(c') = ∅ if c ≠ c'.
    // Dc(re1 re2) = δ(re1) Dc(re2) | Dc(re1) re2
    // Dc(re1 | re2) = Dc(re1) | Dc(re2)
    // Dc(re*) = Dc(re) re*
    func regexDerivative(regex : Regex, char : Char) : Regex {
        switch (regex) {
          case (#zero) {
              #zero
          };
          case (#empty) {
              #zero
          };
          case (#char(c)) {
              if (char == c) {
                  #empty
              } else {
                  #zero
              }
          }; 
          case (#seq(r1, r2)) {
              alt(
                seq(regexEmpty(r1), regexDerivative(r2, char)), 
                seq(regexDerivative(r1, char), r2)
              )
          };
          case (#alt(r1, r2)) {
              alt(regexDerivative(r1, char), regexDerivative(r2, char))
          };
          case (#rep(r)) {
              seq(regexDerivative(r, char), regex)
          };
        }
    };

    /// Checks whether the entire given Text matches the Regex.
    public func test(regex : Regex, text : Text) : Bool {
        let chars = text.chars();
        func go(regex : Regex) : Bool {
            switch (chars.next()) {
                case (null) {
                    regexEmpty(regex) == #empty
                };
                case (?c) {
                    go(regexDerivative(regex, c))
                }
            }
        };

        go(regex)
    };
}
