# Forms

WIP concept for a Ruby form framework heavily inspired by django.Forms

```ruby
class UserSetupForm < Forms::Form
  field :name
  field :email, validates: [:email]
  field :gender, with: { radio: { options: [:male, :female] } }
  field :birthdate, with: :date

  # Basic
  field :name, :string # Forms::TextField.new(:name)
  field :age, :integer # Forms::IntegerField.new(:age)
  field :birthday, :date # Forms::DateField.new(:birthday)

  # Validations at form level
  field :email, :string
  validate :email_is_unique

  def email_is_unique
    #...
  end

  # Options for field, validate at that level
  field :email, string: { validates: [:email] }
  field :email, string: { editor: :email } # Forms::TextField.new(:email, editor: :email)

  # Options for editor
  field :gender, string: { editor: { radio: { choices: %w[male female] } } }
  field :gender, string: :gender

  # Forms::TextField.new(:gender, editor: { radio: { choices: %w[male female] } })
  # => Forms::RadioEditor.new(choices: %w[male female])

  def initialize
    fields[:name] = Forms::TextField.new(:name)
  end
end
```


### required API for any "component": Field, Editor, Group

* initialize(namespace, options) => namespace is an array
* value=(value)
* value
* parse(params)
* render