class BoardController < ApplicationController
  require 'logic_board'
  @@user_id = 1 # write direct for the moment.

  def index
    @view_params = LogicBoard.new.index(@@user_id)
    render 
  end

  def get_task_all
    render :json => {
      'response' => LogicBoard.new.get_task_all(@@user_id)
    }
  end

  def get_task_by_id
    render :json => {
      'response' => LogicBoard.new.get_task_by_id(@@user_id, params['id'])
    }
  end

  def get_master
    render :json => {
      'response' => {
        'state'    => LogicBoard.new.get_state_list,
        'priority' => LogicBoard.new.get_priority_list,
        'label'    => LogicBoard.new.get_label_list,
      }
    }
  end

  def create
    render :json => {
      'result' => LogicBoard.new.create(@@user_id, params)
    }
  end

  def update
    render :json => {
      'result' => LogicBoard.new.update(@@user_id, params)
    }
  end

  def delete
    render :json => {
      'result' => LogicBoard.new.delete(@@user_id, params['id'])
    }
  end
end
