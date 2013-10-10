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


# Outdated README, original documentation.. will update soon:

# SuperRadForm

### Key components

* __Form__: Connects resources (models) with form fields.
* __Field__: Converts strings submitted from HTML forms into more
  relevant data types, and vice versa.
* __Presenter__: Renders the field to the screen as HTML.

## Form Objects

Live in `app/forms`. Connects resources (models) with form fields.

### Single resource

```ruby
class UserForm < SuperRadForm
  field :name
  field :phone_number
end

class CompanyForm < SuperRadForm
  field :name
end
```

### Nested resources

```ruby
class EmploymentForm < SuperRadForm
  field :date_hired
  field :title

  embed UserForm
  embed CompanyForm
end
```

### Fields

Custom ones live in `app/forms/fields`.
Converts strings submitted from HTML forms into more relevant data
types, and vice versa.

```ruby
class UserForm < SuperRadForm
  field :is_admin, with: SuperRadForm::Fields::BooleanField
end
```

### Presenters

Custom ones live in `app/forms/presenters`.
Renders the actual attribute to the screen as HTML. Upon submission,
extracts its relevant params and returns them to a format the Field
can understand. For instance, a date may be rendered as three separate
inputs but the Field only cares about the combined value of those inputs.

```ruby
class UserForm < SuperRadForm
  field :phone_number,
    presenter: SuperRadForm::Presenters::PhoneNumberField
end
```

### Validations

```ruby
class UserForm < SuperRadForm
  field :name,
    validates: { presence: true }
end
```

## Controller

### Basic usage

```ruby
class EmploymentsController < ApplicationController
  def new
    @user_form = UserForm.new(params, User.find(params[:id]))
  end

  def create
    @user_form = UserForm.new(params, User.find(params[:id]))
    if @user_form.save
      # ...
    else
      render :new
    end
  end
end
```

### Nested forms

```ruby
class EmploymentsController < ApplicationController
  def new
    @employment_form = EmploymentForm.new(
      params,
      Employment.find(params[:id]),
      user_form: current_user,
      company_form: current_user.company
    )
  end
end
```

## View

### Explicit rendering

```html
<h1>Become an Employee!</h1>
<%= @employment_form.render %>
```

### Implicit rendering (`to_s`)

```html
<%= @employment_form %>
```

## But what about updating?

Not sure yet. Pair model attributes with form fields manually in the
form init? I'd like to avoid assuming a one-to-one relationship between
fields and model attributes.

```ruby
class UserForm < SuperRadForm
  def initialize(*args)
    super
    name = resource.name
  end
end
```