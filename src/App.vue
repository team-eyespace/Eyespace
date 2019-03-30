<template>
  <div id="app">
    <navigation/>
    <router-view :key="$route.fullPath"/>
  </div>
</template>

<script>
import navigation from '@/components/navigation.vue'
import store from '@/store/store.js'
export default {
  name: 'App',
  store,
  components: {
    navigation
  },
  data(){
    return{
    }
  }
}
</script>

<style>

</style>
