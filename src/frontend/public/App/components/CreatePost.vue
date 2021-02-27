<template>
  <div>
    <section>
      <div>
        <b-field label="Post Title">
            <b-input v-model="title"></b-input>
        </b-field>
        <vue-simplemde v-model="content" ref="markdownEditor" />
        <b-button @click="createPost">Create Post</b-button>
      </div>
    </section>
  </div>
</template>

<style scoped>
</style>

<script>
import canister from "ic:canisters/backend";
import VueSimplemde from "vue-simplemde";

export default {
  components: {
    VueSimplemde,
  },
  data() {
    return {
      msg: null,
      content: "# Start of something great\n\nWrite your post in markdown!.",
      posts: [],
      title: undefined,
    };
  },
  computed: {
  },
  watch: {},
  methods: {
    createPost: function () {
      canister
        .createPost({
          content: this.content,
          title: this.title,
          // TODO support tags && social images
          tags: [],
          socialImage: [],
        })
        .then((_) => {
          canister.listPosts().then((v) => {
            this.posts = v;
          });
        }).catch(e => console.log(e));
    },
  },
  async mounted() {

  },
};
</script>

<style>
@import "~simplemde/dist/simplemde.min.css";
</style>