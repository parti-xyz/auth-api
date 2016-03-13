shared_context 'user' do
  include Test::Factories::Users
  include_context 'sign_up'

  def user_not_exist(attrs)
    User.where(attrs).destroy_all
  end

  def user_auth_token_exists(attrs = {})
    attrs = { password: 'Passw0rd!' }.merge(attrs)
    user = user_exists(attrs)
    post v1_user_session_path,
      email: user.email,
      password: attrs[:password]
    expect(last_response.status).to eq(200)
    last_response.headers.slice('access-token', 'client', 'uid')
      .transform_keys { |key| key.parameterize.underscore.to_sym }
  end

  def delete_user_for_test(token: nil, user_id:)
    if token
      header 'Authorization', "Bearer #{token}"
    end
    delete "/v1/test/users/#{user_id}"
  end

  def list_users_for_test(token: nil, **attrs)
    if token
      header 'Authorization', "Bearer #{token}"
    end
    get '/v1/test/users', attrs
  end

  def user_should_be_created(params)
    last_user = User.createds.last
    expect(last_user.email).to eq(params[:email])
    expect(last_user.valid_password? params[:password]).to be true
  end

  def user_should_be_deleted(params)
    users = User.where(params)
    expect(users).to be_empty
  end

  def response_should_render_users(users)
    expect(last_response.status).to eq(200)
    users_json = ActiveModel::SerializableResource.new(users).to_json
    expect(last_response.body).to be_json_eql(users_json)
  end
end
