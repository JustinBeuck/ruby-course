require 'sinatra'
require_relative 'lib/puppy-breeder.rb'

get '/' do
  erb :index
end

get '/breeds' do
  @breeds = TheMill.dbi.get_breed_list
  erb :breeds
end

post '/breeds' do
  TheMill.dbi.create_breed(params["breed"], params["price"].to_i)
  redirect to '/breeds'
end

get '/puppies' do
  @puppies = TheMill.dbi.get_all_puppies
  erb :puppies
end

get '/pendingreqs/:id' do
  reqs = TheMill.dbi.get_all_requests
  request = reqs.find { |r| r.id == params['id'].to_i }
  request.accept!
  TheMill.dbi.update_request(request)
  redirect to '/requests'
end

get '/deletepup/:id' do
  TheMill.dbi.delete_puppy(params[:id].to_i)
  redirect to '/puppies'
end

post '/puppies' do
  pup = TheMill::Puppy.new(params["breed"], params["name"], params["age"])
  TheMill.dbi.persist_puppy(pup)
  redirect to '/puppies'
end

get '/requests' do
  requests = TheMill.dbi.get_all_requests
  @pending = requests.select { |r| r.pending? }
  @onhold = requests.select { |r| r.on_hold? }
  @accepted = requests.select { |r| r.accepted? }
  erb :requests
end

post '/requests' do
  req = TheMill::Request.new(params["breed"], :pending, params["customer"])
  TheMill.dbi.persist_request(req)
  redirect to '/requests'
end
