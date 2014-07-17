# require 'spec_helper'
require "./exercises.rb"


describe 'Exercise 0' do
	it "triples the length of a string" do
		result = Exercises.ex0("ha")
		expect(result).to eq("hahaha")
	end

	it "returns 'nope' if the string is 'wishes'" do
		result = Exercises.ex0("wishes")
		expect(result).to eq("nope")
	end

	it "returns the number of elements in an array" do
		result = Exercises.ex1([1,2,3])
		expect(result).to eq(3)
	end

	it "returns the second number of element of an array" do
		result = Exercises.ex2([1,2,3])
		expect(result).to eq(2)
	end

	it "returns the sum of the given array of numbers" do
		result = Exercises.ex3([1,2,3])
		expect(result).to eq(6)
	end

	it "returns the max number of the given array" do
		result = Exercises.ex4([1,2,3])
		expect(result).to eq(3)
	end

	it "iterates through an array and 'puts' each element" do
		array = [1,2,3]
		# Exercises.ex5(array).should_receive(:puts).with("1", "2", "3")
       expect(STDOUT).to receive(:puts).with(1)
       expect(STDOUT).to receive(:puts).with(2)
       expect(STDOUT).to receive(:puts).with(3)
       Exercises.ex5(array)
 		end

 		it "Updates the last item in the array to 'panda'" do
		result = Exercises.ex6([1,2,3])
		expect(result).to eq([1,2,"panda"])
	end

		it "Updates the last item in the array to 'GODZILLA'" do
		result = Exercises.ex6([1,2,"panda"])
		expect(result).to eq([1,2,"GODZILLA"])
	end

  	it "If the string 'str' exits in the array, add 'str' to the end of
the array" do     
		result = Exercises.ex7([1,2,"panda"], "panda")
		expect(result).to eq([1,2,"panda","panda"])   
	end 

  it "iterate through array of hashes return people and occupation" do          
  	people = [{:name => "Bob", :occupation => "Builder"}, {:name => "Kobe", :occupation => "Basketball Player"}]    
  		expect(STDOUT).to receive(:puts).with("Bob Builder")
      expect(STDOUT).to receive(:puts).with("Kobe Basketball Player")
      Exercises.ex8(people)
  end  

  it "returns true if leap year, false if not leap year" do
  	result = Exercises.ex9(2001)
  	expect(result).to eq(false)
  end

  it "returns true if leap year, false if not leap year" do
  	result = Exercises.ex9(2000)
  	expect(result).to eq(true)
	end
end











