<template>
  <Card class="website-card" :data-id="website.id" :key="website.id">
    <div class="card">
      <div class="card-action right-align">
        <a @click="deleteWebsite"><Icon type="ios-trash"></Icon></a>
      </div>
      <div class="card-content">
        <a target="_blank"
           class="card-title"
           :href="website.url">
          {{ website.title }}
        </a>
        <episodes :urls="website.sub_urls"
                  :titles="website.sub_urls_title"
                  :website_episodes="Object.keys(website.sub_urls)">
        </episodes>
        <p>{{ website.crawled_at | fromNow }}</p>
        <p>{{ website.read_at }}</p>
      </div>
    </div>
  </Card>
</template>

<script>
    import timeMixin from '../../mixins/time'
    import episodes  from './episodes.vue'

    export default {
        props: ['website'],
        mixins: [timeMixin],
        components: {episodes},
        methods: {
            deleteWebsite(e){
                const id = $(e.target).parents('.website-card').data('id')
                this.axios.delete(`/websites/${+id}`)
                    .then(() => {
                        this.$parent.websites = this.$parent.websites.filter(o => o.id !== id)
                    })
            }
        }
    }
</script>

<style>
  .result_list li{
    display: inline-block;
    margin: 5px;
  }
  .website-card{
    margin-bottom: 10px;
    visibility: hidden;
  }
</style>