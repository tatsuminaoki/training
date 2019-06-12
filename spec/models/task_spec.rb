require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'valid?' do
    let(:task) { create(:task) }

    context 'タイトルと詳細がある場合' do
      it "タスクが正常に作成される" do
        expect(task).to be_valid
      end
    end
  end
end
