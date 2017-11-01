import ScrollReveal   from 'scrollreveal'
import Card           from '../components/card/body.vue'
import CreateCard     from '../components/card/create.vue'
import { mapActions, mapGetters } from 'vuex';
//
export default{
    components: {
        Card, CreateCard
    },
    created() {
        this.initWebsites()
    },
    mounted(){
        window.sr = ScrollReveal({
            opacity: 0,
            reset: true,
            container: '#websites',
            duration: 2000,
            scale: 0.9,
            easing: 'cubic-bezier(0.6, 0.2, 0.1, 1)',
        });
    },
    computed: {
        ...mapGetters(['websites'])
    },
    methods: {
        ...mapActions([
            'initWebsites'
        ])
    },
    watch:{
        websites(){
            this.$nextTick(function(){
                sr.reveal('.website-card', 100)
            })
        }
    }
}