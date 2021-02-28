import Array "mo:base/Array";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import TrieSet "mo:base/TrieSet";
import Types "../types";
import PublicTypes "../public_types";
import Debug "mo:base/Debug";

module {
    public class BlogRegistry() {
        // Only allow whole word tag search right now. Kinda lame, but oh well..
        let keyWordsDb = HashMap.HashMap<Text, BlogMembers>(0, func(l : Text, r : Text){l == r}, Text.hash);
        let blogsDb = HashMap.HashMap<Principal, Types.BlogMeta>(0, func(l : Principal, r : Principal){l == r}, Principal.hash);

        public func listBlogs() : [{id: Principal; meta: Types.BlogMeta}] {
            var all : [{id: Principal; meta: Types.BlogMeta}] = [];

            for ((k, v) in blogsDb.entries()) {
                all := Array.append(all, [
                    {
                        id = k;
                        meta = v;
                    }
                ])
            };
            all;
        };

        public func removeBlog(blog : Principal) {
            switch(blogsDb.get(blog)) {
                case null {
                    return;
                };
                case (?v) {
                    for (tag in Array.vals(v.tags)) {
                        switch(keyWordsDb.get(tag)) {
                            case null {};
                            case (?members) {
                                members.removeBlog(blog);
                            }
                        }
                    };
                    let _ = blogsDb.remove(blog);
                    return;
                };
            }
        };

        public func registerBlog(blog : Principal) : async Bool {
            Debug.print("Attempting to register " # Principal.toText(blog));
            let service : PublicTypes.BlogCanister = actor(Principal.toText(blog));
            let meta : Types.BlogMeta = await service.getBlogMetadata();

            for (key in Array.vals(meta.tags)) {
                switch(keyWordsDb.get(key)) {
                    case null {
                        let member = BlogMembers();
                        member.insertBlog(blog);
                        keyWordsDb.put(key, member);
                    };
                    case (?v) {
                        v.insertBlog(blog);
                    };
                };
            };
            blogsDb.put(blog, meta);
            true;
        };
    };

    public class BlogMembers() {
        var items : TrieSet.Set<Principal> = TrieSet.empty<Principal>();
        
        public func getBlogs() : [Principal] {
            TrieSet.toArray(items);
        };

        public func insertBlog(blog : Principal) {
            items := TrieSet.put<Principal>(items, blog, Principal.hash(blog), func( l : Principal, r : Principal) { return l == r})
        };

        public func removeBlog(blog : Principal) {
            items := TrieSet.delete<Principal>(items, blog, Principal.hash(blog), func( l : Principal, r : Principal) { return l == r})
        };
    };
}