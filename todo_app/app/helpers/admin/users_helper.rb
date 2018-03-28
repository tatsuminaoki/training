module Admin
  module UsersHelper
    def role_pull_down
      User.roles.keys.map { |key| [role_value(key), key] }
    end

    def role_value(key)
      User.human_attribute_name("roles.#{key}")
    end

    def role_badge(key)
      case key
      when User.roles.keys[0]
        'badge-info'
      when User.roles.keys[1]
        'badge-warning'
      end
    end
  end
end
