class ApplicationController < ActionController::Base
  # Set locale
  before_action :set_locale

  def set_locale
    logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
    I18n.locale = extract_locale_from_accept_language_header
    logger.debug "* Locale set from '#{I18n.default_locale}' to '#{I18n.locale}'"
  end
  def extract_locale_from_accept_language_header
    # request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]\{2\}/).first == 'ja' ? 'ja' : nil
    accept_lang = request.env['HTTP_ACCEPT_LANGUAGE']
    locale = accept_lang ? accept_lang.scan(/^[a-z]{2}/).first : I18n.default_locale
    I18n.available_locales.map(&:to_s).include?(locale) ? locale : I18n.default_locale
  end

end
