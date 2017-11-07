
<template>
  <Row>
    <Form id="new_website" action="/websites"
          accept-charset="UTF-8"
          method="post"
          class="new_website"
          ref="formValidate"
          :model="formValidate"
          :rules="ruleValidate"
          :label-width="100">
      
      <input name="utf8" type="hidden" value="✓">
      
      <h1 class="card-title">Create</h1>
      
      <Row>
        <FormItem label="Keyword" prop="keyword_url">
          <Input v-model="formValidate.keyword_url" id="keyword_url"/>
        </FormItem>
        
        <FormItem label="URL" prop="url">
          <Input v-model="formValidate.url"/>
        </FormItem>
        
        <FormItem label="Keyword" prop="keyword">
          <Input v-model="formValidate.keyword"/>
        </FormItem>
        
        <Form-item label="Pattern" prop="pattern">
          <Select v-model="formValidate.pattern" placeholder="Select pattern">
            <Option v-for="(value, key) in patternOptions"
                    :value="value"
                    :key="value">{{ key }}
            </Option>
          </Select>
        </Form-item>
        
        <FormItem>
          <Button type="primary" @click="handleSubmit('formValidate')" long>提交</Button>
        </FormItem>
      </Row>
    
    </Form>
    
    <Modal v-model="keywordUrlsModal"
           title="Which one is what episode you current watch?"
           @on-cancel="cancel">
      <ul>
        <li v-for="urlInfo in keywordUrls" @click="chose_keywords">
          <a :href="urlInfo.url" :data-url="urlInfo.url" :data-text="urlInfo.text">
            {{ urlInfo.text }}
          </a>
        </li>
      </ul>
    </Modal>
  </Row>
</template>


<script>
    import { mapActions }   from 'vuex';

    export default {
        props: ['websites'],
        data(){
            return {
                patternOptions: null,
                keywordUrlsModal: false,
                keywordUrls:[],
                formValidate: {
                    url: '',
                    pattern: '',
                    keyword: '',
                    keyword_url: '',
                },
                ruleValidate: {
                    url: [
                        { required: true, message: 'Please enter url', trigger: 'blur' }
                    ],
                    pattern: [
                        { required: true, message: 'Please select a pattern', trigger: 'blur', type:'number' }
                    ],
                    keyword: [
                        { required: true, message: 'Please enter keyword', trigger: 'blur' }
                    ]
                }
            }
        },
        mounted(){
            this.fetchPattern()
        },
        methods: {
            ...mapActions([
                'addWebsite'
            ]),
            fetchPattern () {
                this.axios.get('websites/patterns')
                    .then(({data: { data }}) => this.patternOptions = data)
            },
            cancel () {
                this.$Message.info('点击了取消')
            },
            chose_keywords (e) {
                e.preventDefault()
                this.formValidate.keyword = e.target.dataset.text
                this.formValidate.keyword_url = e.target.dataset.url
                this.handleSubmit('formValidate')
            },
            handleSubmit (name) {
                this.$refs[name].validate((valid) => {
                    if (valid) {
                        this.axios.post(`/websites`, {
                                website: this.formValidate
                            })
                            .then(({data, data: { messages }, data: { type }}) => {
                                if (messages) {
                                    this.$Message.error(messages)
                                }else if (type === 'keyword_urls'){
                                    this.keywordUrlsModal = true
                                    this.keywordUrls = data.data
                                }else if (type === 'not_found'){
                                    this.$Message.error('找不到，請再嘗試其他keyword')
                                }else{
                                    this.addWebsite(data)
                                    this.$Message.success('新增成功')
                                }
                                this.formValidate.keyword_url = null
//                                this.$refs[name].resetFields();
                            })
                            .catch(() => this.$Message.error('新增失敗'));

                        this.keywordUrlsModal = false
                    } else {
                        this.$Message.error('表单验证失败!');
                    }
                })
            }
        }
    }
</script>

<style lang="scss" scoped>
  .ivu-modal{
    li{
      margin: 5px;
      display: inline-block;
    }
  }
</style>