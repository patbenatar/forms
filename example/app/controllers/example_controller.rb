class ExampleController < ApplicationController
  def new
    @form = ExampleForm.new
  end

  def create
    @form = ExampleForm.new
    @form.parse(params)

    render :new
  end
end