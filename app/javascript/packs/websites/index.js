import ScrollReveal from 'scrollreveal'
import Card         from '../components/card/main.vue'
import CreateCard   from '../components/card/create.vue'

export default{
  components: {
    Card, CreateCard
  },
  data: {
    websites: []
  },
  created() {
    window.sr = ScrollReveal({ 
      duration: 1000, 
      mobile: true 
    });
  },
  mounted() {
    this.fetch_websites()
  },
  methods: {
    fetch_websites(){
      this.axios.get('/websites.json')
        .then((response) => {
          this.websites = response.data;
        })
    }
  },
  watch:{
    websites:function(){
      this.$nextTick(() => {
        sr.reveal('.website-card',100);
      })
    }
  }
}