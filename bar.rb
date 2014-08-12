require 'time' # you're gonna need it

class Bar
  attr_reader :name
  attr_accessor :menu_items
  def initialize(name)
    @name = name
    @menu_items = []
    @happy_discount = 0
    @happy_hour = false
  end

  def happy_discount
      if(happy_hour?)
        return @happy_discount
      else
        return 0
      end
  end
  def happy_hour?
      t = Time.now.hour
      if(t == 15)
        @happy_hour = true
      else
        return false
      end
  end
  def happy_discount=(stuff)
      if (stuff > 1)
        @happy_discount = 1
      elsif stuff < 0
        @happy_discount = 0
      else
        @happy_discount = stuff
      end
          
  end
  def add_menu_item(item, price)
     @menu_items << Drink.new(item, price)
  end 
end


class Drink
    attr_accessor :name, :price
    def initialize(name, price)
        @name = name
        @price = price
    end
end