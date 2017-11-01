import                   '../src/application.scss'
import Vue          from 'vue'
import axios        from 'axios'
import VueAxios     from 'vue-axios'
import websiteIndex from './websites/index'
import iView from 'iview';
import 'iview/dist/styles/iview.css';

Vue.use(iView);
Vue.use(VueAxios, axios);

axios.defaults.headers.common['X-CSRF-Token'] = $('meta[name="csrf-token"]').attr('content')

new Vue({
    el: '#app',
    mixins: [ websiteIndex ]
});