<template>
<main class="content">
  <div class="container">
    <div class="jumbotron text-center">
      <qrcode-stream :paused="paused" @decode="onDecode">
        <div v-show="paused" class="validation-layer">
          <div class="validation-notice">
            <div v-if="validating">
              Validation in progress...
            </div>

            <div v-else-if="isValid" class="valid">
              Registration Successful
            </div>

            <div v-else class="invalid">
              Registration Unsuccessful/Device Already Registered
            </div>
          </div>
        </div>
      </qrcode-stream>
    </div>
  </div>

  <hr class="featurette-divider">

  <footer class="container">
    <p class="float-right"><a href="#">Back to top</a></p>
    <p>© 2018 Stepify</p>
  </footer>
</main>
</template>

<script>
import firebase from 'firebase'
import db from '@/firebase/init.js'
export default {
  name: 'app',
  computed: {
    user() {
      return this.$store.state.user
    }
  },
  data() {
    return {
      isValid: false,
      validating: false,
      paused: false,
      serial: null
    }
  },
  methods: {
    async onDecode(decodedString) {
      this.serial = decodedString
      this.pauseCamera()
      this.validating = true
      this.validate(decodedString)
    },

    pauseCamera() {
      this.paused = true
    },

    unPauseCamera() {
      this.paused = false
    },

    async validate(content) {
      const ref = db.collection('users').doc(this.user.uid)
      let checkname = await db.collection('users').where("serial", "==", this.serial).get()
      window.setTimeout(() => {
        if (content.length == 16 && checkname.empty) {
          this.validating = false
          this.isValid = true
          ref.update({
            serial: this.serial
          })
          window.setTimeout(() => {
            this.$router.push({
              name: "profile",
              params: {
                uname: this.user.uname
              }
            })
          }, 2000)
        } else {
          this.validating = false
          this.isValid = false
          window.setTimeout(() => {
            this.unPauseCamera()
          }, 2000)
        }
      }, 3000)
    }
  },
  async mounted() {
    if (this.user.serial) {
        this.$router.push({
          name: "home"
        })
      } else {
        return
      }
  },
}
</script>

<style>
.content {
  padding-top: 10px
}
.validation-layer {
  position: absolute;
  width: 100%;
  height: 100%;

  background-color: rgba(255, 255, 255, .8);
  text-align: center;
  padding: 10px;

  display: flex;
  flex-flow: column nowrap;
  justify-content: center;
}

.validation-notice {
  font-weight: bold;
  font-size: 1.4rem;
}

.valid {
  color: green;
}
.invalid {
  color: red;
}</style>
