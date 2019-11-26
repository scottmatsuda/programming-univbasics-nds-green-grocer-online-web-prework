def find_item_by_name_in_collection(name, collection)
  
  index = 0
  
  while index < collection.length do
    if collection[index][:item] == name
      return collection[index]
    else
      nil
    end
  index += 1
  end
  
end

def consolidate_cart(cart)
  result = []
  count_hash = {}
  index = 0
  
  # create an intermediary hash with a key of the item name and a value of count, i.e. how many of the items there are in the cart
  while index < cart.length do
   item_name = cart[index][:item]
   if count_hash[item_name]
     count_hash[item_name] += 1
   else 
     count_hash[item_name] = 1
   end
  index += 1
  end
 
 # iterate through the cart array, assigning a count key for items that are in the hash_count hash
 
 index = 0
  while index < cart.length do
    product = cart[index]
    if count_hash[product[:item]] > 0
      product[:count] = count_hash[product[:item]]
      result << product
    end
    count_hash[product[:item]] = 0
    index += 1
    
  end
 return result
end

def apply_coupons(cart, coupons)
  
  result = []
  
  cart_index = 0
  while cart_index < cart.length do
    cart_item = cart[cart_index]
    coupons_index = 0
    while coupons_index < coupons.length do
      coupon_item = coupons[coupons_index]
      if coupon_item[:item] == cart_item[:item] 
        if cart_item[:count] >= coupon_item[:num]
          cart_item[:count] -= coupon_item[:num]
          coupon_hash = {}
          coupon_hash[:item] = cart_item[:item] + " W/COUPON"
          coupon_hash[:price] = coupon_item[:cost] / coupon_item[:num]
          coupon_hash[:clearance] = cart_item[:clearance] 
          coupon_hash[:count] = coupon_item[:num]
          result << coupon_hash
        end
      end
      coupons_index += 1  
    end 
    
    result << cart_item
    cart_index += 1
  end
  
  return result
end

def apply_clearance(cart)
  
  result = []
  index = 0
  
  while index < cart.length do
    cart_item = cart[index]
    cart_item[:price] -= (cart_item[:price] * 0.2).round(2) if cart_item[:clearance]
    result << cart[index]
    index += 1
  end
  
  return result
end

def checkout(cart, coupons)
  
  total = 0
  index = 0
  
  consolidated_cart = consolidate_cart(cart)
  applied_coupons = apply_coupons(consolidated_cart, coupons)
  applied_clearance = apply_clearance(applied_coupons)
  while index < applied_clearance.length do
    total += applied_clearance[index][:price] * applied_clearance[index][:count]
    index += 1
  end
 
  if total > 100
    total = total * 9/10
  end
  
  return total.round(2)
   
end

