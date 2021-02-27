module {
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
