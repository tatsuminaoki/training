class Base {
  _axios = require('axios');

  _get(uri, params = {}) {
    axios.get(uri)
    .then(response => {
      return response;
    });
  }

  _post(uri, params = {}) {
    axios.post(uri, params)
    .then(response => {
      return response;
    });
  }
}
