<template>
  <div class="website-card" :data-id="website.id" :key="website.id">
    <div class="card">
      <div class="card-action right-align">
        <a @click="deleteWebsite">DELETE</a>
      </div>
      <div class="card-content">
        <a target="_blank"
           class="card-title"
           :href="website.url">
          {{ website.title }}
        </a>
        <span class="card-title">{{ website.current_episode }}</span>
        <p>{{ website.crawled_at | fromNow }}</p>
        <p>{{ website.read_at }}</p>
        <div>
          <ul class="result_list">
            <li v-for="result in Object.keys(website.sub_urls_title)">
              <a target="_blank"
                 @click="setCurrentEpisode"
                 :href="website.sub_urls[result]"
                 :data-episode="result">
                {{ website.sub_urls_title[result] }}
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

  export default {
    props: ['website'],
    mixins: [timeMixin],
    methods: {
      deleteWebsite(e){
        const id = $(e.target).parents('.website-card').data('id')
        this.axios.delete(`/websites/${+id}`)
          .then(() => {
            this.$parent.websites = this.$parent.websites.filter(o => o.id !== id)
          })
      },
      setCurrentEpisode(e){
        const id      = $(e.target).parents('.website-card').data('id')
        const episode = +e.target.dataset.episode

        this.axios.put(`/websites/${id}/current_episode`, {
            episode
          })
          .then(({data: {messages}}) => {
            if (messages) {
              Materialize.toast(messages, 4000)
            }else {
              this.website.current_episode = +e.target.innerText
              this.$el.querySelectorAll('.result_list a').forEach(link => {
                if (+link.innerText <= episode) link.parentNode.remove()
              })
            }
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