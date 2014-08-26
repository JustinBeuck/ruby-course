	module Auth

		def admin_session?(session_id)
	    user = DoubleDog.db.get_user_by_session_id(session_id)
	    user.admin?
	  end

	  def valid_items?(items)
      items != nil && items.count >= 1
    end

    def valid_username?(username)
      username != nil && username.length >= 3
    end

    def valid_password?(password)
      password != nil && password.length >= 3
    end

    def valid_name?(name)
      name != nil && name.length >= 1
    end

    def valid_price?(price)
      price != nil && price >= 0.50
    end
	end

