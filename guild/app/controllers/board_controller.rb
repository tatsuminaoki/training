class BoardController < ApplicationController
  require 'logic_board'
  @@user_id = 1 # write direct for the moment.

  def index
    @view_params = LogicBoard.index(@@user_id)
    render
  end

  def get_task_all
    render :json => {
      'response' => LogicBoard.get_task_all(@@user_id)
    }
  end

  def get_task_by_id
    render :json => {
      'response' => LogicBoard.get_task_by_id(@@user_id, params['id'])
    }
  end

  def get_master
    render :json => {
      'response' => {
        'state'    => LogicBoard.get_state_list,
        'priority' => LogicBoard.get_priority_list,
        'label'    => LogicBoard.get_label_list,
      }
    }
  end

  def create
    render :json => {
      'result' => LogicBoard.create(@@user_id, params)
    }
  end

  def update
    render :json => {
      'result' => LogicBoard.update(@@user_id, params)
    }
  end

  def delete
    render :json => {
      'result' => LogicBoard.delete(@@user_id, params['id'])
    }
  end
end
