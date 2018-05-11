class User < ApplicationRecord

  PASSWORD_MIN_LENGTH = 4

  validates :login_id, presence: true, uniqueness: true

  has_many :tasks, dependent: :destroy

  def self.check_input_values(login_id, password)
    if !login_id.present?
      return I18n.t('activerecord.attributes.user.login_id') + I18n.t('activerecord.errors.messages.blank')
    elsif !password.present?
      return I18n.t('activerecord.attributes.user.password') + I18n.t('activerecord.errors.messages.blank')
    elsif password.length < PASSWORD_MIN_LENGTH
      return I18n.t('activerecord.attributes.user.password') + I18n.t('activerecord.errors.messages.too_short', count: PASSWORD_MIN_LENGTH)
    end
  end

  def self.password_hash(login_id, password)
    # tekitou salt
    salt = login_id[login_id.length - 1]
    Digest::SHA1.hexdigest(password + salt).to_s
  end
end
