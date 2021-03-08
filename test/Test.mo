import Debug "mo:base/Debug";
import M "mo:matchers/Matchers";
import Regex "../src/Regex";
import S "mo:matchers/Suite";
import T "mo:matchers/Testable";

func regex(regex : Regex.Regex) : M.Matcher<Text> {
    {
        describeMismatch = func (text : Text, desc : M.Description) {
            desc.appendText("Failed to accept \"" # text # "\" from " # Regex.toText(regex))
        };
        matches = func (text : Text) {
            Regex.test(regex, text)
        }
    }
};

func regexFail(regex : Regex.Regex) : M.Matcher<Text> {
    {
        describeMismatch = func (text : Text, desc : M.Description) {
            desc.appendText("Failed to reject \"" # text # "\" from " # Regex.toText(regex))
        };
        matches = func (text : Text) {
            not Regex.test(regex, text)
        }
    }
};

let repA = #rep(#char('A'));

func lotsa(n : Nat, t : Text) : Text {
    var i = n;
    var res = t;
    while (i > 0) {
        res #= t;
        i -= 1;
    };
    Debug.print("Lotsa");
    res
};

let suite = S.suite("Test", [
    S.test("zero never matches", "", regexFail(#zero)),
    S.test("match the empty string", "", regex(#empty)),
    S.test("empty doesn't match a non-empty string", "A", regexFail(#empty)),
    S.test("it matches a char", "A", regex(#char('A'))),
    S.test("it matches repetitions", "", regex(repA)),
    S.test("it matches repetitions", "AAAAAAAAA", regex(repA)),
    S.test("Take a chance on me", lotsa(10000, "AB"), regex(#rep(#seq(#char('A'), #char('B'))))),
]);

S.run(suite);
