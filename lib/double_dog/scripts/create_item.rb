module DoubleDog

  class CreateItem < TransactionScript
    include Auth

    def run(params)
      return failure(:not_admin) unless admin_session?(params[:session_id])
      return failure(:invalid_name) unless valid_name?(params[:name])
      return failure(:invalid_price) unless valid_price?(params[:price])

      item = DoubleDog.db.create_item(:name => params[:name], :price => params[:price])
      return success(:item => item)
    end
  end
end
