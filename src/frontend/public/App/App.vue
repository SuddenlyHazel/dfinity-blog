<template>
  <div class="columns m-1">
    <div class="column is-2 has-text-centered">
      <div class="container pt-5">
        <figure
          v-if="!!meta.image && meta.image.length > 0"
          class="image container is-128x128 mb-3"
        >
          <b-image :src="meta.image[0]" rounded></b-image>
        </figure>
        <div class="block">
          <h1 class="title">{{ meta.name }}</h1>
          <h2 v-if="meta.summary.length > 0" class="subtitle">
            {{ meta.summary[0] }}
          </h2>
        </div>
        <div class="block">
          <b-field>
            <b-tag v-for="tag in meta.tags" :key="tag">{{ tag }} </b-tag>
          </b-field>
        </div>
        <div>
          <b-menu v-if="!!meta">
            <b-menu-list label="Menu">
              <b-menu-item
                v-for="itm in meta.links"
                :key="itm.id.toNumber()"
                :label="itm.text"
              ></b-menu-item>
              <b-menu-item
                v-if="isOwner"
                label="New Post"
                @click="createPost = true"
              ></b-menu-item>
            </b-menu-list>
          </b-menu>
        </div>
      </div>
    </div>
    <div class="column is-10">
      <posts-list v-on:select-post="selectPost($event)"></posts-list>
    </div>
    <b-modal v-model="showPost" has-modal-card full-screen :can-cancel="false">
      <div class="modal-card">
        <section class="modal-card-body">
          <div class="columns is-centered">
            <div class="column is-11">
              <post :postId="selectedPostId"></post>
            </div>
          </div>
        </section>
        <footer class="modal-card-foot">
          <b-button label="Close" @click="selectedPostId = null" />
        </footer>
      </div>
    </b-modal>
    <b-modal
      v-model="createPost"
      has-modal-card
      full-screen
      :can-cancel="false"
    >
      <div class="modal-card">
        <header class="modal-card-head">
          <p class="modal-card-title">Create Post</p>
        </header>
        <section class="modal-card-body">
          <create-post></create-post>
        </section>
        <footer class="modal-card-foot">
          <b-button label="Discard" @click="createPost = false" />
        </footer>
      </div>
    </b-modal>
  </div>
</template>
<style scoped>
</style>

<script>
import CreatePost from "./components/CreatePost.vue";
import Post from "./components/Post.vue";
import PostsList from "./components/PostsList.vue";
import canister from "ic:canisters/backend";

export default {
  components: { CreatePost, PostsList, Post },
  data() {
    return {
      selectedPostId: null,
      open: true,
      meta: undefined,
      createPost: false,
      isOwner: false,
    };
  },
  computed: {
    showPost: function () {
      return !!this.selectedPostId;
    },
  },
  methods: {
    selectPost: function (v) {
      console.log("Post id is ", v);
      this.selectedPostId = v;
    },
  },
  async mounted() {
    canister.getBlogMeta().then((v) => {
      document.title = v.name;
      this.meta = v;
    });

    this.$getActions.isOwner().then((v) => {
      this.isOwner = v;
    });

    this.$getActions.whoAmI().then((v) => {
      console.log("Caller is", v);
    });
  },
};
</script>
