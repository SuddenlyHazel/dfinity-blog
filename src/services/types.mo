import TrieSet "mo:base/TrieSet";
module {
    // Member Types

    public type DelegatedCall = {
        member : Principal;
        action : MemberAction;
    };

    public type Call = {
        payload : shared (Any) -> async Any;
    };

    // For example {name : "comment", trustLevel : 1000}
    public type MemberAction = {
        name : Text;
        trustLevel : Nat16;
    };

    public type MemberState = {
        trust : Nat16
    };

    // Settings Types
    public type MenuLink = {
        id : Nat;
        text: Text;
    };

    public type BlogMeta = {
        name: Text;
        links: [MenuLink];
        summary: ?Text;
        image: ?Text;
        tags: [Text];
    };

    // Blog Types
    public type BlogPostEgg = {
        socialImage: ?Text;
        content: Text;
        title: Text;
        tags: [Text]
    };

    public type BlogPost = {
        socialImage: ?Text;
        content: Text;
        title: Text;
        time: Int;
        tags: [Text]
    };

    public type BlogPostSummary = {
        socialImage: ?Text; 
        id: Nat;
        title: Text;
        time: Int;
        summary: Text;
    };

    // Keeping this really slim. We could even remove the title field
    public type BlogPostPubMessage = {
        id: Nat;
        title: Text;
        time: Int;
    };

    // Pages Types
    public type Page = {
        content: Text;
        title: Text
    };

    public type PageSummary = {
        id: Nat;
        title: Text;
    };
};
