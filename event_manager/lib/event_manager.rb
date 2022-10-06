require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
require 'date'
require 'time'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zipcode)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    legislators = civic_info.representative_info_by_address(
      address: zipcode,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    )
    legislators = legislators.officials
    legislator_names = legislators.map(&:name)
    legislator_names.join(', ')
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

def save_phone_numbers(phone_number, id)
  return if phone_number.nil?

  Dir.mkdir('output') unless Dir.exist?('output')

  filename = 'output/phone_numbers.txt'
  File.open(filename, 'w') if id == '1'
  File.open(filename, 'a') do |file|
    file.puts phone_number
  end
end

def clean_phone_numbers(phone_number)
  phone_number = remove_non_integers(phone_number)

  case phone_number.length
  when 10 then phone_number
  when 11 then phone_number[0] == '1' ? phone_number[1..10] : nil
  else nil
  end
end

def remove_non_integers(phone_number)
  phone_number.gsub(/[^0-9]/, '')
end

def clean_reg_date(regdate)
  Time.strptime(regdate, "%m/%d/%y %H:%M")
end

def extract_hour(regtime)
  regtime.hour
end

def count_hours(regtime, reg_hours)
  hour = extract_hour(regtime)
  reg_hours[hour] = 0 unless reg_hours.key?(hour)
  reg_hours[hour] += 1
  save_time_targeting(reg_hours)
end

def save_time_targeting(reg_hours)
  return if reg_hours.nil?

  Dir.mkdir('output') unless Dir.exist?('output')

  filename = 'output/time_targeting.txt'
  File.open(filename, 'w') do |file|
    file.puts 'Peak Hours:'
    sorted = reg_hours.sort_by { |k, v| -v }
    sorted.each { |hour, count| file.puts "#{hour}:00 - #{count}" }
  end
end

def count_days(regtime, reg_days)
  day = convert_num_to_day(regtime.wday)
  reg_days[day] = 0 unless reg_days.key?(day)
  reg_days[day] += 1
  save_day_targeting(reg_days)
end

def save_day_targeting(reg_days)
  return if reg_days.nil?

  Dir.mkdir('output') unless Dir.exist?('output')

  filename = 'output/day_targeting.txt'
  File.open(filename, 'w') do |file|
    file.puts 'Peak Days:'
    sorted = reg_days.sort_by { |k, v| -v }
    sorted.each { |day, count| file.puts "#{day} - #{count}" }
  end
end

def convert_num_to_day(num)
  case num
  when 0 then 'Sunday'
  when 1 then 'Monday'
  when 2 then 'Tuesday'
  when 3 then 'Wednesday'
  when 4 then 'Thursday'
  when 5 then 'Friday'
  when 6 then 'Saturday'
  end
end

puts 'EventManager'

contents = CSV.open(
  'event_attendees.csv', 
  headers: true, 
  header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter
counter = 0

reg_hours = {}
reg_days = {}

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  phone_number = row[:homephone]
  regdate = clean_reg_date(row[:regdate])
  legislators = legislators_by_zipcode(zipcode)

  # count_hours(regdate, reg_hours)
  count_days(regdate, reg_days)

  # phone_number = clean_phone_numbers(phone_number)
  # save_phone_numbers(phone_number, id)
  #form_letter = erb_template.result(binding)
  #save_thank_you_letter(id, form_letter)
  counter += 1
end

puts "#{counter} items processed. Goodbye!"
