class User extends Base{

  getlist() {
    this._get(
  }
  _get(uri, params = {}) {
    this._axios.get(uri)
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
