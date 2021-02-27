import canister from "ic:canisters/backend";
import Vue from "vue";


const store = Vue.observable({
    hello: null,
});

const getActions = {
    isOwner() {
        return new Promise((resolve, err) => {
            canister.isOwner().then(v => resolve(v)).catch(e => err(e));
        })
    },
    whoAmI() {
        return new Promise((resolve, err) => {
            canister.whoAmI().then(v => resolve(v)).catch(e => err(e));
        })
    }
}

const createActions = {
    
}

Vue.prototype.$store = store
Vue.prototype.$getActions = getActions
Vue.prototype.$createActions = createActions