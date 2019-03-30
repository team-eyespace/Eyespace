<template>
<div>
  <main class="container">
    <div class="jumbotron">
      <h1 align="center">{{displayname}}</h1>
      <h4 class="section-head">City</h4>
      <p class="content">{{city}}</p>
      <h4 class="section-head">State</h4>
      <p class="content">{{stt}}</p>
      <h4 class="section-head">Country</h4>
      <p class="content">{{country}}</p>
      <h4 class="section-head">Phone Number</h4>
      <p class="content">{{number}}</p>
      <h4 v-if="userCheck" class="section-head">Emergency Contact</h4>
      <p v-if="userCheck" class="content">{{econtact}}</p>
      <h4 v-if="userCheck" class="section-head">Registration Status</h4>
      <div v-if="serial!=undefined && userCheck">
        <p class="content">Device Registered</p>
        <p class="content">
          <button class="btn btn-primary" @click="unreg()">Unregister Device</button>
        </p>
      </div>
      <div v-if="serial==undefined && userCheck">
        <p class="content">Device Not Registered</p>
        <p class="content">
          <router-link :to="{ name: 'registration'}"><button class="btn btn-primary">Register Device</button></router-link>
        </p>
      </div>
      <br>
      <div>
        <router-link to="/editprofile">
          <button v-if="userCheck" class="btn btn-primary btn-lg btn-block col-md-3">Update</button>
        </router-link>
      </div>
    </div>
  </main>
  <hr class="featurette-divider">

  <footer class="container">
    <p class="float-right"><a href="#">Back to top</a></p>
    <p>© 2018 Stepify ·
      <a>
        <router-link :to="{ name: 'privacy'}">Privacy</router-link>
      </a>
    </p>
  </footer>
</div>
</template>

<script>
import firebase from 'firebase'
import db from '@/firebase/init.js'
export default {
  name: 'profile',
  computed: {
    user() {
      return this.$store.state.user
    }
  },
  data() {
    return {
      uname: this.$route.params.uname,
      displayname: null,
      city: null,
      stt: null,
      country: null,
      number: null,
      econtact: null,
      userCheck: null,
      serial: null
    }
  },
  async created() {
    let finduser = await db.collection('users').where("uname", "==", this.uname).get()
    this.city = finduser.docs[0].data().city
    this.stt = finduser.docs[0].data().stt
    this.country = finduser.docs[0].data().country
    this.number = finduser.docs[0].data().number
    this.econtact = finduser.docs[0].data().econtact
    this.displayname = finduser.docs[0].data().displayName
    this.serial = finduser.docs[0].data().serial
    if (this.$route.params.uname == this.user.uname) {
      this.userCheck = true
    } else {
      this.userCheck = false
    }
  },
  methods:{
    async unreg(){
      const ref = db.collection('users').doc(this.user.uid)
      await ref.update({
        serial: null
      })
      location.reload()
    }
  }
}
</script>

<style>
h1 {
  color: #444;
}

.section-head {
  padding-left: 8px
}

.content {
  padding-left: 12px
}
</style>
