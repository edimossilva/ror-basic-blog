import axios from 'axios';

const HOST = 'http://localhost:3000'

class Api {
  headers(token = '') {
    if (token) {
      return { Authorization: `Basic ${token}` }
    }
    return {};
  }

  simpleDelete(resource, resource_id, token) {
    let url = `${HOST}/${resource}/${resource_id}`

    return this.customInstance(token).delete(url);
  }

  simpleGet(resource, { params = {}, token = "" }) {
    let url = `${HOST}/${resource}`

    return axios.get(url, { params, headers: this.headers(token) });
  }

  nestedGet(mainResource, secondaryResource, id, token) {
    let url = `${HOST}/${mainResource}/${id}/${secondaryResource}`
    return axios.get(url, this.headers(token));
  }

  simplePost(resource, { params = {}, token = "" }) {
    let url = `${HOST}/${resource}`
    return this.customInstance(token).post(url, params);
  }

  customInstance(token) {
    return axios.create({
      headers: this.headers(token)
    });
  }
}

export default new Api();