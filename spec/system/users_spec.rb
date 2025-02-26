require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { create(:user) }

  before do
    driven_by :rack_test
  end

  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功する' do
          visit new_user_path
          fill_in 'user[name]', with: 'name'
          fill_in 'user[email]', with: 'email@example.com'
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button '登録'
          expect(page).to have_content 'ユーザー登録が完了しました'
          expect(current_path).to eq root_path
        end
      end

      context 'ユーザー名が未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_path
          fill_in 'user[name]', with: ''
          fill_in 'user[email]', with: 'email@example.com'
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button '登録'
          expect(current_path).to eq users_path
          expect(page).to have_content 'ユーザー登録に失敗しました'
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_path
          fill_in 'user[name]', with: 'name'
          fill_in 'user[email]', with: ''
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button '登録'
          expect(current_path).to eq users_path
          expect(page).to have_content 'ユーザー登録に失敗しました'
        end
      end

      context 'パスワードが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_path
          fill_in 'user[name]', with: 'name'
          fill_in 'user[email]', with: 'email@example.com'
          fill_in 'user[password]', with: ''
          fill_in 'user[password_confirmation]', with: 'password'
          click_button '登録'
          expect(current_path).to eq users_path
          expect(page).to have_content 'ユーザー登録に失敗しました'
        end
      end

      context 'パスワード再入力が未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_path
          fill_in 'user[name]', with: 'name'
          fill_in 'user[email]', with: 'email@example.com'
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: ''
          click_button '登録'
          expect(current_path).to eq users_path
          expect(page).to have_content 'ユーザー登録に失敗しました'
        end
      end

      context 'パスワードとパスワード再入力が一致しない' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_path
          fill_in 'user[name]', with: 'name'
          fill_in 'user[email]', with: 'email@example.com'
          fill_in 'user[password]', with: 'password1'
          fill_in 'user[password_confirmation]', with: 'password2'
          click_button '登録'
          expect(current_path).to eq users_path
          expect(page).to have_content 'ユーザー登録に失敗しました'
        end
      end

      context '登録済のメールアドレスを使用' do
        it 'ユーザーの新規作成が失敗する' do
          existed_user = create(:user)
          visit new_user_path
          fill_in 'user[name]', with: 'name'
          fill_in 'user[email]', with: existed_user.email
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button '登録'
          expect(current_path).to eq users_path
          expect(page).to have_content 'ユーザー登録に失敗しました'
          expect(page).to have_field 'user[email]', with: existed_user.email
        end
      end
    end

    describe 'マイページ' do
      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗する' do
          visit mypage_path
          expect(page).to have_content('ログインしてください')
          expect(current_path).to eq login_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login_as(user) }

    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do
          visit edit_user_path(user)
          fill_in 'user[name]', with: 'new_name'
          fill_in 'user[email]', with: 'new_email@example.com'
          click_button '更新'
          expect(page).to have_content('ユーザー情報を更新しました')
          expect(current_path).to eq mypage_path
        end
      end

      context 'ユーザー名が未入力' do
        it 'ユーザーの編集が失敗する' do
          visit edit_user_path(user)
          fill_in 'user[name]', with: ''
          fill_in 'user[email]', with: 'new_email@example.com'
          click_button '更新'
          expect(page).to have_content('更新に失敗しました')
          expect(current_path).to eq user_path(user)
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する' do
          visit edit_user_path(user)
          fill_in 'user[name]', with: 'new_name'
          fill_in 'user[email]', with: ''
          click_button '更新'
          expect(page).to have_content('更新に失敗しました')
          expect(current_path).to eq user_path(user)
        end
      end

      context '登録済のメールアドレスを使用' do
        it 'ユーザーの編集が失敗する' do
          visit edit_user_path(user)
          other_user = create(:user)
          fill_in 'user[name]', with: 'new_name'
          fill_in 'user[email]', with: other_user.email
          click_button '更新'
          expect(page).to have_content('更新に失敗しました')
          expect(current_path).to eq user_path(user)
        end
      end

      describe 'マイページ' do
        context '記事を作成' do
          it '新規作成した記事が表示される' do
            create(:article, title: 'test_title', body: 'test_body', user: user)
            visit mypage_path
            expect(page).to have_content('投稿一覧')
            expect(page).to have_content('test_title')
          end
        end
      end
    end
  end
end
