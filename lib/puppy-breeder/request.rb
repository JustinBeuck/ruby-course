module TheMill
  class Request
    attr_reader :breed, :customer, :id, :created_at, :status
  
    def initialize(breed, status=:pending, customer=nil, id=nil, created_at=nil)
      @breed = breed
      @status = status
      @customer = customer
      @id = id
      @created_at = created_at
    end

    def activate!
      @status = :pending
    end

    def pending?
      @status == :pending
    end
  
    def accept!
      @status = :accepted
    end

    def accepted?
      @status == :accepted
    end

    def hold!
      @status = :on_hold
    end

    def on_hold?
      @status == :on_hold
    end
  end
end
