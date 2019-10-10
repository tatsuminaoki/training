# 起動の仕方

### 一個目のterminalで
- bundle install
- bundle exec rails s

### もう一個のterminalで
- bin/webpack-dev-server

### browserで
- localhost:3000/ にアクセス

# seedを入れましょう
- `bundle exec rake db:migrate` 後に
- `bundle exec rake db:seed` をすると、development環境内でテスト出来るデータがシードされます

### seedsを入れ直したい時
- `bundle exec rake db:seed:replant` を実行すれば、DBをtruncateして、再度seedしてくれます。