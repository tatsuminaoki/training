/*
 * formのsubmitに対し、data-confirmに記述した内容をバインドする
 */
class Confirm {
  constructor(el) {
    this.message = el.getAttribute('data-confirm')
    if (this.message) {
      el.form.addEventListener('submit', this.confirm.bind(this))
    } else {
      console && console.warn('No value specified in `data-confirm`', el)
    }
  }

  confirm(e) {
    if (!window.confirm(this.message)) {
      e.preventDefault();
    }
  }
}

export default Confirm
