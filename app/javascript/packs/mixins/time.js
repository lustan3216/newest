import moment      from 'moment/min/moment-with-locales';

export default {
  filters:{
    fromNow(datetime){
      return moment(datetime).fromNow();
    }
  }
}