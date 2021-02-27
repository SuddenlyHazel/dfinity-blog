<template>
  <div class="section">
    <div class="container">
      <div class="block" v-for="post in posts" :key="post.id.toNumber()">
        <post-view
          :title="post.title"
          :summary="post.summary"
          :createdAt="post.time.toNumber()"
          v-on:click-post="selectPost(post.id.toNumber())"
        ></post-view>
      </div>
    </div>
  </div>
</template>

<script>
import canister from "ic:canisters/backend";
import marked from "marked";
import PostView from "./PostView.vue";

export default {
  components: {
    PostView,
  },
  data() {
    return {
      posts: [],
    };
  },
  computed: {
    out: function () {
      return marked(this.content);
    },
  },
  watch: {},
  methods: {
    t: function (v) {
      return marked(v);
    },
    selectPost: function(v) {
      console.log("click", v)
      this.$emit("select-post", v)
    }
  },
  async mounted() {
    canister.listPosts().then((v) => {
      console.log(v);
      this.posts = v;
    });
  },
};
</script>

<style>
@import "~simplemde/dist/simplemde.min.css";
</style>