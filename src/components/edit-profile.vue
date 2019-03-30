<template>
<main>
  <div class="container">
    <div class="jumbotron">
      <h4 class="mb-3">User Profile</h4>
      <h6 class="mb-3">All Text Fields are Required</h6>
      <form>
        <div class="row">
          <div class="col-md-auto mb-3">
            <label for="username">Username</label>
            <div class="input-group">
              <div class="input-group-prepend">
                <span class="input-group-text">@</span>
              </div>
              <input type="text" class="form-control" id="username" onpaste="return false" v-model="uname" @input="checkAvailability()">
              <div class="availability">
                <i v-if="unameempty" class="material-icons red">close</i>
                <i v-else-if="available" class="material-icons green">check</i>
                <i v-else-if="unavailable" class="material-icons red">close</i>
              </div>
            </div>
            <p v-if="unameempty" class="red availability">Enter a Username</p>
            <p v-else-if="available" class="green availability">Username available!</p>
            <p v-else-if="unavailable" class="red availability">Username unavailable!</p>
          </div>
        </div>
        <div class="row">
          <div class="col-md-4 mb-3">
            <label for="city">City</label>
            <input type="text" class="form-control" id="city" v-model="city">
          </div>
          <div class="col-md-4 mb-3">
            <label for="state">State</label>
            <input type="text" class="form-control" id="state" v-model="stt">
          </div>
          <div class="col-md-4 mb-3">
            <label for="country">Country</label>
            <input type="text" class="form-control" id="country" v-model="country">
          </div>
        </div>
        <div class="row">
          <div class="col-md-4 mb-3">
            <label for="number">Phone Number</label>
            <input type="text" class="form-control" id="number" v-model="number">
          </div>
          <div class="col-md-4 mb-3">
            <label for="econtact">Emergency Contact</label>
            <input type="text" class="form-control" id="econtact" v-model="econtact">
          </div>
        </div>
        <hr class="mb-4">
      </form>
      <button :disabled="unavailable||unameempty" class="btn btn-primary btn-lg btn-block col-md-3" type="submit" @click="updateProfile()&&checkAvailability()">Update</button>
      <p v-if="fieldempty" class="red availability">Please fill in all data!</p>
    </div>
  </div>
  <hr class="featurette-divider">

  <footer class="container">
    <p class="float-right"><a href="#">Back to top</a></p>
    <p>© 2018 Stepify ·
      <a>
        <router-link :to="{ name: 'privacy'}">Privacy</router-link>
      </a>
    </p>
  </footer>
</main>
</template>

<script>
import firebase from 'firebase'
import db from '@/firebase/init.js'
export default {
  name: 'editprofile',
  computed: {
    user() {
      return this.$store.state.user
    }
  },
  methods: {
    async updateProfile() {
      if (this.city == undefined || this.stt == undefined || this.country == undefined || this.number == undefined || this.econtact == undefined) {
        this.fieldempty = true
        return
      } else {
        const ref = db.collection('users').doc(this.user.uid)
        await ref.update({
          city: this.city,
          stt: this.stt,
          country: this.country,
          number: this.number,
          econtact: this.econtact,
          uname: this.uname
        })
        this.$router.push({
          name: "profile",
          params: {
            uname: this.uname
          }
        })
      }
    },
    async checkAvailability() {
      if (this.uname == undefined) {
        this.unameempty = true
      } else {
        let checkname = await db.collection('users').where("uname", "==", this.uname).get()
        if (this.uname == null || this.uname == "") {
          this.unameempty = true
        } else if (checkname.empty || checkname.docs[0].data().uname == this.user.uname) {
          this.available = true
          this.unameempty = false
          this.unavailable = false
        } else {
          this.available = false
          this.unameempty = false
          this.unavailable = true
        }
      }
    }
  },
  data() {
    return {
      city: null,
      stt: null,
      country: null,
      number: null,
      econtact: null,
      uname: null,
      available: null,
      unavailable: null,
      unameempty: null,
      fieldempty: null
    }
  },
  mounted: function() {
    this.checkAvailability()
  },
  async created() {
    this.city = this.user.city
    this.stt = this.user.stt
    this.country = this.user.country
    this.number = this.user.number
    this.econtact = this.user.econtact
    this.uname = this.user.uname
  }
}
</script>

<style>
.round {
  border-radius: 50%;
  overflow: hidden;
  width: 150px;
  height: 150px;
}

.round img {
  display: block;
  /* Stretch
      height: 100%;
      width: 100%; */
  min-width: 100%;
  min-height: 100%;
}

.uploader {
  position: relative;
  overflow: hidden;
  width: 100%;
  height: 300px;
  background: #f3f3f3;
  border: 2px;
}

#filePhoto {
  position: absolute;
  width: 100%;
  height: 100%;
  opacity: 0;
  cursor: pointer;
}

.container {
  padding-top: 40px;
  padding-bottom: 40px;
}

.material-icons.green {
  color: green;
}

.material-icons.red {
  color: red;
}

.availability {
  padding-top: 6px;
  padding-left: 3px;
}

.green {
  color: green;
}

.red {
  color: red;
}
</style>
