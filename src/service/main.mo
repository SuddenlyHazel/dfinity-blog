import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Time "mo:base/Time";
import Char "mo:base/Char";
import Text "mo:base/Text";
import Option "mo:base/Option";
import Db "db";
import Types "types";

shared({ caller = initializer}) actor class Service() {
    var owner : Principal = Principal.fromText("ww6r2-rinbd-x7gir-slwrk-32wck-feluo-or73f-4z4hx-mjbpb-d7fkh-4ae");

    let db : Db.Db = Db.Db();

    func isCallerOwner(caller : Principal) : Bool {
        return owner == caller or initializer == caller;
    };

    public query(msg) func whoAmI() : async Principal {
        msg.caller;
    };

    public query(msg) func isOwner() : async Bool {
        msg.caller == initializer or msg.caller == owner;
    };

    public query func getBlogMeta() : async Types.BlogMeta {
        return db.getMeta();
    };

    public shared(msg) func createPost(newPost : Types.BlogPostEgg) : async Bool {
        if (not isCallerOwner(msg.caller)) {
            return false;
        };
        let _ = db.createPost(newPost);
        return true;
    };

    public query func getPost(id : Nat) : async ?Types.BlogPost {
        db.getPost(id);
    };

    public query func listPosts() : async [Types.BlogPostSummary] {
        db.listPosts();
    };

    public shared(msg) func setOwner(new : Principal) {
        if (not isCallerOwner(msg.caller)) {
            return;
        };

        owner := new;
    };
};