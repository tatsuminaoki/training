# frozen_string_literal: true

class BoardController < ApplicationController
  require 'logic_board'

  def index
    user = User.find(session[:me][:user_id])
    @view_params = {
      'is_admin'      => user.admin?,
      'state_list'    => LogicBoard.get_state_list,
      'priority_list' => LogicBoard.get_priority_list,
      'label_list'    => LogicBoard.get_label_list,
    }
    render
  end

  def get_all_task
    page = params['page'].presence || 1
    if params['conditions'].blank?
      render json: {
        'response' => LogicBoard.get_all_task(session[:me][:user_id], page),
      }
    else
      render json: {
        'response' => LogicBoard.get_task_by_search_conditions(session[:me][:user_id], params['conditions'], page),
      }
    end
  end

  def get_task_by_id
    render json: {
      'response' => LogicBoard.get_task_by_id(session[:me][:user_id], params['id']),
    }
  end

  def get_master
    render json: {
      'response' => {
        'state'    => LogicBoard.get_state_list,
        'priority' => LogicBoard.get_priority_list,
        'label'    => LogicBoard.get_label_list,
      },
    }
  end

  def create
    render json: {
      'result' => LogicBoard.create(session[:me][:user_id], params),
    }
  end

  def update
    render json: {
      'result' => LogicBoard.update(session[:me][:user_id], params),
    }
  end

  def delete
    render json: {
      'result' => LogicBoard.delete(session[:me][:user_id], params['id']),
    }
  end
end
