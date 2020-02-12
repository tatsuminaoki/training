class LogicUser
  def self.create(name, email, password, authority)
    begin
      ApplicationRecord.transaction do
        user = User.create(name: name, authority: authority)
        login = Login.create(user_id: user.id, email: email, password: password)
        user.save!
        login.save!
        user.id
      end
    rescue => e
      Rails.logger.error(e)
      false
    end
  end

  def self.update(user_id, name, email, password, authority)
    begin
      ApplicationRecord.transaction do
        user = User.find(user_id)
        user.name = name
        user.authority = authority

        user.login.email = email
        user.login.password = password

        user.login.save!
        user.save!
      end
    rescue => e
      Rails.logger.error(e)
      false
    end
  end

  def self.authenticate(session, email, password)
    result = false
    errors = []
    login = Login.find_by(email: email)
    if login.blank?
      errors.push("email")
    else
      if login.authenticate(password)
        user = User.find(login.user_id)
        session[:me] = {
          user_id: user.id,
          name: user.name
        }
        result = true
      else
        errors.push("password")
      end
    end
    {
      "result" => result,
      "errors" => errors,
    }
  end
end
