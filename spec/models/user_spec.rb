require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    it '設定したすべてのバリデーションが機能しているか' do
      user = create(:user)
      expect(user).to be_valid
    end

    it 'メールアドレスがない場合失敗' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it 'ユーザー名がない場合失敗' do
      user = build(:user, name: nil)
      expect(user).not_to be_valid
    end

    it 'パスワードがない場合失敗' do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
    end

    it 'メールアドレスが一意でない場合失敗' do
      create(:user, email: "test@example.com")
      user = build(:user, email: "test@example.com")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end

    it 'パスワードとパスワード再入力が一致しない場合失敗' do
      user = build(:user, password: "password", password_confirmation: "different")
      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end
  end
end