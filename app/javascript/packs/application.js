import                   '../src/application.scss'
import Vue          from 'vue'
import axios        from 'axios'
import VueAxios     from 'vue-axios'
import websiteIndex from './websites/index'

Vue.use(VueAxios, axios);
axios.defaults.headers.common['X-CSRF-Token'] = $('meta[name="csrf-token"]').attr('content')

new Vue({
  el: '#app',
  mixins: [ websiteIndex ]
});