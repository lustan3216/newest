<template>
  <div class="row">
    <span class="card-title">Create</span>
    <form id="new_website" action="/websites" accept-charset="UTF-8" method="post" class="new_website">
      <input name="utf8" type="hidden" value="✓">
      <slot></slot>
      
      <div class="input-field col s7">
        <label for="website_url">Url</label>
        <input type="text" name="website[url]" id="website_url" required>
      </div>
      
      <div class="input-field col s3">
        <label for="website_keyword">Keyword</label>
        <input type="text" name="website[keyword]" id="website_keyword" required>
      </div>
      
      <div class="input-field col s2">
        <i class="waves-effect waves-light btn waves-input-wrapper">
          <input type="submit" name="commit" value="submit" data-disable-with="submit" class="waves-button-input" @click="submit($event)">
        </i>
      </div>
    
    </form>
  </div>
</template>


<script>
  export default {
    props: ['websites'],
    methods: {
      submit(event){
        event.preventDefault();
        this.axios.post(`/websites?${$("#new_website").serialize()}`)
          .then(({data, data: { messages }}) => {
          
            if (messages) return Materialize.toast(messages, 4000);
            
            this.websites.unshift(data);
            Materialize.toast('新增成功', 4000)
          })
          .catch(() => {
            Materialize.toast('新增失敗', 4000)
          });
      }
    }
  }
</script>