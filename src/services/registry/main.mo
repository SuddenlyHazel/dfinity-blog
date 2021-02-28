import Char "mo:base/Char";
import ExperimentalCycles "mo:base/ExperimentalCycles";
import HashMap "mo:base/HashMap";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Random "mo:base/Random";
import Result "mo:base/Result";
import BlogRegistry "BlogRegistry";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Types "../types";

// Simple Canister exposing an interface to allow blog canisters to register 
shared({ caller = initializer}) actor class Registery() {
   let registry = BlogRegistry.BlogRegistry();

   public type BlogListing = {
      name : Text;
   };

   public query func listBlogs() : async [{id: Principal; meta: Types.BlogMeta}] {
      return registry.listBlogs();
   };

   public shared(msg) func registerBlog() : async Result.Result<(), Text> {

      /*
      Canister could require cycles inorder to register itself! Woah!
      let cycles = ExperimentalCycles.available();
      let balance = ExperimentalCycles.balance();
      // About .10 cents
      if (cycles != 28571428571) {
         return #err("Need to send 28571428571 cycles");
      };

      let _ = ExperimentalCycles.accept(1000);
      */
      let _ = await registry.registerBlog(msg.caller);
      #ok()
   }
};