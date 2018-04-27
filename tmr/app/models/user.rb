class User < ApplicationRecord
  validates :login_id, presence: true, uniqueness: true

  has_many :tasks

  def self.password_hash(login_id, password)
    # tekitou salt
    salt = login_id[login_id.length - 1]
    Digest::SHA1.hexdigest(password + salt).to_s
  end
end
