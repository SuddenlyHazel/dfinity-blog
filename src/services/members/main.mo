import MemberController "MemberController";
import Types "../types";

actor {
    let memberController : MemberController.MemberController = MemberController.MemberController();

    public query func canUserExecuteAction(caller : Principal, action : Types.MemberAction) : async Bool {
        memberController.canMemberExecuteAction(caller, action);
    };

    public shared(msg) func registerMember() : async Bool {
        let _ = memberController.createMember(msg.caller, 16383);
        true;
    };

    public query func getMemberActions() : async [Types.MemberAction] {
        memberController.getMemberActions();
    }
}