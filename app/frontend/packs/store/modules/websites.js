import Vue          from 'vue'

const state = {
    websites: []
}

const actions = {
    initWebsites ({commit}){
        Vue.axios.get('/websites.json')
            .then((response) => {
                commit('INIT_WEBSITES', response.data);
            })
    },
    addWebsite ({commit}, webiste){
        commit('ADD_WEBSITE', webiste);
    },
    deleteWebsite ({commit}, website){
        commit('DELETE_WEBSITE', website);
    },
}

const mutations = {
    'INIT_WEBSITES' (state, websites){
        state.websites = websites;
    },
    'ADD_WEBSITE' (state, website){
        state.websites.unshift(website);
    },
    'DELETE_WEBSITE' (state, website){
        state.websites = state.websites.filter(o => o.id !== +website.dataset.id)
    }
}

const getters = {
    websites: state => {
        return state.websites
    }
}

export default {
    state,mutations,actions,getters
}