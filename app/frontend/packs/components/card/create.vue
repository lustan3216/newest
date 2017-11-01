
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
  </Row>
</template>


<script>
    import { mapActions } from 'vuex';
    
    export default {
        props: ['websites'],
        data(){
            return {
                formValidate: {
                    url: '',
                    pattern: '',
                    keyword: '',
                },
                patternOptions: null,
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
            this.fetch_pattern()
        },
        methods: {
            ...mapActions([
                'addWebsite'
                ]),
            fetch_pattern(){
                this.axios.get('websites/patterns')
                    .then(({data: { data }}) => this.patternOptions = data)
            },
            handleSubmit(name){
                this.$refs[name].validate((valid) => {
                    if (valid) {
                        this.axios.post(`/websites`, {
                            website: this.formValidate
                            })
                            .then(({data, data: { messages }}) => {
                                if (messages) {
                                    this.$Message.error(messages)
                                }else{
                                    this.addWebsite(data)
                                    this.$Message.success('新增成功')
                                }
                            })
                            .catch(() => this.$Message.error('新增失敗'));
                        
                    } else {
                        this.$Message.error('表单验证失败!');
                    }
                })
            }
        }
    }
</script>