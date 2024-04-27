# Ростелеком M2M
[![Gem Version](https://badge.fury.io/rb/rostelecom_m2m.svg)](https://badge.fury.io/rb/rostelecom_m2m)

Библиотека для взаимодействия с Ростелеком M2M.\
[Официальный сайт](https://m2m.ru/)  

## Установка

Добавьте в ваш Gemfile:

`gem "rostelecom_m2m"`

И выполните команду:

`bundle install`

Или установите с помощью команды:

`gem install rostelecom_m2m`

## Использование

```ruby
# Авторизация и получение токена.
auth_data = {
  username: "M2M_user",
  password: "pass1234",
  auth_token: "",
  debug: true
}
client = RostelecomM2M.new(auth_data)
response = client.post("/tokens-stub-m2m/get", auth_data)
auth_token = response.dig(:message, "authToken")

# Сохранение токена для последующих запросов.
client.auth_token = auth_token

# Получение списка сим-карт.
sim_cards = client.post("/M2M/SIMCards/search", authToken: client.auth_token).dig(:message)
```
