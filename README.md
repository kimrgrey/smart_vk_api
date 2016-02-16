# SmartVkApi

[![Gem Version](https://badge.fury.io/rb/smart_vk_api.svg)](http://badge.fury.io/rb/smart_vk_api)
[![Build Status](https://travis-ci.org/kimrgrey/smart_vk_api.svg)](https://travis-ci.org/kimrgrey/smart_vk_api)
[![Code Climate](https://codeclimate.com/github/kimrgrey/smart_vk_api/badges/gpa.svg)](https://codeclimate.com/github/kimrgrey/smart_vk_api)

A lightweight and flexible library that wraps Vkontakte API and allow you to use it in very easy and comfortable way. And, as a bonus, mo additional dependencies :wink:

## Just another one?

Yep. But there are some details. 

1. Almost all of gems for VK API on [rubygems.org](https://rubygems.org/search?utf8=%E2%9C%93&query=vkontakte) has not been updated since ancient times. 
2. One of [the best variants](https://github.com/7even/vkontakte_api) has [so many dependencies](https://github.com/7even/vkontakte_api/blob/master/vkontakte_api.gemspec#L21-L39) without any clear reason for it.

So, that way I have decided to follow some very simple rules in delopment of this gem:

1. It should be very easy to use;
2. It should be as thin as it possible, but good enough to not break the first rule;
3. It should has only reasonable dependencies, but in the best case it shoudld has no dependencies at all;

## How to install?

Just add those line to the Gemfile of your application:

```ruby
gem 'smart_vk_api'
```

And run:

```
$ bundle install
```

Or install gem directly from rubygems.org:

```
$ gem install smart_vk_api
```

## How to use API directly?

In simplest case you can call any method of the VK API and pass any parameters like this:

```ruby
SmartVkApi.call('users.get', :user_ids => 'kimrgrey') # [{:uid=>3710412, ...}]
```

But if you want to perform multiple calls it's good idea to create a wrapper object and use it:

```ruby
vk = SmartVkApi.vk
vk.call('users.get', :user_ids => 'kimrgrey') # [{:uid=>3710412, ...}]
vk.call('photos.get', :owner_id => '3710412', :album_id => 'wall')
```

By default you are able to not specify `access_token`.  In this case only public methods will be available for call and `SmartVkApi::MethodCallError` will be raise when you'll try to call some private method. For example:

```ruby
SmartVkApi.call('wall.get', :owner_id => '3710412') # SmartVkApi::MethodCallError: {"error":{..., "error_msg":"Access denied: user hid his wall from accessing from outside"}}
```

If you want to call private methods you can specify `access_config` in global configuration:

```ruby
SmartVkApi.configure do |config|
  config.access_token = ACCESS_TOKEN
end
```

And if you pass another one `access_token` as a parameter for `call` it wil be used instead of globally configured:

```ruby
SmartVkApi.call('users.get', :user_ids => 'kimrgrey', :access_token => ANOTHER_ACCESS_TOKEN)
```

## Proxy object

It's very easy to make a mistake if you call methods by it's string names. That's why this gem provides a proxy object. You can use this object to call any methods of API as if it is a plain old ruby method:

```ruby
vk = SmartVkApi.vk
vk.users.get(:user_ids => 'kimrgrey')
```

And again you can configure `access_token` globally or use it as a parameter:

```ruby
vk = SmartVkApi.vk
vk.users.get(:user_ids => 'kimrgrey', :access_token => ACCESS_TOKEN)
```

In VK API "camelCase" style is used for mehtod's naming. But in ruby we can use "underscore" notation instead. So, for example, method `users.isAppUser` of API could be called using proxy object like this:

```ruby
vk = SmartVkApi.vk
vk.is_app_user(:user_id => '3710412')  
```

## How to take help the project?

As usual:

1. Create a fork (https://github.com/kimrgrey/smart_vk_api/fork)
2. Add a branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push it (`git push origin my-new-feature`)
5. Make a pull request
