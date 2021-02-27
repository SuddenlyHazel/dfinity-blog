<template>
  <div class="card">
    <div class="card-content">
      <div class="block">
        <a href="#" class="title" @click="$emit('click-post')">{{ title }}</a>
      </div>
      <div class="content">
        {{ textSummary }}
        <br />
        <p>{{ new Date(createdAt / 1000 / 1000).toLocaleDateString() }}</p>
      </div>
    </div>
  </div>
</template>

<script>
import canister from "ic:canisters/backend";
import marked from "marked";
import PlainTextRenderer from "marked-plaintext";
const pR = new PlainTextRenderer();

export default {
  components: {},
  props: {
    title: String,
    summary: String,
    createdAt: Number,
    id: Number,
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
    textSummary: function () {
      return marked(this.summary, { renderer: pR });
    },
  },
  watch: {},
  methods: {
    t: function (v) {
      return marked(v);
    },
  },
  async mounted() {
    canister.listPosts().then((v) => {
      this.posts = v;
    });
  },
};
</script>

<style>
@import "~simplemde/dist/simplemde.min.css";
</style>