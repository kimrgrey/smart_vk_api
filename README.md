# SmartVkApi

[![Gem Version](https://badge.fury.io/rb/smart_vk_api.svg)](http://badge.fury.io/rb/smart_vk_api)
[![Build Status](https://travis-ci.org/kimrgrey/smart_vk_api.svg)](https://travis-ci.org/kimrgrey/smart_vk_api)
[![Code Climate](https://codeclimate.com/github/kimrgrey/smart_vk_api/badges/gpa.svg)](https://codeclimate.com/github/kimrgrey/smart_vk_api)

A lightweight and flexible library that wraps Vkontakte API and allow you to use it in very easy and comfortable way. And, as a bonus, mo additional dependencies :wink:

## Что еще один?

Да, в некотором роде. Но не совсем. 

1. Почти все гемы для работы с VK API, которые можно [найти на rubygems.org](https://rubygems.org/search?utf8=%E2%9C%93&query=vkontakte), давно не обновлялись. 
2. Один из самых [приятно реализованных](https://github.com/7even/vkontakte_api) и более или менее актуальных тянет за собой [количество зависимостей](https://github.com/7even/vkontakte_api/blob/master/vkontakte_api.gemspec#L21-L39), которое ставит в тупик.

Поэтому при разработке этого гема используются три простых принципа:

1. Он должен быть максимально удобным в использовании;
2. Он должен быть настолько "тонким" по отношению к API, насколько это вообще возможно сделать, не жертвуя первым пунктом;
3. Он должен тянуть за собой только **необходимый минимум** зависимостей, в идеале - **ни одной**;

## Как установить?

Добавьте в Gemfile вашего приложения:

```ruby
gem 'smart_vk_api'
```

После чего запустите:

```
$ bundle install
```

Или просто установите гем вручную:

```
$ gem install smart_vk_api
```

## Прямое использование API

В простейшем случае можно вызвать произвольный метод VK API и передать ему параметры следующим образом:

```ruby
SmartVkApi.call('users.get', :user_ids => 'kimrgrey') # [{:uid=>3710412, ...}]
```

Для вызова нескольких методов разумно создать враппер один раз и использовать его повторно:

```ruby
vk = SmartVkApi.vk
vk.call('users.get', :user_ids => 'kimrgrey') # [{:uid=>3710412, ...}]
vk.call('photos.get', :owner_id => '3710412', :album_id => 'wall')
```

По умолчанию, `access_token` не передается, так что для вызова доступны только публичные методы. При попытке вызвать метод, требующий наличие токена, возникнет исключение `SmartVkApi::MethodCallError`. Например:

```ruby
SmartVkApi.call('wall.get', :owner_id => '3710412') # SmartVkApi::MethodCallError: {"error":{..., "error_msg":"Access denied: user hid his wall from accessing from outside"}}
```

Чтобы вызвать приватные методы, можно задать глобальный конфиг, токен из которого будет использоваться по умолчанию, если он задан:

```ruby
SmartVkApi.configure do |config|
  config.access_token = ACCESS_TOKEN
end
```

Если при этом передать другой `access_token` в качестве параметра для метода `call`, ему будет отдано предпочтение:

```ruby
SmartVkApi.call('users.get', :user_ids => 'kimrgrey', :access_token => ANOTHER_ACCESS_TOKEN)
```

## Проксирующий объект

Вместо прямых обращений к API через передачу имени метода в качестве параметра для `call` можно использовать более удобный вариант, позволяющий вызывать методы VK API как собственные методы враппера. Пример:

```ruby
vk = SmartVkApi.vk
vk.users.get(:user_ids => 'kimrgrey')
```

Токен доступа, как и для прямых вызовов, можно задать в конфиге или передать в качестве параметра метода.

```ruby
vk = SmartVkApi.vk
vk.users.get(:user_ids => 'kimrgrey', :access_token => ACCESS_TOKEN)
```

В VK API принят стиль camelCase, в Ruby же используются подчеркивания. Например, вызвать метод `users.isAppUser` можно следующим образом:

```ruby
vk = SmartVkApi.vk
vk.is_app_user(:user_id => '3710412')  
```

## Как помочь в разработке?

Все как обычно:

1. Сделайте форк (https://github.com/kimrgrey/smart_vk_api/fork)
2. Добавьте ветку (`git checkout -b my-new-feature`)
3. Сделайте коммит (`git commit -am 'Add some feature'`)
4. Сделайте пуш (`git push origin my-new-feature`)
5. Пришлите pull request
