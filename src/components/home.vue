<template>
<main role="main">
    <section class="jumbotron text-center">
        <div class="container">
            <h3 class="text-muted">Walk Safely with Stepify</h3>
            <br>
            <br>
            <button class="btn btn-outline-primary"><router-link :to="{ path: dashlink()}">Dashboard</router-link></button>
          </div>
      </section>

    
  <hr class="featurette-divider">

    <footer class="container">
        <p class="float-right"><a href="#">Back to top</a></p>
        <p>© 2018 Stepify · <a>
                <router-link :to="{ name: 'privacy'}">Privacy</router-link>
              </a></p>
      </footer>
</main>
</template>
<script>
import firebase from 'firebase'
import firebaseui from 'firebaseui'
import db from '@/firebase/init.js'
export default {
  name: 'home',
  computed: {
    user() {
      return this.$store.state.user
    }
  },
  async mounted() {
    if (this.user) {
      if (this.user.uname == undefined) {
        this.$router.push({
          name: "editprofile"
        })
      } else {
        return
      }
    } else {
      return
    }
  },
  async created() {},
  methods: {
    dashlink: function(){
      return "/dashboard"
    }
  }
}
</script>
