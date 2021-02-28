import Char "mo:base/Char";
import BlogController "BlogController";
import HashMap "mo:base/HashMap";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Types "../types";
import PublicTypes "../public_types";

shared({ caller = initializer}) actor class Service() {
    var owner : Principal = Principal.fromText("tlnld-p2tcv-5w2qf-zb6zd-tbx4z-mke63-upybz-rjrbc-dw3vm-jv6ua-5ae");

    let blogController : BlogController.BlogController = BlogController.BlogController();
    var memberController : ?PublicTypes.MembershipCanister = null;
    func isCallerOwner(caller : Principal) : Bool {
        return owner == caller or initializer == caller;
    };

    // Allows owner to register blog with a registry canister
    // Registery canisters recieve pub updates from blog posts
    public shared(msg) func registerBlog(registry : Principal) : async Bool {
        if (not isCallerOwner(msg.caller)) {
            return false;
        };
        await blogController.registerBlog(registry)
    };

    // Allows owner to delegate access to a Membership Canister
    public shared(msg) func installMembershipCanister(canister : Principal) : async Bool {
        if (not isCallerOwner(msg.caller)) {
            return false;
        };
        memberController := ?actor(Principal.toText(canister));
        true
    };

    public func getMembershipCanister() : async ?PublicTypes.MembershipCanister {
        memberController;
    };

    public query(msg) func whoAmI() : async Principal {
        msg.caller;
    };

    public query(msg) func isOwner() : async Bool {
        msg.caller == initializer or msg.caller == owner;
    };

    public query func getBlogMetadata() : async Types.BlogMeta {
        return blogController.getMeta();
    };

    public shared(msg) func createPost(newPost : Types.BlogPostEgg) : async Bool {
        if (not isCallerOwner(msg.caller)) {
            return false;
        };
        let cbMsg = blogController.createPost(newPost);
        let _ = blogController.notifySubscribers(cbMsg);
        return true;
    };

    public query func getPost(id : Nat) : async ?Types.BlogPost {
        blogController.getPost(id);
    };

    public query func listPosts() : async [Types.BlogPostSummary] {
        blogController.listPosts();
    };

    public shared(msg) func setOwner(new : Principal) {
        if (not isCallerOwner(msg.caller)) {
            return;
        };
        owner := new;
    };
};