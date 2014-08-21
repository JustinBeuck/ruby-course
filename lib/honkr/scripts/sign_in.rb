module Honkr
  class SignIn

    def self.run(params)
      user = Honkr.db.get_user_by_username(params[:username])
      if user == nil
        return { :success? => false, :error => "No User Found !!" }
      end

      if user.has_password?(params[:password])
        session_id = Honkr.db.create_session( {:user_id => user.id} )
        return { :success? => true, :session_id => session_id }
      else
        return { :success? => false, :error => :invalid_password }
      end

    end

  end
end