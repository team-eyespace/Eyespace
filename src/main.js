// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import store from './store/store.js'
import firebase from 'firebase'
import VueQrcodeReader from 'vue-qrcode-reader'

Vue.use(VueQrcodeReader)

Vue.config.productionTip = false

/* eslint-disable no-new */
var app = null
firebase.auth().onAuthStateChanged(async () => {
  if (!app) {
    await store.dispatch('setUser')
    new Vue({
      el: '#app',
      router,
      components: { App },
      template: '<App/>'
    })
  }
})
