require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  context '#index' do
    it 'assigns @task' do
      task = Task.create
      get :index
      expect(assigns(:tasks)).to eq([task])
    end
    it 'renders index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  context '#new' do

  end

  context '#create' do

  end

  context '#show' do

  end

  context '#edit' do

  end

  context '#update' do

  end

  context '#destroy' do

  end
end
