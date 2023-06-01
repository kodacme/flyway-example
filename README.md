# Flyway説明会用リポジトリ

Flywayについてちょっとした説明をすることになったため、その説明用のリポジトリ。やさしめ説明。

## ## Flywayとは
![flyway-logo](https://commons.wikimedia.org/wiki/File:Flyway-logo-tm.png)

Flywayは「データベースのバージョン管理ツール」の1つです。  
マイグレーションをバージョン管理することで、どのスクリプトを適用したかを把握できます(DBの状態を把握できる)。  
Aテーブルにカラム追加、Bテーブルのカラム名変更、CテーブルをCCテーブルにリネーム...こういった変更を行っていると、
現在使用しているDBがどの状態なのか把握することが困難になってくることは想像に難くないと思います。複数人で開発、複数環境あれば尚更です。

## ## Springで使用する
即使用するための重要ポイントは以下になります。  ※Spring Boot(以下Spring)で使用する際の導入方法は後述します。  
- 実行されるタイミング  
  Springで使用すると起動時にマイグレーションが自動で走ります。
- 配置場所  
  デフォルトで、`resources/db/migration/`にマイグレーションファイルを配置するようになっているため、そちらにファイルを配置しておきましょう。
- ファイルの命名(RepeatableではR__、UndoではU__がありますが必要になったらでOK)  
  `V{バージョン}__{任意の名前}.sql`
  - ポイント💡  
    先頭大文字のV, バージョンと任意の名前(description)のセパレーターはアンダースコア2つ

### 【疑問】flywayはどうやってバージョン情報を保持するのか？
専用のテーブルに保持しています。デフォルトではflyway_schema_historyというテーブルにマイグレーション情報を保持するようになっています。

## ## 試しに使ってみる
プロジェクトのルートディレクトリで
```shell
$ docker compose up -d

$ ./gradlew bootRun
```

```
host: localhost
port: 5454
db: dev_db
username: postgres
password: postgres
```
上記接続情報で確認すると、flyway_schema_historyとfruitsテーブルが作成されていると思います。

## ## ローカル開発中にたまに遭遇するエラーと解決方法

- Migration checksum mismatch for migration version ~
```
org.springframework.beans.factory.BeanCreationException: Error creating bean with name 'flywayInitializer' defined in class path resource [org/springframework/boot/autoconfigure/flyway/FlywayAutoConfiguration$FlywayConfiguration.class]: Invocation of init method failed; nested exception is org.flywaydb.core.api.exception.FlywayValidateException: Validate failed: Migrations have failed validation
Migration checksum mismatch for migration version 1.00
-> Applied to database : -1479006882
-> Resolved locally    : -636131231
Either revert the changes to the migration, or run repair to update the schema history.
```
マイグレーションファイルのchecksumが異なっているという旨のメッセージ。 既に当たっているバージョンのファイル内容を変更すると発生する。
この例で言うと、DBに適用されているchecksumが`-1479006882`で、適用しようとしたファイルのchecksumが`-636131231`。
適用しようとしたファイルの内容を「正」にしたいとして、  
1. もし直に変更したりしてその変更内容が既にDBに適用されている場合は、flyway_schema_historyテーブルの対象レコード.checksumカラムの`-1479006882`を`-636131231`に更新する。  
2. もし適用しようしたファイルの内容を実行して欲しい場合は、flyway_schema_historyテーブルの対象レコードを削除する。  
   ただし、変更前に適用されたファイルの実行内容が戻るわけではないので、注意。

- OutOfOrder
時間あれば書く

## ## Springに導入する
時間あれば書く

## ## 
