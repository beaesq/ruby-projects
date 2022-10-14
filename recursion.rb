def fibs(num)
  arr = []
  arr << 0 if num >= 1
  arr << 1 if num >= 2
  3.upto(num) do |i|
    arr << arr[i - 2] + arr[i - 3]
  end
  arr
end

def fibs_rec(num)
  arr = []
  num.times { |a| arr << fibonacci(a + 1) }
  arr
end

def fibonacci(i)
  return 0 if i <= 1
  return 1 if i == 2
  return fibonacci(i - 1) + fibonacci(i - 2)
end


# p "#{fibs(1)} // #{fibs_rec(1)}"
# p "#{fibs(2)} // #{fibs_rec(2)}"
# p "#{fibs(3)} // #{fibs_rec(3)}"
# p "#{fibs(5)} // #{fibs_rec(5)}"
# p "#{fibs(8)} // #{fibs_rec(8)}"
# p fibs(13) == fibs_rec(13)


def merge_sort(arr)
  return arr if arr.size == 1
  left_size = (arr.size / 2).floor
  right_size = arr.size - left_size
  left_arr = arr.slice(0, left_size)
  right_arr = arr.slice(left_size, right_size)
  sort(merge_sort(left_arr), merge_sort(right_arr))
end

def sort(left_arr, right_arr) 
  arr = []
  until (left_arr.size == 0 || right_arr.size == 0)
    if (left_arr[0] > right_arr[0]) 
      arr << right_arr.slice!(0)
    else
      arr << left_arr.slice!(0)
    end
  end
  arr += left_arr if left_arr.size > 0
  arr += right_arr if right_arr.size > 0
  return arr
end


p arr = [1,4,5,2,11,6,0,5]
p "sorted: #{merge_sort(arr)}"
p arr = [188,776,611,966,741,313,598]
p "sorted: #{merge_sort(arr)}"
