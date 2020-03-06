
import api from './api';

const LOGIN_RESOURCE = 'auth/login';

export default {
  doLogin(username, password) {
    return api.simplePost(LOGIN_RESOURCE, { username, password });
  },
}