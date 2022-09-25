def stock_picker(prices)
  largest_diff = 0
  largest_diff_index_a = 0
  largest_diff_index_b = 0

  prices.each_with_index do |current_num, current_index|

    compare_array = prices[current_index + 1, prices.size]
    
    compare_array.each_with_index do |compare_num, compare_index|
      current_diff = compare_num - current_num
      if current_diff > largest_diff 
        largest_diff = current_diff
        largest_diff_index_a = current_index
        largest_diff_index_b = current_index + compare_index + 1
      end
    
    end  
  
  end  

  if largest_diff_index_a == 0 && largest_diff_index_b == 0 
    p "do not buy or sell"
  else 
    largest_diff_index = Array[largest_diff_index_a, largest_diff_index_b]
    p largest_diff_index
  end
  # p largest_diff
  
end  

stock_picker([17,3,6,9,15,8,6,1,10])

# compare current num and next avail (iterate for each next num)
# If current diff greater than largest diff
#   Save current nums index and compared nums index to array
# Print array