# SmartVkApi

[![Gem Version](https://badge.fury.io/rb/smart_vk_api.svg)](http://badge.fury.io/rb/smart_vk_api)
[![Build Status](https://travis-ci.org/kimrgrey/smart_vk_api.svg)](https://travis-ci.org/kimrgrey/smart_vk_api)
[![Code Climate](https://codeclimate.com/github/kimrgrey/smart_vk_api/badges/gpa.svg)](https://codeclimate.com/github/kimrgrey/smart_vk_api)

Библиотека, обеспечивающая по-настоящему удобный и простой интерфейс для работы с API социальной сети "Вконтакте".

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

## Как помочь в разработке?

Все как обычно:

1. Сделайте форк (https://github.com/kimrgrey/smart_vk_api/fork)
2. Добавьте ветку (`git checkout -b my-new-feature`)
3. Сделайте коммит (`git commit -am 'Add some feature'`)
4. Сделайте пуш (`git push origin my-new-feature`)
5. Пришлите pull request
