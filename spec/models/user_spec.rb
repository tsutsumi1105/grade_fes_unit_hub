require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    it 'メールアドレスがないと無効' do
      user = User.new(email: nil, password: 'password123')
      expect(user).not_to be_valid
    end
  end
end