def find_item_by_name_in_collection(name, collection)
  index = 0
  while index < collection.length do
    return collection[index] if collection[index][:item] == name
    index += 1
  end
  return nil
  
  
end

def consolidate_cart(cart)
  index = 0
  counter_hash = {}
  result_array = []
  
  while index < cart.length do
    product_name = cart[index][:item]
    if counter_hash[product_name]
      counter_hash[product_name] += 1
    else
      counter_hash[product_name] = 1
    end
    index += 1
  end
 
 index = 0
 while index < cart.length do
   product = cart[index]
   product_name = product[:item]
   if counter_hash[product_name] > 0
     product[:count] = counter_hash[product_name]
     counter_hash[product_name] = 0
     result_array << product
   end
   
   index += 1
 end
 result_array
end

def apply_coupons(cart, coupons)
  result_array = []
  cart_index = 0
  while cart.length > cart_index do
    cart_item = cart[cart_index]
    coupons_index = 0
    while coupons.length > coupons_index do
      coupon = coupons[coupons_index]
      if coupon[:item] == cart_item[:item]
        if cart_item[:count] >= coupon[:num]
          coupon_hash = {}
          cart_item[:count] -= coupon[:num]
          coupon_hash = {:item => cart_item[:item] + " W/COUPON", :price => coupon[:cost] / coupon[:num], :clearance => cart_item[:clearance], :count => coupon[:num]}
          result_array << coupon_hash
        end
      end
      
      coupons_index += 1
    end
    result_array << cart_item
    cart_index += 1
  end
  return result_array
end

def apply_clearance(cart)
  result_array = []
  index = 0
  while cart.length > index do
    cart_item = cart[index]
    cart_item[:price] -= (cart_item[:price] * 0.2).round(2) if cart_item[:clearance]
    result_array << cart_item
    index += 1
  end
  result_array
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  cart_with_coupons = apply_coupons(consolidated_cart, coupons)
  cart_with_clearance = apply_clearance(cart_with_coupons)
  index = 0
  total = 0
  while cart_with_clearance.length > index do
    cart_item = cart_with_clearance[index]
    item_overall_cost = (cart_item[:count] * cart_item[:price]).round(2)
    total += item_overall_cost
    index += 1
  end
  total -= (total * 0.1).round(2) if total > 100
  total
end
