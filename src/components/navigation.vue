<template>
  <div class="d-flex flex-column flex-md-row align-items-center p-3 px-md-4 mb-3 bg-white border-bottom shadow-sm">
      <h5 class="my-0 mr-md-auto font-weight-normal"><router-link to="/">Stepify</router-link></h5>
      </a>
      <nav class="my-2 my-md-0 mr-md-3">
        <a class="p-2 text-dark"><router-link to="/">Home</router-link><span class="sr-only">(current)</span></a>
        <a v-if="user" class="p-2 text-dark"><router-link :to="{ path: profilelink()}">Profile</router-link></a>
        <a v-if="user" class="p-2 text-dark"><router-link :to="{ path: dashlink()}">Dashboard</router-link></a>
      </nav>
      <a v-if="user" class="nav-link btn btn-outline" @click="signOut()">Logout</a>
      <a v-else class="nav-link btn btn-outline" @click="login()">Login</a>
    </div>
</template>

<script>
import firebase from 'firebase'
import db from '@/firebase/init.js'
export default {
  name: 'navigation',
  computed:{
    user () {
      return this.$store.state.user
    }
  },
  methods: {
    async signOut () {
      await this.$store.dispatch('logOut')
      this.$router.push('/')
    },
    profilelink: function(){
      return "/profile/"+ this.user.uname
    },
    dashlink: function(){
      return "/dashboard"
    },
    async login() {
      this.$router.push('/login')
    }
  },
  data () {
    return {
    }
  }
}
</script>
