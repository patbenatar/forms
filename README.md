# Forms

WIP Ruby form framework heavily inspired by django.Forms

### Key Components

* __Form__: A collection of fields that can be rendered to screen and used to
  parse incoming HTTP params.
* __Field__: Converts strings submitted from HTML forms into more
  relevant data types, and vice versa.
* __Editor__: Renders the field to the screen as HTML.

#### Component API

All of the above behave as "Components" of a form, and thus possess the
ability to be nested in all sorts of fun ways. Components must implement the
following interface:

* `initialize(namespace, options)` Where namespace is an array in increasing order of specificity
* `value=(value)`
* `value`
* `parse(params)`
* `render`

## Form Objects

### Simple Forms

```ruby
class UserForm < Forms::Form
  field :name
  field :phone_number
end

class CompanyForm < Forms::Form
  field :name
end
```

### Nested Forms (future)

```ruby
class EmploymentForm < Forms::Form
  field :date_hired
  field :title

  embed UserForm
  embed CompanyForm
end
```

### Nested Collections (future)

```ruby
class AdminForm < Forms::Form
  embeds CompanyForm, many: true
end
```

### Fields

Converts strings submitted from HTML forms into more relevant data
types, and vice versa.

```ruby
class UserForm < Forms::Form
  # Use a Boolean type field
  field :is_admin, :boolean
end
```

### Editors

Renders the actual attribute to the screen as HTML. Upon submission,
extracts its relevant params and returns them to a format the Field
can understand. For instance, a date may be rendered as three separate
inputs but the Field only cares about the combined value of those inputs.

```ruby
class UserForm < Forms::Form
  # Use a special editor for phone numbers
  field :phone_number, string: :phone_number

  # Options for editor:
  field :gender, string: { radio: { options: %w[male female] } }
end
```

### Validations (future)

```ruby
class UserForm < SuperRadForm
  # Validate at field level
  field :name, string: { validates: { presence: true } }

  # Validate at form level
  validate :name_is_unique

  # Validate at editor level
  field :name, string: { editor: { text: { validates: { presence: true } } } }
end
```

### Loading (future)

...coming...

#### Nested forms (future)

```ruby
class EmploymentsController < ApplicationController
  def new
    @employment_form = EmploymentForm.new(
      Employment.find(params[:id]),
      user_form: current_user,
      company_form: current_user.company
    )
  end
end
```

### Saving (future)

...coming...

### Rendering

Forms can render their fields easily:

```ruby
form = MyForm.new
form.render
```

#### Detailed Rendering (future)

...coming... Render each field or editor individually

## Example Rails Usage

### Controller (future)

```ruby
class EmploymentsController < ApplicationController
  def new
    @user_form = UserForm.new
  end

  def create
    @user_form = UserForm.new
    @user_form.parse(params)

    if @user_form.save
      # ...
    else
      render :new
    end
  end

  def edit
    @user_form = UserForm.new(User.find(params[:id]))
  end

  def update
    @user_form = UserForm.new(User.find(params[:id]))
    @user_form.parse(params)

    if @user_form.save
      # ...
    else
      render :new
    end
  end
end
```

### View

Form objects render the contents of a form without a wrapping `<form>` tag or
submit button. Because where and how you submit your form can be unique to
different use cases, we leave that up to you.

```html
<h1>Become an Employee!</h1>
<%= form_tag employment_path, method: :post do %>
  <%= @employment_form.render %>
  <%= submit_tag %>
<% end %>
```