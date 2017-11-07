<template>
  <div>
    <ul class="result_list">
      <li v-for="episode in episodes">
        <a target="_blank"
           :key="episode"
           :href="urls[episode]"
           :data-episode="episode"
           @click="setCurrentEpisode($event, +episode)">
          {{ titles[episode] }}
        </a>
      </li>
    </ul>
    <p v-if="episodes.length == 0"> 已閱讀至最新 </p>
  </div>
</template>

<script>
    export default {
        props: ['website_episodes', 'titles', 'urls'],
        data(){
            return {
                episodes: this.website_episodes.sort((a, b) => a-b)
            }
        },
        methods:{
            setCurrentEpisode(e, episode){
//                e.preventDefault()
                const website_id = $(e.target).parents('.website-card').data('id')

                this.axios.put(`/websites/${website_id}/current_episode`, {
                        episode
                    })
                    .then(({data: {messages}}) => {
                        if (messages) {
                            Materialize.toast(messages, 4000)
                        }else {
                            this.episodes = this.episodes.filter(e => +e >= episode)
                        }
                    })
            }
        }
    }
</script>