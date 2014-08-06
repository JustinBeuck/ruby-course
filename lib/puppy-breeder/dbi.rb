require 'pry-byebug'
require 'pg'
require 'time'

module TheMill
  class DBI
    def initialize
      @db = PG.connect(host: 'localhost', dbname: 'petbreeder')
      build_tables
    end
    
    def build_tables
      @db.exec(%q[
        CREATE TABLE IF NOT EXISTS breeds(
          id serial NOT NULL PRIMARY KEY,
          breed varchar(30),
          price integer
        )])
  
      @db.exec(%q[
        CREATE TABLE IF NOT EXISTS puppies(
          id serial NOT NULL PRIMARY KEY,
          breed varchar(30),
          name varchar(30),
          age integer,
          created_at timestamp NOT NULL DEFAULT current_timestamp
        )])
  
      @db.exec(%q[
        CREATE TABLE IF NOT EXISTS requests(
          id serial NOT NULL PRIMARY KEY,
          breed varchar(30),
          status varchar(30),
          customer varchar(30),
          created_at timestamp NOT NULL DEFAULT current_timestamp
        )])
    end

    
    #
    # Method to create a breed record
    #
    def create_breed(breed, price)
      @db.exec_params(%q[
        INSERT INTO breeds (breed, price)
        VALUES ($1, $2);
      ], [breed, price])
    end

    def get_breed_list
      response = @db.exec(%q[SELECT * FROM breeds;])
      response.map { |row| [row["breed"], row["price"]] }
    end

    #
    # Methods to create, update, list, and build puppies
    #
    def persist_puppy(pup)
      response = @db.exec_params(%q[
        INSERT INTO puppies (name, breed, age)
        VALUES ($1, $2, $3)
        RETURNING *;
      ], [pup.name, pup.breed, pup.age])

      update_on_hold_requests(pup.breed)

      build_puppy(response.first)
    end
    
    def get_all_puppies
      response = @db.exec(%q[SELECT * FROM puppies;])
      response.map { |row| build_puppy(row) }
    end

    def get_puppies_by_breed(breed)
      response = @db.exec(%Q[
        SELECT * FROM puppies WHERE breed = '#{breed}';
      ])

      response.map { |row| build_puppy(row) }
    end

    def build_puppy(data)
      TheMill::Puppy.new(data["breed"], data["name"],
                         data["age"], data["id"].to_i,
                         data["created_at"])
    end

    def delete_puppy(id)
      @db.exec_params(%q[
        DELETE FROM puppies
        WHERE id = $1;
      ], [id])
    end
    #
    # Methods to create, update, list, and build requests
    #
    def persist_request(req)
      available_pups = get_puppies_by_breed(req.breed)
      if available_pups.count < 1
        req.hold!
      end

      response = @db.exec(%Q[
        INSERT INTO requests
          (breed, status, customer)
        VALUES
          ('#{req.breed}', '#{req.status}', '#{req.customer}')
        RETURNING *;
      ])

      build_request(response.first)
    end
    
    def update_request(req)
      @db.exec(%Q[
        UPDATE requests SET status = '#{req.status}'
        WHERE id = #{req.id};
      ])
    end

    def get_all_requests
      response = @db.exec("SELECT * FROM requests;")
      response.map { |row| build_request(row) }
    end

    def get_active_requests
      response = @db.exec(%q[
        SELECT * FROM requests
        WHERE status = 'pending';
      ])
      response.map { |row| build_request(row) }
    end

    def build_request(data)
      TheMill::Request.new(data["breed"], data["status"].to_sym,
                           data["customer"], data["id"].to_i,
                           Time.parse(data["created_at"]))
    end

    def update_on_hold_requests(breed)
      request_data = @db.exec(%Q[
        SELECT * FROM requests WHERE breed = '#{breed}';
      ])

      requests = request_data.map { |row| build_request(row) }
      requests.each { |r| r.activate!; update_request(r) }
    end
  end
  
  def self.dbi
    @__db_instance ||= DBI.new
  end
end
