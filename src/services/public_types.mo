import Result "mo:base/Result";
import Types "types";

module {
    public type RegistryCanister = actor {
        registerBlog  : shared () -> async Result.Result<(), Text>;
    };

    public type BlogCanister = actor {
        getBlogMetadata  : shared () -> async Types.BlogMeta;
    };

    public type MembershipCanister = actor {
        canUserExecuteAction : shared (caller : Principal, action : Types.MemberAction) -> async Bool;
        registerMember : shared -> async Bool;
        getMemberActions : shared -> async [Types.MemberAction];
    };
};