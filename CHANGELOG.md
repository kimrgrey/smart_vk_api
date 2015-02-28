
## Версия 1.1.0

* Добавлена возможность вызывать методы API, используя обычные методы Ruby.
  
  Пример:
  
  ```ruby
    vk = SmartVkApi::VK.new
    vk.users.get
  ```

* Добавлена возможность задать конфигурацию для обращений к API.

  Пример:

  ```ruby
    SmartVkApi.configure do |conf|
      conf.access_token = '7a6fa4dff77a228eeda56603'
    end
  ```

  При этом токены, которые записаны в конфиг, будут автоматически использованы, если в методы не передано другого значения:

  ```ruby
    SmartVkApi.configure do |conf|
      conf.access_token = '7a6fa4dff77a228eeda56603'
    end
    vk = SmartVkApi::VK.new
    vk.access_token # => 7a6fa4dff77a228eeda56603
  ```

  Но можно также передать более специфичный конфиг, если это требуется:

  ```ruby
    SmartVkApi.configure do |conf|
      conf.access_token = '7a6fa4dff77a228eeda56603'
    end
    config = SmartVkApi::Configuration.new
    config.access_token = '36fb063aa7f0ad997b5f96e91fd362857b'
    vk = SmartVkApi::VK.new(config)
    vk.access_token # => 36fb063aa7f0ad997b5f96e91fd362857b
  ```

* Добавлена возможность прямого вызова API через метод модуля:
  
  Пример:

  ```ruby
    SmartVkApi.call('users.get', :user_ids => 'kimrgrey') # [{:uid=>3710412, :first_name=>"Сергей", :last_name=>"Цветков", :hidden=>1}]
  ```

Чтобы посомотреть предыдущие изменения, пожалуйста, откройте соответствующий релиз - [v1.0.0](https://github.com/kimrgrey/smart_vk_api/tree/v1.0.0)