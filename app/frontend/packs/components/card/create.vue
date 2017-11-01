
<template>
  <Row>
    <span class="card-title">Create</span>
    <Form id="new_website" action="/websites" accept-charset="UTF-8" method="post" class="new_website">
      <input name="utf8" type="hidden" value="✓">
      
      
      <FormItem label="URL">
        <Input type="text" name="website[url]" id="website_url" required/>
      </FormItem>
      
      <FormItem label="Keyword">
        <Input type="text" name="website[keyword]" id="website_keyword" required/>
      </FormItem>
      
      <Form-item label="城市" prop="city">
        <Select v-model="type_selected" placeholder="请选择所在地">
          <Option value="beijing">北京市</Option>
          <Option value="shanghai">上海市</Option>
          <Option value="shenzhen">深圳市</Option>
        </Select>
      </Form-item>
      
      <FormItem>
        <Button type="primary" @click="submit($event)" long>提交</Button>
      </FormItem>
    
    </Form>
  </Row>
</template>


<script>
    export default {
        props: ['websites'],
        data(){
            return {
                type_selected: null,
            }
        },
        methods: {
            submit(event){
                event.preventDefault();
                this.axios.post(`/websites?${$("#new_website").serialize()}`)
                    .then(({data, data: { messages }}) => {

                        if (messages) return this.$Message.error(message)

                        this.websites.unshift(data)
                        this.$Message.success('新增成功')
                    })
                    .catch(() => {
                        this.$Message.error('新增失敗')
                    });
            }
        }
    }
</script>