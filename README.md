# BacklogIssuer

backlog課題登録ライブラリ

## Installation

Add this line to your application's Gemfile:

```
mkdir backlog-issuer
cd backlog-issuer
echo "source 'https://rubygems.org'" > Gemfile
echo "gem 'backlog_issuer', :git => 'https://gitlab.clouds-inc.jp/imota/backlog-issuer.git'" >> Gemfile
bundle install --path=./vendor/gems
```

## Usage

```
bundle exec `bundle show backlog_issuer`/bin/backlog-issuer exec --space <spacename> --projectkey <ProjectKey> --apikey <ApiKey> --csvfile <filepath>
```

## CSVフォーマット

```
種別,優先度,カテゴリー,マイルストーン,親課題,件名,詳細,担当者,開始日,期限日
タスク,中,アプリ,RC版,,件名,詳細,担当者ラベル,2016/1/10,2016/1/11
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

