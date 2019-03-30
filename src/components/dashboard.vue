<template>
<main role="main">
  <div class="container">
    <div class="row">
      <div class="col-sm">
        <div class="jumbotron text-center">
          <p class="text-muted">Wd1</p>
          {{wd1}}
        </div>
      </div>
      <div class="col-sm">
        <div class="jumbotron text-center">
          <p class="text-muted">Wd2</p>
          {{wd2}}
        </div>
      </div>
      <div class="col-sm">
        <div class="jumbotron text-center">
          <p class="text-muted">Wd3</p>
          {{wd3}}
        </div>
      </div>
    </div>
    <br>
    <div v-if="collide">
      <div class="jumbotron text-center">
        <h3>Collision Imminent!</h3>
      </div>
    </div>
  </div>

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
  name: 'dashboard',
  computed: {
    user() {
      return this.$store.state.user
    }
  },
  data() {
    return {
      camin: null,
      collin: null,
      collide: null,
      wd1: null,
      wd2: null,
      wd3: null,
      split: null,
      econtact: null
    }
  },
  methods: {
    async updateData(){
      let ref = await db.collection('users').doc(this.user.uid).get()
      this.camin = ref.data().cameraout
      this.collin = ref.data().usonic
      if (this.collin == "collision!"){
          this.collide = true
      }
      else {
        this.collide = false
      }
      this.split = this.camin.split("'");
      this.wd1 = this.split[0]
      this.wd2 = this.split[1]
      this.wd3 = this.split[2]
      setTimeout(() => {
            this.updateData()
      }, 2000)
    }
  },
  mounted() {
    this.updateData()
    this.econtact = this.user.econtact
  }
}
</script>
