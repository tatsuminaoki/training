require 'rails_helper'
require 'logic_board'

describe BoardController, type: :request do
  let!(:task_a) { create(:task1) }
  context '#index' do
    it 'whether request succeed' do
      get '/board/'
      expect(response).to have_http_status "200"
    end

    it 'whether html returns' do
      get '/board/'
      expect(response.body).to include ' <a class="navbar-brand" href="#">Guild</a>'
    end
  end

  context '#get_master' do
    it 'whether request succeed' do
      get '/board/api/master/all'
      expect(response).to have_http_status "200"
    end

    it 'whether expected json returns' do
      get '/board/api/master/all'
      response_params = JSON.parse(response.body)
      expect(response_params['response']['state'].count).to be > 1
      expect(response_params['response']['priority'].count).to be > 1
      expect(response_params['response']['label'].count).to be > 1
    end
  end

  context '#get_task_all' do
    it 'whether request succeed' do
      get '/board/api/task/all'
      expect(response).to have_http_status "200"
    end

    it 'whether expected json returns' do
      get '/board/api/task/all'
      response_params = JSON.parse(response.body)
      expect(response_params['response']['task_list'].count).to_not eq 0
      task = response_params['response']['task_list'][0]
      expect(task['id']).to eq task_a.id
      expect(task['user_id']).to eq task_a.user_id
    end
  end

  context '#get_task_by_id' do
    it 'whether request succeed' do
      get '/board/api/task/' + task_a.id.to_s
      expect(response).to have_http_status "200"
    end

    it 'whether expected json returns' do
      get '/board/api/task/' + task_a.id.to_s
      response_params = JSON.parse(response.body)
      expect(response_params['response']['task']['id']).to eq task_a.id
      expect(response_params['response']['task']['user_id']).to eq task_a.user_id
    end
  end

  context '#create' do
    let!(:params) {
      {
        'subject'     => 'subject by rspec',
        'description' => 'description by rspec',
        'label'       => 2,
        'priority'    => 2,
      }
    }
    it 'whether request succeed' do
      post '/board/api/task', params: params
      expect(response).to have_http_status "200"
    end

    it 'whether expected response returns' do
      post '/board/api/task', params: params
      response_params = JSON.parse(response.body)
      expect(response_params['result']).to_not eq 0
    end
  end

  context '#delete' do
   let!(:params) {
      {
        'subject'     => 'subject by rspec',
        'description' => 'description by rspec',
        'label'       => 3,
        'priority'    => 3,
      }
    }
    it 'whether request succeed' do
      created_task_id = LogicBoard.create(task_a.user_id, params)
      delete '/board/api/task/' + created_task_id.to_s
      expect(response).to have_http_status "200"
    end

    it 'whether expected response returns' do
      created_task_id = LogicBoard.create(task_a.user_id, params)
      delete '/board/api/task/' + created_task_id.to_s
      response_params = JSON.parse(response.body)
      expect(response_params['result']).to_not eq 0
    end
  end

  context '#update' do
    let!(:create_params) {
      {
        'subject'     => 'subject by rspec',
        'description' => 'description by rspec',
        'label'       => 3,
        'priority'    => 3,
      }
    }

    let!(:update_params) {
      {
        'subject'     => 'updated subject',
        'description' => 'updated description',
        'label'       => 3,
        'priority'    => 3,
        'state'       => 3,
      }
    }

    it 'whether request succeed' do
      created_task_id = LogicBoard.create(task_a.user_id, create_params)
      put '/board/api/task/' + created_task_id.to_s, params: update_params
      expect(response).to have_http_status "200"
    end

    it 'whether expected response returns' do
      created_task_id = LogicBoard.create(task_a.user_id, create_params)
      put '/board/api/task/' + created_task_id.to_s, params: update_params
      response_params = JSON.parse(response.body)
      expect(response_params['result']).to_not eq 0
    end
  end
end
