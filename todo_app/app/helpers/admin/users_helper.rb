module Admin
  module UsersHelper
    def role_pull_down
      User.roles.keys.map { |key| [role_value(key), key] }
    end

    def role_value(key)
      User.human_attribute_name("roles.#{key}")
    end
  end
end
