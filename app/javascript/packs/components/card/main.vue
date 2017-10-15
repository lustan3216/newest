<template>
  <div class="col s12 m4 website-card" :data-id="website.id" :key="website.id">
    <div class="card indigo lighten-5">
      <div class="card-action right-align">
        <a @click="deleteWebsite">DELETE</a>
      </div>
      <div class="card-content">
        <a target="_blank"
           class="card-title"
           :href="website.url">
          {{ website.title }}
        </a>
        <span class="card-title">{{ website.keyword }}</span>
        <p>{{ website.crawled_at | fromNow }}</p>
        <p>{{ website.read_at }}</p>
        <div>
          <ul class="result_list">
            <li v-for="result in website.sorted_result">
              <a target="_blank"
                 :href="Object.values(result)[0]"
                 @click="setCurrentEpisode($event)"
                 :data-id="Object.keys(result)[0]">
                {{ Object.keys(result)[0] }}
              </a>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import timeMixin from '../../mixins/time'
  import _         from 'lodash'
  
  export default {
    props: ['website'],
    mixins: [timeMixin],
    methods: {
      deleteWebsite(e){
        const id = $(e.target).parents('.website-card').data('id')
        
        this.axios.delete(`/websites/${+id}`)
          .then(() => {
          
            this.$parent.fetch_websites()
            Materialize.toast('刪除成功', 4000)
          })
      },
      setCurrentEpisode(event){
        event.preventDefault()
        const episode = event.target.dataset.id
        const id      = $(event.target).parents('.website-card').data('id')
        
        this.axios.put(`/websites/${id}/current_episode`, {
            episode
          })
          .then(({data: {messages}}) => {
            if (messages) return Materialize.toast(messages, 4000)

            this.$parent.fetch_websites()
            Materialize.toast('新增成功', 4000)
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
</style>