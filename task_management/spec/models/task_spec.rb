require 'rails_helper'

status_id = 1

RSpec.describe Task, type: :model do
  it "create task" do
    # 今回はinsertが三件なので、activerecord-importを
    # インストールせずに処理する
    status_master_params = [
      {:id => 1, :status_name => "未着手"},
      {:id => 2, :status_name => "着手中"},
      {:id => 3, :status_name => "完了"}
    ]

    status_master_params.each { |status_params|
      @status = Status.new(status_params)
      @status.save
    }

    # タスク登録
    task = Task.new(task_name: "model test", contents: "contents", status_id: status_id)
    expect(task).to be_valid
  end

  it "invalid task" do
    params = [
      { task_name: '', contents: 'contents', status_id: status_id},# タスク名は必須
      { task_name: 'model test', contents: '', status_id: status_id},# 内容は必須
      { task_name: 'a' * 256, contents: 'contents', status_id: status_id},# タスク名文字数オーバー
      { task_name: 'model test', contents: 'a' * 256, status_id: status_id},# 内容文字数オーバー
    ]

    params.each do |param|
      task = Task.new(param)
      expect(task).not_to be_valid
    end
  end
end
