class TasksController < ApplicationController
  def list
    @tasks = Task.all
  end
end
