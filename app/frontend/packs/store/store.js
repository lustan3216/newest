import Vue from 'vue';
import Vuex from 'vuex';
import websites from './modules/websites';

Vue.use(Vuex);

export default new Vuex.Store({
  modules:{
      websites
  }
})