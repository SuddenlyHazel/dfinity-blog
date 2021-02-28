import Array "mo:base/Array";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import TrieSet "mo:base/TrieSet";
import Types "../types";

module {
    public class MemberController() {
        let memberDb = HashMap.HashMap<Principal, Member>(0, func(l : Principal, r : Principal) {l == r}, Principal.hash);
        
        let actions = HashMap.HashMap<Text, Nat16>(0, func(l : Text, r : Text){ l == r}, Text.hash);
        
        let init = do {
            actions.put("comment", 10000);
        };

        public func getMemberActions() : [Types.MemberAction] {
            var val : [Types.MemberAction] = [];
            for ((k, v) in actions.entries()) {
                val := Array.append(val, [{
                    name = k;
                    trustLevel = v;
                }]);
            };
            val;
        };

        public func createMember(p : Principal, trust : Nat16) : Bool {
            switch(memberDb.get(p)) {
                case (null) {
                    memberDb.put(p, Member(p, trust));
                    true
                };
                case (?_) {false}
            }
        };

        public func canMemberExecuteAction(p : Principal, action : Types.MemberAction) : Bool {
            switch(memberDb.get(p)) {
                case (null) {false};
                case (?v) {
                    v.canMemberExecuteAction(action)
                };
            }
        };

        // This needs some more thought. 
        public func canDelegateExecuteAction(caller : Principal, call : Types.DelegatedCall) : Bool {
            switch(memberDb.get(call.member)) {
                case (null) {false};
                case (?v) {
                    v.canDelegateExecuteAction(call.action, caller)
                };
            }
        };
    };

    // Stashing a bunch of these instances is pretty expensive. In the future refactor to operate on a record, or just go functional.
    // Encapulating all this in a class is best for now
    private class Member(p : Principal, startTrust : Nat16) {
        private let id = p;
        private var memberTrust = startTrust;
        private let delegatedPrinciples = HashMap.HashMap<Principal, Nat16>(0, func(l : Principal, r : Principal) {l == r}, Principal.hash);
        
        public func getRecord() : Types.MemberState {
            return {
                trust = memberTrust;
            }
        };

        public func canMemberExecuteAction(action : Types.MemberAction) : Bool {
            return canExecute(memberTrust, action.trustLevel);
        };

        public func canDelegateExecuteAction(action : Types.MemberAction, delegate : Principal) : Bool {
            switch(delegatedPrinciples.get(delegate)) {
                case (null) {false};
                case (?v) {
                    return canExecute(v, action.trustLevel);
                }
            }
        };

        public func delegatePrincipleTrust(p : Principal, trust : Nat16) {
            delegatedPrinciples.put(p, trust);
        };
    };

    func canExecute(has : Nat16, needed : Nat16) : Bool {
        return has >= needed;
    }
}