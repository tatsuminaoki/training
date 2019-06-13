# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def password_set_mail(token)
    @token = token
    mail(to: @token.user.email, subject: "【ラクマ】パスワード設定のURLを送信しました。")
  end
end
