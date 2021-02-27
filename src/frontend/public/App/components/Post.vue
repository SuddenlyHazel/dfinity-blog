<template>
  <div v-if="!!post">
    <section>
      <section class="has-text-centered mb-4">
        <div class="container">
          <p class="title">{{ post.title }}</p>
        </div>
      </section>
      <section>
        <div class="container">
          <div class="content" v-html="out"></div>
        </div>
      </section>
    </section>
  </div>
</template>

<style scoped>
</style>

<script>
import canister from "ic:canisters/backend";
import marked from "marked";

export default {
  props: {
    postId: Number,
  },
  components: {},
  data() {
    return {
      content: "",
      post: null,
    };
  },
  computed: {
    out: function () {
      if (!this.post) {
        return;
      }
      return marked(this.post.content);
    },
  },
  watch: {},
  methods: {},
  async mounted() {
    canister.getPost(this.postId).then((v) => {
      console.log(v);
      this.post = v[0];
    });
  },
};
</script>

<style>
@import "~simplemde/dist/simplemde.min.css";
</style>