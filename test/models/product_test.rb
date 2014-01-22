require 'test_helper'

class ProductTest < ActiveSupport::TestCase
	#fixtures :products
  test "product attr must not be empty" do
	product = Product.new
	assert product.invalid?
	assert product.errors[:title].any?
	assert product.errors[:description].any?
	assert product.errors[:price].any?  	
	assert product.errors[:image_url].any?
  end
  test "price must be positive" do
  	product = Product.new(
  		title: "toto", 
  		description: "tutu", 
  		image_url: "titi.jpg"
  		)
  	product.price = 0
  	assert product.invalid?
  	assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]
  	product.price = 1
  	assert product.valid?
  end

  def new_product(image_url)
  	Product.new(
  		title: "toto", 
  		description: "tutu", 
  		image_url: image_url, 
  		price: 1
  		)
  end

  test "image_url" do 
  	ok = %w{fred.gif fred.jpg fred.png FRED.PNG}
  	bad = %w{fred.doc fred.gif/more fred.png.toto}
  	ok.each do |name|
  	  assert new_product(name).valid?, "#{name} should be valid"
  	end
  	bad.each do |name|
  	  assert new_product(name).invalid?, "#{name} should be invalid"
  	end
  end

  test "unique title" do
  	product = Product.new(
  		title: products(:ruby).title, 
  		description: "tutu", 
  		image_url: "im.jpg", 
  		price: 1
  		)
  	assert product.invalid?
  	assert_equal ["has already been taken"], product.errors[:title]
  end

  test "unique title i18n" do
  	product = Product.new(
  		title: products(:ruby).title, 
  		description: "tutu", 
  		image_url: "im.jpg", 
  		price: 1
  		)
  	assert product.invalid?
  	assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end
end
