# frozen_string_literal: true

module SignIn
  def sign_in_as_with_github(name)
    user = users(name)

    OmniAuth.config.add_mock(
      :github,
      {
        uid: Faker::Internet.uuid,
        info: { nickname: user[:nickname], email: user[:email] },
        credentials: { token: user[:token] }
      }
    )

    get callback_auth_path(:github)
    user
  end
end
