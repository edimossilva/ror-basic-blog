import axios from 'axios';
const HOST = 'http://localhost:3000'

class Api {
  simpleDelete(resource, params) {
    let url = `${HOST}/${resource}/${params.id}`
    return axios.delete(url);
  }

  simpleGet(resource, params) {
    let url = `${HOST}/${resource}`
    return axios.get(url, params);
  }

  nestedGet(mainResource, secondaryResource, id) {
    let url = `${HOST}/${mainResource}/${id}/${secondaryResource}`
    return axios.get(url);
  }

  simplePost(resource, params) {
    let url = `${HOST}/${resource}`
    return axios.post(url, params);
  }

  simplePut(resource, params) {
    let url = `${HOST}/${resource}/${params.id}`
    return axios.put(url, params);
  }
}

export default new Api();