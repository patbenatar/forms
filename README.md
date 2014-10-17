# Forms

WIP Ruby form framework. While I'm building it out, please peruse the README
below and let me know if its something you'd like to use. Ideas for improvement?
Shoot!

### Key Concepts & Goals

1. __Flexibility:__ Decoupling models from user input allows for painfree
   changes to user interfaces and workflows.
1. __Reusability:__ Break forms down into discrete components to be composed in
   new and interesting ways.
1. __Implicit parameter sanitization:__ No need for whitelisting or
   strong_params when it's clear what fields exist on the form.
1. __Easy UI construction:__ Define template code once (or take advantage of
   semantic defaults) and easily reuse throughout your app

### Need to address

1. Dynamic setting of options based on context: like showing certain states in
   a select box depending on user's country.
1. Avoid double-nesting when using `field` DSL: since it expands into a nested
   `embed`, it'll double nest the namespace.
1.

## Form Objects

### Simple Forms

```ruby
class UserForm < Forms::Component
  # Define on the class...
  field :name
  field :phone_number
  field :accept_terms, :checkbox
  field :gender, radio: { options: %i[male female] }
  field :state, select: { options: [["California", "ca"], ["Oregon", "or"]] }
  field :pricing_plan, select: { options: :available_pricing_plans }

  private

  def setup
    # ...or on the instance
    field :pricing_plan, select: { options: available_pricing_plans }
  end

  def available_pricing_plans
    if my_model.is_cheap?
      ["Free Plan", "Plan 1", "Plan 2"]
    else
      ["Plan 3", "Plan 4"]
    end
  end
end

class CompanyForm < Forms::Component
  field :name
  field :founded, MyCustomInput
end
```

### Nested Forms (future)

```ruby
class EmploymentForm < Forms::Component
  field :date_hired, :date
  field :title

  embed UserForm
  embed CompanyForm
  embed EmailInput
end
```

### Nested Collections (future)

```ruby
class AdminForm < Forms::Component
  embed_many CompanyForm
end
```

## Rendering

Forms can render themselves to HTML:

```ruby
form = MyForm.new
form.render
```

Note that they do not include `<form>` or `<input type="submit">` tags. Where
and how your form is submitted is up to you. In Rails, you might do something
like this:

```erb
<%= form_tag employment_path, method: :post do %>
  <%= form.render %>
  <%= submit_tag %>
<% end %>
```

## Validations (future)

```ruby
class UserForm < Forms::Component
  embed :name, :text, validate: { presence: true }

  field :email, :text, validate: { presence: true, email: true }

  # Validations on this object
  validate :name_is_unique
  validate :user_can_sign_up

  private

  def name_is_unique
    if name_is_not_unique?
      get(:name).errors << Forms::Error.new("Name must be unique")
    end
  end

  def user_can_sign_up
    unless cool_enough_to_sign_up?
      errors << Forms::Error.new("Sorry you're not cool enough")
    end
  end
end
```

## Granular Rendering (future)

If you need control over how and where your components are rendered but prefer
not to implement custom components with accompanying templates, you can render
them individually:

```erb
<div>
  <%= form.get(:name).render %>
  <p>Lorem ipsum...</p>
</div>
<ul>
  <li><%= form.get(:date_field).get(:day).render %></li>
</ul>
```

## Customizing

Forms are composed of objects that inherit from `Component` and implement
the Component API. As such they possess the ability to be nested in all sorts
of fun ways. Understanding this structure is essential to customizing your
implementations.

### Component API

All components implement the following API:

* `initialize(namespace, options)` where namespace is an array in increasing
   order of specificity
* `value=(value)`
* `value`
* `parse(params)`
* `render`

`Component` has default implementations for all of these, see
`lib/forms/component.rb`

### Nesting

Components nest other components and are responsible for rendering their
children as well as setting/getting them. Setting values and parsing params
are passed down the tree to the relevant components. Retrieving data reaches
down the tree to pull cleansed input back up.

### Building Custom Components

Now that we understand the basics of the framework, let's build a custom set of
components to collect date input in three separate fields: one for day, month,
and year.

With nested inputs:

```ruby
class DateInput < Forms::Component
  embed :day, :text
  embed :month, :text
  embed :year, :text

  def value=(date)
    get(:day).value = date.day
    get(:month).value = date.month
    get(:year).value = date.year
  end

  def value
    Date.new get(:year).value, get(:month).value, get(:day).value
  end

  # The default implementations of `initialize`, `parse` and `render` will do
  # just fine for this input.
end
```

All on one component:

```ruby
class DateInput < Forms::Component
  # The default implementations of `initialize` will do just fine

  def value=(date)
    @day = date.day
    @month = date.month
    @year = date.year
  end

  def value
    Date.new(@year, @month, @day)
  end

  def parse(params)
    @year = params[:year]
    @month = params[:month]
    @day = params[:day]
  end

  def render
    # render some HTML with 3 inputs
  end
end
```

```ruby
class MyForm < Forms::Component
  embed :birthday, DateInput
end
```

```erb
form = MyForm.new
form.get(:birthday).render
```

## Built-in Conveniences

### Fields

Pairing a label with an input is a common use case. Forms ships with a default
`Field` component for exactly this purpose.

```ruby
class UserForm < Forms::Component
  # Use a Boolean type field
  field :is_admin, :checkbox

  # Essentially a shorthand for:
  embed :is_admin_field, Forms::Field do
    embed :is_admin, Forms::CheckboxInput
  end
end
```

### Inputs

Forms comes with a grip of standard inputs:

* `Forms::Text`, shorthand: `:text`
* `Forms::Textarea`, shorthand: `:textarea`
* `Forms::Checkbox`, shorthand: `:checkbox`
* `Forms::Radio`, shorthand: `:radio` (future)
* `Forms::Select`, shorthand: `:select` (future)



### Loading & Saving

This part is up to you. You might prefer to implement `load` and `save` methods
on their form objects, or maybe you pass your form object and models to a
service object to handle that. You could even do it in your controller. Forms
has no opinion on this.

















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
