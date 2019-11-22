# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# <<<<<<< HEAD
set :output, "log/cron.log"

every 1.day do # 1.minute 1.day 1.week 1.month 1.year is also supported
  rake "reminder_emails:send_annual_reminder_email"
  rake "reminder_emails:send_first_warning_email"
  rake "reminder_emails:send_second_warning_email"
  rake "reminder_emails:send_third_warning_email"
end
# =======
# # Learn more: http://github.com/javan/whenever
#
# set :environment, "development"
# set :output, "log/cron.log"
#
# every 10.minute do
#     #puts "HELLO MELISSA"
#     #rake " broken_URL:broken_URLs"
# end
# >>>>>>> brokenurl
