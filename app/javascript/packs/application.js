import Vue    from 'vue'
import websiteIndex from './websites/index'

new Vue({
  el: '#app',
  mixins: [ websiteIndex ]
});