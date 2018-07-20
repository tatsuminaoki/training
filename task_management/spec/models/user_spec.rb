require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#validation' do
    describe 'ユーザ名' do
      context '0文字の場合' do
        let(:user){FactoryBot.build(:user, user_name: '')}
        it 'バリデーションエラーが発生する' do
          expect(user.validate).to be_falsy
          expect(user.errors).to have_key(:user_name)
          expect(user.errors.full_messages).to eq ['ユーザ名を入力してください']
        end
      end

      context '1文字の場合' do
        let(:user){FactoryBot.build(:user, user_name: 'a')}
        it 'バリデーションエラーが発生しない' do
          expect(user.validate).to be_truthy
        end
      end

      context '255文字の場合' do
        let(:user){FactoryBot.build(:user, user_name: 'a'*255)}
        it 'バリデーションエラーが発生しない' do
          expect(user.validate).to be_truthy
        end
      end

      context '256文字の場合' do
        let(:user){FactoryBot.build(:user, user_name: 'a'*256)}
        it 'バリデーションエラーが発生する' do
          expect(user.validate).to be_falsy
          expect(user.errors).to have_key(:user_name)
          expect(user.errors.full_messages).to eq ['ユーザ名は255字以内で入力してください']
        end
      end
    end

    describe 'メールアドレス' do
      context '正常なメールアドレスの場合' do
        let(:user){FactoryBot.build(:user)}
        it 'バリデーションエラーが発生しない' do
          expect(user.validate).to be_truthy
        end
      end

      context '0文字の場合' do
        let(:user){FactoryBot.build(:user, mail_address: '')}
        it 'バリデーションエラーが発生する' do
          expect(user.validate).to be_falsy
          expect(user.errors.full_messages).to eq ['メールアドレスを入力してください']
        end
      end

      context '不正なメールアドレスの場合' do
        let(:user){FactoryBot.build(:user, mail_address: 'aaa')}
        it 'バリデーションエラーが発生する' do
          expect(user.validate).to be_falsy
          expect(user.errors.full_messages).to eq ['正しいメールアドレスを入力してください']
        end
      end

      context '255文字の場合' do
        let(:user){FactoryBot.build(:user, mail_address: "#{'a'*243}@example.com")}
        it 'バリデーションエラーが発生しない' do
          expect(user.validate).to be_truthy
        end
      end

      context '256文字の場合' do
        let(:user){FactoryBot.build(:user, mail_address: "#{'a'*244}@example.com")}
        it 'バリデーションエラーが発生する' do
          expect(user.validate).to be_falsy
          expect(user.errors).to have_key(:mail_address)
          expect(user.errors.full_messages).to eq ['メールアドレスは255字以内で入力してください']
        end
      end

      context '既に登録されているメールアドレスの場合' do
        before do
          FactoryBot.create(:user, mail_address: 'a@example.com')
        end
        let(:user){FactoryBot.build(:user, mail_address: 'a@example.com')}
        it 'バリデーションエラーが発生する' do
          expect(user.validate).to be_falsy
          expect(user.errors.full_messages).to eq ['メールアドレスは既に登録されています']
        end
      end
    end

    describe 'パスワード' do
      context '0文字の場合' do
        let(:user){FactoryBot.build(:user, password: '')}
        it 'バリデーションエラーが発生する' do
          expect(user.validate).to be_falsy
          expect(user.errors).to have_key(:password)
          expect(user.errors.full_messages).to eq ['パスワードを入力してください']
        end
      end

      context '1文字の場合' do
        let(:user){FactoryBot.build(:user, password: 'a')}
        it 'バリデーションエラーが発生しない' do
          expect(user.validate).to be_truthy
        end
      end

      context '72文字の場合' do
        let(:user){FactoryBot.build(:user, password: 'a'*72)}
        it 'バリデーションエラーが発生しない' do
          expect(user.validate).to be_truthy
        end
      end

      context '73文字の場合' do
        let(:user){FactoryBot.build(:user, password: 'a'*73)}
        it 'バリデーションエラーが発生する' do
          expect(user.validate).to be_falsy
          expect(user.errors).to have_key(:password)
          expect(user.errors.full_messages).to eq ['パスワードは72字以内で入力してください']
        end
      end
    end
  end

  describe 'Relation' do
    context 'ユーザを削除した場合' do
      let(:user){FactoryBot.create(:user)}
      let!(:id){user.id}
      let!(:task){FactoryBot.create(:task, user_id: user.id)}
      let(:task_amount){Task.where(user_id: id).size}
      it 'ユーザが持っているタスクも同時に削除される' do
        user.destroy

        expect(task_amount).to eq 0
      end
    end
  end
end
